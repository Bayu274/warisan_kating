import 'dart:async';

import 'package:uuid/uuid.dart';
import 'package:warisan_kating/services/chat_service.dart';
import 'package:warisan_kating/shared/models/chat_message_model.dart';
import 'package:warisan_kating/shared/models/chat_room_model.dart';

/// In-memory mock for chat operations.
class MockChatService implements ChatService {
  static const _uuid = Uuid();

  final Map<String, ChatRoom> _rooms = {};
  final Map<String, List<ChatMessage>> _messages = {};
  final Map<String, StreamController<List<ChatMessage>>> _msgCtrls = {};
  final StreamController<List<ChatRoom>> _roomCtrl =
      StreamController<List<ChatRoom>>.broadcast();

  @override
  Future<ChatRoom> getOrCreateRoom({
    required String userId,
    required String peerId,
    required String itemId,
  }) async {
    for (final room in _rooms.values) {
      if (room.itemId == itemId &&
          room.participants.contains(userId) &&
          room.participants.contains(peerId)) {
        return room;
      }
    }
    final room = ChatRoom(
      id: _uuid.v4(),
      itemId: itemId,
      participants: [userId, peerId],
      lastMessage: '',
      updatedAt: DateTime.now(),
    );
    _rooms[room.id] = room;
    _roomCtrl.add(_rooms.values.toList());
    return room;
  }

  @override
  Stream<List<ChatRoom>> roomsStream(String userId) =>
      _roomCtrl.stream.map((rooms) =>
          rooms.where((r) => r.participants.contains(userId)).toList());

  @override
  Stream<List<ChatMessage>> messagesStream(String chatId) {
    _msgCtrls.putIfAbsent(
        chatId, () => StreamController<List<ChatMessage>>.broadcast());
    return _msgCtrls[chatId]!.stream;
  }

  @override
  Future<void> sendMessage(String chatId, ChatMessage message) async {
    _messages.putIfAbsent(chatId, () => []);
    _messages[chatId]!.add(message.copyWith(id: _uuid.v4()));
    _msgCtrls[chatId]?.add(List.unmodifiable(_messages[chatId]!));
  }
}
