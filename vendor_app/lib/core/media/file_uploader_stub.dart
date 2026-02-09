import 'file_uploader.dart';

/// Stub لرفع الملفات حتى ربط الـ API — Phase 15.
class FileUploaderStub implements FileUploader {
  @override
  Future<String?> upload(String filePath, {String fieldName = 'file'}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // محاكاة: إرجاع رابط وهمي
    return 'https://example.com/uploads/${DateTime.now().millisecondsSinceEpoch}';
  }
}
