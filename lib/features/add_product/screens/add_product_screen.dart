import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:warisan_kating/services/image_picker_service.dart';
import 'package:warisan_kating/services/item_service.dart';
import 'package:warisan_kating/shared/models/item_model.dart';

const _uuid = Uuid();

/// Categories the seller can pick from.
const List<String> _conditions = [
  'Baru',
  'Bekas - Layak',
  'Bekas - Perlu Perbaikan',
];

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();

  String _condition = _conditions.first;
  File? _imageFile;
  bool _submitting = false;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    super.dispose();
  }

  // ---- image picking ----

  Future<void> _pickImage(BuildContext context) async {
    final source = await showModalBottomSheet<_ImageSourceChoice>(
      context: context,
      builder: (_) => const _ImageSourceSheet(),
    );
    if (source == null) return;
    if (!context.mounted) return;

    final service = context.read<ImagePickerService>();
    final file = switch (source) {
      _ImageSourceChoice.camera => await service.pickFromCamera(),
      _ImageSourceChoice.gallery => await service.pickFromGallery(),
    };
    if (!context.mounted) return;

    if (file != null && mounted) {
      setState(() => _imageFile = file);

      final size = await file.length();
      if (!context.mounted) return;
      final kb = (size / 1024).toStringAsFixed(1);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Image compressed to $kb KB'), duration: const Duration(seconds: 2)),
      );
    }
  }

  // ---- submit ----

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    try {
      final item = Item(
        id: _uuid.v4(),
        title: _titleCtrl.text.trim(),
        description: _descCtrl.text.trim(),
        price: double.tryParse(_priceCtrl.text.trim()) ?? 0,
        condition: _condition,
        imageUrl: '', // set by service after upload
        sellerId: 'current-user', // TODO: replace with auth user id
        timestamp: DateTime.now(),
      );

      await context.read<ItemService>().addItem(item, imageFile: _imageFile);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Barang berhasil ditambahkan!')),
      );

      // Reset form
      _formKey.currentState!.reset();
      _titleCtrl.clear();
      _descCtrl.clear();
      _priceCtrl.clear();
      setState(() {
        _imageFile = null;
        _condition = _conditions.first;
      });
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan: $e')),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  // ---- build ----

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Barang')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- image picker area ---
              _ImagePreview(
                file: _imageFile,
                onTap: () => _pickImage(context),
              ),
              const SizedBox(height: 20),

              // --- title ---
              TextFormField(
                controller: _titleCtrl,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Judul wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              // --- description ---
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                textInputAction: TextInputAction.next,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Deskripsi wajib diisi' : null,
              ),
              const SizedBox(height: 14),

              // --- price ---
              TextFormField(
                controller: _priceCtrl,
                decoration: const InputDecoration(
                  labelText: 'Harga (Rp) — kosongkan jika barter/gratis',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 14),

              // --- condition dropdown ---
              DropdownButtonFormField<String>(
                initialValue: _condition,
                decoration: const InputDecoration(
                  labelText: 'Kondisi',
                  border: OutlineInputBorder(),
                ),
                items: _conditions
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) {
                  if (v != null) setState(() => _condition = v);
                },
              ),
              const SizedBox(height: 24),

              // --- submit button ---
              FilledButton.icon(
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload),
                label: Text(_submitting ? 'Mengunggah...' : 'Simpan Barang'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ---- private helper widgets ----

enum _ImageSourceChoice { camera, gallery }

class _ImageSourceSheet extends StatelessWidget {
  const _ImageSourceSheet();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto'),
              onTap: () => Navigator.pop(context, _ImageSourceChoice.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () => Navigator.pop(context, _ImageSourceChoice.gallery),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImagePreview extends StatelessWidget {
  final File? file;
  final VoidCallback onTap;

  const _ImagePreview({required this.file, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[400]!),
        ),
        clipBehavior: Clip.antiAlias,
        child: file != null
            ? Image.file(file!, fit: BoxFit.cover, width: double.infinity)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_a_photo, size: 48, color: Colors.grey[500]),
                  const SizedBox(height: 8),
                  Text(
                    'Tambah Foto',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
      ),
    );
  }
}
