import 'package:image_picker/image_picker.dart';

enum ImagePickSource { gallery, camera }

/// Thin wrapper around the native image picker.
class AppImagePicker {
  AppImagePicker({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<XFile?> pick(ImagePickSource source) {
    return _picker.pickImage(
      source: source == ImagePickSource.gallery
          ? ImageSource.gallery
          : ImageSource.camera,
      // Prefer originals; we compress ourselves for Gemini upload.
      requestFullMetadata: true,
    );
  }
}
