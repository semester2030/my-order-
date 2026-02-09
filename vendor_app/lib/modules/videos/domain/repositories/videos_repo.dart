import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;
import 'package:vendor_app/modules/videos/data/datasources/videos_remote_ds.dart';

/// مستودع رفع الفيديو/الملفات — Phase 15 + حد 20 مقطع لكل طباخ.
abstract interface class VideosRepo {
  /// عدد مقاطع الفيديو الحالية (الحد الأقصى 20).
  Future<res.Result<int, Failure>> getVendorVideoCount();

  /// قائمة كل مقاطع الفيديو للمورد.
  Future<res.Result<List<VendorVideoItemDto>, Failure>> getVendorVideos();

  /// حذف مقطع لتحرير مكان.
  Future<res.Result<Null, Failure>> deleteVideo(String videoId);

  /// بدء عملية رفع: يرجع uploadId و uploadUrl من الباك اند.
  Future<res.Result<UploadInitResult, Failure>> initUpload({
    required String fileName,
    required String mimeType,
    int? fileSizeBytes,
  });

  /// إكمال الرفع بعد رفع الملف الفعلي.
  Future<res.Result<String, Failure>> completeUpload(String uploadId);

  /// رفع ملف من مسار محلي (اختياري: يدمج init + upload + complete حسب تصميم الباك اند).
  /// [onProgress]: (sent, total) — Phase 19 تقدّم الرفع.
  Future<res.Result<String, Failure>> uploadFile(
    String filePath, {
    String? fileName,
    void Function(int sent, int total)? onProgress,
  });
}

/// نتيجة init upload من الباك اند.
class UploadInitResult {
  const UploadInitResult({
    required this.uploadId,
    this.uploadUrl,
  });

  final String uploadId;
  final String? uploadUrl;
}
