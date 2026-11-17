import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:warisan_kating/core/constants/app_constants.dart';
import 'package:warisan_kating/services/chat_service.dart';
import 'package:warisan_kating/shared/models/chat_message_model.dart';
import 'package:warisan_kating/shared/models/chat_room_model.dart';

class FirestoreChatService implements ChatService {
  FirestoreChatService({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;
  static const _uuid = Uuid();

  CollectionReference<Map<String, dynamic>> get _rooms =>
      _db.collection(AppConstants.chatsCollection);

  // ---------------------------------------------------------------------------
  // Room management
  // ---------------------------------------------------------------------------

  @override
  Future<ChatRoom> getOrCreateRoom({
    required String userId,
    required String peerId,
    required String itemId,
  }) async {
    try {
      // Look for an existing room with both participants for this item.
      final snap = await _rooms
          .where('participants', arrayContains: userId)
          .where('itemId', isEqualTo: itemId)
          .get();

      for (final doc in snap.docs) {
        final participants = List<String>.from(doc.data()['participants'] as List);
        if (participants.contains(peerId)) {
          return ChatRoom.fromMap(doc.data());
        }
      }

      // None found — create a new room.
      final room = ChatRoom(
        id: _uuid.v4(),
        itemId: itemId,
        participants: [userId, peerId],
        lastMessage: '',
        updatedAt: DateTime.now(),
      );
      await _rooms.doc(room.id).set(room.toMap());
      return room;
    } on FirebaseException catch (e) {
      throw Exception('Failed to get/create chat room: ${e.message}');
    }
  }

  // ---------------------------------------------------------------------------
  // Streams
  // ---------------------------------------------------------------------------

  @override
  Stream<List<ChatRoom>> roomsStream(String userId) {
    return _rooms
        .where('participants', arrayContains: userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => ChatRoom.fromMap(d.data())).toList())
        .handleError((Object e) {
      throw Exception('Chat rooms stream error: $e');
    });
  }

  @override
  Stream<List<ChatMessage>> messagesStream(String chatId) {
    return _rooms
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((s) => s.docs.map((d) => ChatMessage.fromMap(d.data())).toList())
        .handleError((Object e) {
      throw Exception('Messages stream error: $e');
    });
  }

  // ---------------------------------------------------------------------------
  // Send
  // ---------------------------------------------------------------------------

  @override
  Future<void> sendMessage(String chatId, ChatMessage message) async {
    try {
      final msgWithId = message.copyWith(
        id: message.id.isEmpty ? _uuid.v4() : message.id,
      );

      final batch = _db.batch();

      // Write message to subcollection
      batch.set(
        _rooms.doc(chatId).collection('messages').doc(msgWithId.id),
        msgWithId.toMap(),
      );

      // Update room metadata
      batch.update(_rooms.doc(chatId), {
        'lastMessage': msgWithId.text,
        'updatedAt': Timestamp.fromDate(msgWithId.timestamp),
      });

      await batch.commit();
    } on FirebaseException catch (e) {
      throw Exception('Failed to send message: ${e.message}');
    }
  }
}
