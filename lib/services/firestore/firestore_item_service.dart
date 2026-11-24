import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:warisan_kating/core/constants/app_constants.dart';
import 'package:warisan_kating/services/item_service.dart';
import 'package:warisan_kating/shared/models/item_model.dart';

/// Production [ItemService] backed by Cloud Firestore + Firebase Storage.
class FirestoreItemService implements ItemService {
  FirestoreItemService({FirebaseFirestore? firestore, FirebaseStorage? storage})
    : _firestore = firestore ?? FirebaseFirestore.instance,
      _storage = storage ?? FirebaseStorage.instance;

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  static const _uuid = Uuid();

  CollectionReference<Map<String, dynamic>> get _col =>
      _firestore.collection(AppConstants.productsCollection);

  CollectionReference<Map<String, dynamic>> get _categories =>
      _firestore.collection(AppConstants.categoriesCollection);

  @override
  Stream<List<String>> categoriesStream() {
    return _categories
        .snapshots()
        .map((snapshot) {
          final categories =
              <String>{
                  ...AppConstants.defaultCategories,
                  ...snapshot.docs
                      .map((doc) => doc.data()['name'] as String? ?? doc.id)
                      .where((name) => name.trim().isNotEmpty),
                }.toList()
                ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
          return categories;
        })
        .handleError((Object error) {
          throw Exception('Categories stream error: $error');
        });
  }

  @override
  Future<void> addCategory(String category) async {
    final name = category.trim();
    if (name.isEmpty) return;
    final id = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    if (id.isEmpty) {
      throw ArgumentError.value(
        category,
        'category',
        'Nama kategori tidak valid',
      );
    }
    await _categories.doc(id).set({'name': name}, SetOptions(merge: true));
  }

  // ---------------------------------------------------------------------------
  // READ
  // ---------------------------------------------------------------------------

  @override
  Future<List<Item>> getItems() async {
    try {
      final snap = await _col.orderBy('timestamp', descending: true).get();
      return snap.docs.map((d) => Item.fromMap(d.data())).toList();
    } on FirebaseException catch (e) {
      throw Exception('Failed to fetch items: ${e.message}');
    }
  }

  @override
  Stream<List<Item>> itemsStream() {
    return _col
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => Item.fromMap(d.data())).toList())
        .handleError((Object e) {
          throw Exception('Items stream error: $e');
        });
  }

  @override
  Future<Item?> getItemById(String id) async {
    try {
      final doc = await _col.doc(id).get();
      if (!doc.exists || doc.data() == null) return null;
      return Item.fromMap(doc.data()!);
    } on FirebaseException catch (e) {
      throw Exception('Failed to get item $id: ${e.message}');
    }
  }

  // ---------------------------------------------------------------------------
  // CREATE
  // ---------------------------------------------------------------------------

  @override
  Future<void> addItem(Item item, {File? imageFile}) async {
    try {
      final id = item.id.isEmpty ? _uuid.v4() : item.id;

      // Upload image if provided
      String imageUrl = item.imageUrl;
      if (imageFile != null) {
        imageUrl = await _uploadImage(imageFile, id);
      }

      final savedItem = item.copyWith(id: id, imageUrl: imageUrl);
      await _col.doc(id).set(savedItem.toMap());
    } on FirebaseException catch (e) {
      throw Exception('Failed to add item: ${e.message}');
    }
  }

  // ---------------------------------------------------------------------------
  // UPDATE
  // ---------------------------------------------------------------------------

  @override
  Future<void> updateItem(Item item) async {
    try {
      await _col.doc(item.id).update(item.toMap());
    } on FirebaseException catch (e) {
      throw Exception('Failed to update item ${item.id}: ${e.message}');
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------

  @override
  Future<void> deleteItem(String id) async {
    try {
      // Delete storage image (best-effort; ignore if missing)
      try {
        await _storage.ref('items/$id.jpg').delete();
      } catch (_) {}

      await _col.doc(id).delete();
    } on FirebaseException catch (e) {
      throw Exception('Failed to delete item $id: ${e.message}');
    }
  }

  // ---------------------------------------------------------------------------
  // PRIVATE — image upload
  // ---------------------------------------------------------------------------

  /// Uploads [file] to `items/<itemId>.jpg` and returns the download URL.
  Future<String> _uploadImage(File file, String itemId) async {
    final ref = _storage.ref('items/$itemId.jpg');
    final uploadTask = ref.putFile(
      file,
      SettableMetadata(contentType: 'image/jpeg'),
    );

    final snapshot = await uploadTask;
    return snapshot.ref.getDownloadURL();
  }
}
