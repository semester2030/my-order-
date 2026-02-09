import 'dart:io';

import 'package:image_picker/image_picker.dart';

/// خدمة اختيار الصور والفيديو من المعرض أو الكاميرا — Phase 15.
class ImagePickerService {
  ImagePickerService({ImagePicker? picker}) : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  /// اختيار صورة من المعرض.
  Future<File?> pickImageFromGallery() async {
    final xFile = await _picker.pickImage(source: ImageSource.gallery);
    if (xFile == null) return null;
    return File(xFile.path);
  }

  /// التقاط صورة من الكاميرا.
  Future<File?> pickImageFromCamera() async {
    final xFile = await _picker.pickImage(source: ImageSource.camera);
    if (xFile == null) return null;
    return File(xFile.path);
  }

  /// اختيار فيديو من المعرض.
  Future<File?> pickVideoFromGallery() async {
    final xFile = await _picker.pickVideo(source: ImageSource.gallery);
    if (xFile == null) return null;
    return File(xFile.path);
  }

  /// تسجيل فيديو من الكاميرا.
  Future<File?> pickVideoFromCamera() async {
    final xFile = await _picker.pickVideo(source: ImageSource.camera);
    if (xFile == null) return null;
    return File(xFile.path);
  }
}
