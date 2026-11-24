import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warisan_kating/core/constants/app_constants.dart';
import 'package:warisan_kating/core/router/app_router.dart';
import 'package:warisan_kating/services/item_service.dart';
import 'package:warisan_kating/shared/models/item_model.dart';
import 'package:warisan_kating/shared/widgets/empty_state_widget.dart';
import 'package:warisan_kating/shared/widgets/error_state_widget.dart';
import 'package:warisan_kating/shared/widgets/item_card.dart';
import 'package:warisan_kating/shared/widgets/search_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  late final ItemService _itemService;
  late final Stream<List<Item>> _itemsStream;
  late final Stream<List<String>> _categoriesStream;
  String _query = '';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _itemService = context.read<ItemService>();
    _itemsStream = _itemService.itemsStream();
    _categoriesStream = _itemService.categoriesStream();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Item> _filterItems(List<Item> items) {
    final query = _query.trim().toLowerCase();
    return items.where((item) {
      final matchesQuery =
          query.isEmpty ||
          item.title.toLowerCase().contains(query) ||
          item.description.toLowerCase().contains(query);
      final matchesCategory =
          _selectedCategory == null ||
          item.category.toLowerCase() == _selectedCategory!.toLowerCase();
      return matchesQuery && matchesCategory;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Warisan Kating'),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: colors.primaryContainer,
              child: Icon(Icons.person_outline_rounded, color: colors.primary),
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              child: SearchBarWidget(
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
              ),
            ),
            SizedBox(
              height: 44,
              child: StreamBuilder<List<String>>(
                stream: _categoriesStream,
                builder: (context, categorySnapshot) {
                  final categories =
                      <String>{
                        ...AppConstants.defaultCategories,
                        ...?categorySnapshot.data,
                      }.toList()..sort(
                        (a, b) => a.toLowerCase().compareTo(b.toLowerCase()),
                      );
                  if (_selectedCategory != null &&
                      !categories.any(
                        (category) =>
                            category.toLowerCase() ==
                            _selectedCategory!.toLowerCase(),
                      )) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _selectedCategory = null);
                    });
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length + 1,
                    separatorBuilder: (context, index) =>
                        const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final category = index == 0
                          ? null
                          : categories[index - 1];
                      final selected = category == _selectedCategory;
                      return ChoiceChip(
                        label: Text(category ?? 'Semua'),
                        selected: selected,
                        showCheckmark: false,
                        onSelected: (_) =>
                            setState(() => _selectedCategory = category),
                        labelStyle: TextStyle(
                          color: selected ? colors.onPrimary : colors.onSurface,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                        ),
                        selectedColor: colors.primary,
                        backgroundColor: colors.surface,
                        side: BorderSide(
                          color: selected
                              ? colors.primary
                              : colors.outlineVariant,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 22, 16, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedCategory == null
                          ? 'Barang pilihan'
                          : _selectedCategory!,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                  if (_query.isNotEmpty)
                    Text(
                      'Hasil pencarian',
                      style: Theme.of(context).textTheme.bodySmall
                          ?.copyWith(color: colors.onSurfaceVariant),
                    ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Item>>(
                stream: _itemsStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 12),
                          Text('Memuat barang...'),
                        ],
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return ErrorStateWidget(
                      message:
                          'Barang gagal dimuat. Periksa koneksi lalu coba lagi.\n${snapshot.error}',
                    );
                  }

                  final allItems = snapshot.data ?? const <Item>[];
                  if (allItems.isEmpty) {
                    return const EmptyStateWidget(
                      icon: Icons.storefront_outlined,
                      title: 'Belum ada barang',
                      subtitle:
                          'Barang yang diunggah mahasiswa akan muncul di sini.',
                    );
                  }

                  final items = _filterItems(allItems);
                  if (items.isEmpty) {
                    return EmptyStateWidget(
                      icon: Icons.search_off_rounded,
                      title: 'Barang tidak ditemukan',
                      subtitle: 'Coba kata kunci atau kategori lain.',
                    );
                  }

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      final columns = width >= 900
                          ? 4
                          : width >= 600
                          ? 3
                          : 2;
                      return GridView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 12,
                          childAspectRatio: width < 360 ? 0.60 : 0.64,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) => ItemCard(
                          item: items[index],
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRouter.itemDetail,
                            arguments: items[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
