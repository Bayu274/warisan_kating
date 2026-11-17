import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:warisan_kating/core/router/app_router.dart';
import 'package:warisan_kating/services/barter_service.dart';
import 'package:warisan_kating/services/chat_service.dart';
import 'package:warisan_kating/shared/models/barter_model.dart';
import 'package:warisan_kating/shared/models/item_model.dart';

const _uuid = Uuid();
const _currentUser = 'current-user'; // TODO: replace with auth

class ItemDetailScreen extends StatelessWidget {
  final Item item;

  const ItemDetailScreen({super.key, required this.item});

  String get _priceLabel {
    if (item.price <= 0) return 'Barter / Gratis';
    return 'Rp ${item.price.toStringAsFixed(0)}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(item.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- hero image with loading indicator ----
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: Colors.grey[200],
                width: double.infinity,
                child: item.imageUrl.isNotEmpty
                    ? Image.network(
                        item.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (_, child, progress) {
                          if (progress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              value: progress.expectedTotalBytes != null
                                  ? progress.cumulativeBytesLoaded /
                                      progress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => _placeholder(),
                      )
                    : _placeholder(),
              ),
            ),

            // ---- info section ----
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  Text(_priceLabel,
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 12),
                  _infoChip(Icons.category, item.condition),
                  const SizedBox(height: 6),
                  _infoChip(Icons.person_outline, 'Seller: ${item.sellerId}'),
                  const SizedBox(height: 6),
                  _infoChip(Icons.access_time, _fmtDate(item.timestamp)),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text('Deskripsi', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  Text(item.description, style: theme.textTheme.bodyLarge),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _showBarterDialog(context),
                  icon: const Icon(Icons.swap_horiz),
                  label: const Text('Ajukan Barter'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _openChat(context),
                  icon: const Icon(Icons.chat_bubble_outline),
                  label: const Text('Hubungi'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- chat ----

  Future<void> _openChat(BuildContext context) async {
    // Show loading while finding/creating room
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final room = await context.read<ChatService>().getOrCreateRoom(
            userId: _currentUser,
            peerId: item.sellerId,
            itemId: item.id,
          );

      if (!context.mounted) return;
      Navigator.pop(context); // dismiss loader
      Navigator.pushNamed(context, AppRouter.chatRoom, arguments: {
        'chatId': room.id,
        'peerName': item.sellerId,
      });
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // dismiss loader
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Gagal membuka chat: $e')));
    }
  }

  // ---- barter dialog ----

  void _showBarterDialog(BuildContext context) {
    final msgCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajukan Barter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Kamu ingin barter untuk "${item.title}"'),
            const SizedBox(height: 12),
            TextField(
              controller: msgCtrl,
              decoration: const InputDecoration(
                labelText: 'Pesan / tawarkan barang',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              final barter = Barter(
                id: _uuid.v4(),
                itemId: item.id,
                offerItemId: '',
                requesterId: _currentUser,
                ownerId: item.sellerId,
                message: msgCtrl.text.trim(),
                status: BarterStatus.pending,
                createdAt: DateTime.now(),
              );
              try {
                await ctx.read<BarterService>().createRequest(barter);
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Permintaan barter terkirim!')),
                );
              } catch (e) {
                if (!ctx.mounted) return;
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal mengirim: $e')),
                );
              }
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  // ---- helpers ----

  Widget _placeholder() =>
      Center(child: Icon(Icons.image_outlined, size: 64, color: Colors.grey[400]));

  Widget _infoChip(IconData icon, String label) => Row(children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Flexible(child: Text(label, style: TextStyle(color: Colors.grey[700]))),
      ]);

  String _fmtDate(DateTime dt) => '${dt.day}/${dt.month}/${dt.year}';
}
