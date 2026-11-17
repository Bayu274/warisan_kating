import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warisan_kating/core/router/app_router.dart';
import 'package:warisan_kating/services/chat_service.dart';
import 'package:warisan_kating/shared/models/chat_room_model.dart';
import 'package:warisan_kating/shared/widgets/empty_state_widget.dart';
import 'package:warisan_kating/shared/widgets/error_state_widget.dart';

/// Lists all chat rooms for the current user.
class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  // TODO: replace with auth user id
  static const _currentUser = 'current-user';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: StreamBuilder<List<ChatRoom>>(
        stream: context.read<ChatService>().roomsStream(_currentUser),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return ErrorStateWidget(
              message: 'Gagal memuat percakapan.\n${snapshot.error}',
            );
          }

          final rooms = snapshot.data ?? [];

          if (rooms.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.chat_outlined,
              title: 'Belum ada percakapan',
              subtitle: 'Mulai chat dengan menekan tombol "Hubungi" di halaman produk.',
            );
          }

          return ListView.separated(
            itemCount: rooms.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final room = rooms[index];
              final peer = room.participants.firstWhere(
                (p) => p != _currentUser,
                orElse: () => 'Unknown',
              );

              return ListTile(
                leading: CircleAvatar(child: Text(peer[0].toUpperCase())),
                title: Text(peer),
                subtitle: Text(
                  room.lastMessage.isEmpty ? 'Belum ada pesan' : room.lastMessage,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(
                  _formatTime(room.updatedAt),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                onTap: () => Navigator.pushNamed(
                  context,
                  AppRouter.chatRoom,
                  arguments: {'chatId': room.id, 'peerName': peer},
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
}
