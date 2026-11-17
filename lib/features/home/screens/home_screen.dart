import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warisan_kating/core/router/app_router.dart';
import 'package:warisan_kating/services/item_service.dart';
import 'package:warisan_kating/shared/models/item_model.dart';
import 'package:warisan_kating/shared/widgets/item_card.dart';
import 'package:warisan_kating/shared/widgets/search_bar_widget.dart';
import 'package:warisan_kating/shared/widgets/empty_state_widget.dart';
import 'package:warisan_kating/shared/widgets/error_state_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Warisan Kating')),
      body: Column(
        children: [
          const SearchBarWidget(),
          Expanded(
            child: StreamBuilder<List<Item>>(
              stream: context.read<ItemService>().itemsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return ErrorStateWidget(
                    message: 'Gagal memuat data.\n${snapshot.error}',
                  );
                }

                final items = snapshot.data ?? [];

                if (items.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.storefront_outlined,
                    title: 'Belum ada barang',
                    subtitle: 'Jadilah yang pertama menambahkan barang!',
                  );
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

                    return GridView.builder(
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) => ItemCard(
                        item: items[index],
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            AppRouter.itemDetail,
                            arguments: items[index],
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
