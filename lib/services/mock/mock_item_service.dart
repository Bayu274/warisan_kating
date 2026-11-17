import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:warisan_kating/services/item_service.dart';
import 'package:warisan_kating/shared/models/item_model.dart';

/// In-memory mock so UI can be built & tested without Firebase.
class MockItemService implements ItemService {
  static const _uuid = Uuid();

  final List<Item> _items = [
    Item(
      id: 'mock-1',
      title: 'Jaket Denim Vintage',
      description: 'Jaket denim second, kondisi 90%.',
      price: 75000,
      condition: 'Bekas - Layak',
      imageUrl: 'https://via.placeholder.com/300',
      sellerId: 'user-1',
      timestamp: DateTime(2026, 11, 1),
    ),
    Item(
      id: 'mock-2',
      title: 'Buku Kalkulus Edisi 10',
      description: 'Buku kalkulus bekas semester 1.',
      price: 40000,
      condition: 'Bekas - Layak',
      imageUrl: 'https://via.placeholder.com/300',
      sellerId: 'user-2',
      timestamp: DateTime(2026, 11, 5),
    ),
  ];

  @override
  Future<List<Item>> getItems() async => List.unmodifiable(_items);

  @override
  Stream<List<Item>> itemsStream() => Stream.value(List.unmodifiable(_items));

  @override
  Future<Item?> getItemById(String id) async =>
      _items.where((i) => i.id == id).firstOrNull;

  @override
  Future<void> addItem(Item item, {File? imageFile}) async {
    _items.add(item.copyWith(id: _uuid.v4()));
  }

  @override
  Future<void> updateItem(Item item) async {
    final idx = _items.indexWhere((i) => i.id == item.id);
    if (idx != -1) _items[idx] = item;
  }

  @override
  Future<void> deleteItem(String id) async {
    _items.removeWhere((i) => i.id == id);
  }
}
