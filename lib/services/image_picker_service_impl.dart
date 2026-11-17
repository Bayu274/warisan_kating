import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:warisan_kating/services/image_picker_service.dart';

/// Real implementation: picks an image then compresses to ≤ 300 KB.
class ImagePickerServiceImpl implements ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  // ---- public API ----

  @override
  Future<File?> pickFromGallery() => _pickAndCompress(ImageSource.gallery);

  @override
  Future<File?> pickFromCamera() => _pickAndCompress(ImageSource.camera);

  // ---- internals ----

  Future<File?> _pickAndCompress(ImageSource source) async {
    final XFile? picked = await _picker.pickImage(
      source: source,
      // first-pass resize so we're not feeding a 20 MB raw file to the
      // compressor — keeps UX snappy on low-end devices.
      maxWidth: 1280,
      maxHeight: 1280,
    );
    if (picked == null) return null;

    return _compressToTarget(File(picked.path));
  }

  /// Iteratively lowers JPEG quality until the file is ≤ [maxBytes].
  /// Starts at quality 90 and steps down by 10 each pass.
  Future<File> _compressToTarget(
    File original, {
    int maxBytes = 300 * 1024, // 300 KB
  }) async {
    int quality = 90;
    File current = original;

    while (quality >= 10) {
      final XFile? result = await FlutterImageCompress.compressAndGetFile(
        current.absolute.path,
        _targetPath(original.path, quality),
        quality: quality,
        format: CompressFormat.jpeg,
      );

      if (result == null) break; // compression failed — use what we have

      final compressed = File(result.path);
      if (await compressed.length() <= maxBytes) return compressed;

      quality -= 10;
    }

    // If we exit the loop, return the last compressed result (best effort).
    return current;
  }

  /// Generates a unique output path so compressor doesn't overwrite the source.
  String _targetPath(String sourcePath, int quality) {
    final dir = sourcePath.substring(0, sourcePath.lastIndexOf('/'));
    final ts = DateTime.now().millisecondsSinceEpoch;
    return '$dir/compressed_${ts}_q$quality.jpg';
  }
}
