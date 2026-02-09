/// رفع الملفات إلى الخادم — Phase 15 (واجهة + تنفيذ بسيط/ستب).
abstract interface class FileUploader {
  /// رفع ملف وإرجاع الرابط النهائي إن نجح.
  /// [filePath]: مسار الملف المحلي.
  /// [fieldName]: اسم الحقل في الطلب (مثلاً "file" أو "image").
  /// Returns: URL of uploaded file or null on failure.
  Future<String?> upload(String filePath, {String fieldName = 'file'});
}
