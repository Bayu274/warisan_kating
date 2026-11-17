import 'package:cloud_firestore/cloud_firestore.dart';

/// Metadata for a chat session between two users about an item.
class ChatRoom {
  final String id;
  final String itemId;
  final List<String> participants; // exactly 2 user IDs
  final String lastMessage;
  final DateTime updatedAt;

  const ChatRoom({
    required this.id,
    required this.itemId,
    required this.participants,
    required this.lastMessage,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'itemId': itemId,
        'participants': participants,
        'lastMessage': lastMessage,
        'updatedAt': Timestamp.fromDate(updatedAt),
      };

  factory ChatRoom.fromMap(Map<String, dynamic> map) => ChatRoom(
        id: map['id'] as String,
        itemId: map['itemId'] as String,
        participants: List<String>.from(map['participants'] as List),
        lastMessage: map['lastMessage'] as String,
        updatedAt: (map['updatedAt'] as Timestamp).toDate(),
      );
}
