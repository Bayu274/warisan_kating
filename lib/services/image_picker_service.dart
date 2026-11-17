import 'dart:io';

/// Contract for picking and compressing images.
abstract class ImagePickerService {
  /// Pick from gallery, compress, return compressed file (or null if cancelled).
  Future<File?> pickFromGallery();

  /// Pick from camera, compress, return compressed file (or null if cancelled).
  Future<File?> pickFromCamera();
}
