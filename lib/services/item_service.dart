import 'dart:io';

import 'package:warisan_kating/shared/models/item_model.dart';

/// Contract for item/product data operations.
abstract class ItemService {
  /// One-shot fetch of all items.
  Future<List<Item>> getItems();

  /// Real-time stream of all items (ordered by newest first).
  Stream<List<Item>> itemsStream();

  Future<Item?> getItemById(String id);

  /// Add an item. If [imageFile] is provided, the implementation should
  /// upload it to remote storage and set the resulting URL on the item.
  Future<void> addItem(Item item, {File? imageFile});

  Future<void> updateItem(Item item);
  Future<void> deleteItem(String id);
}
