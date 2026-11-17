import 'dart:io';

import 'package:warisan_kating/services/image_picker_service.dart';

/// Returns null for every call — safe for unit tests and desktop builds.
class MockImagePickerService implements ImagePickerService {
  @override
  Future<File?> pickFromGallery() async => null;

  @override
  Future<File?> pickFromCamera() async => null;
}
