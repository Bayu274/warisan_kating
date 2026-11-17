import 'package:warisan_kating/shared/models/chat_message_model.dart';
import 'package:warisan_kating/shared/models/chat_room_model.dart';

/// Contract for chat operations.
abstract class ChatService {
  /// Find an existing chat between [userId] and [peerId] for [itemId],
  /// or create a new one. Returns the [ChatRoom].
  Future<ChatRoom> getOrCreateRoom({
    required String userId,
    required String peerId,
    required String itemId,
  });

  /// Stream all chat rooms the [userId] participates in, newest first.
  Stream<List<ChatRoom>> roomsStream(String userId);

  /// Stream messages inside a chat room, ordered oldest → newest.
  Stream<List<ChatMessage>> messagesStream(String chatId);

  /// Send a message and update the room's lastMessage / updatedAt.
  Future<void> sendMessage(String chatId, ChatMessage message);
}
