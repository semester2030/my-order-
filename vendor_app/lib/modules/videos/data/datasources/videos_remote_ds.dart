/// عنصر فيديو واحد في قائمة مقاطع الطباخ (حد أقصى 20).
class VendorVideoItemDto {
  const VendorVideoItemDto({
    required this.id,
    required this.menuItemId,
    this.playbackUrl,
    this.thumbnailUrl,
    this.menuItemName,
    this.duration,
  });

  final String id;
  final String menuItemId;
  final String? playbackUrl;
  final String? thumbnailUrl;
  final String? menuItemName;
  final int? duration;
}

/// مصدر بيانات رفع الفيديو عن بعد — Phase 15 + قائمة/حذف (حد 20 مقطع).
abstract interface class VideosRemoteDs {
  Future<UploadInitDto> initUpload({
    required String fileName,
    required String mimeType,
    int? fileSizeBytes,
  });

  Future<String> completeUpload(String uploadId);

  /// [onProgress]: (sent, total) — Phase 19 تقدّم الرفع.
  Future<String> uploadToUrl(
    String uploadUrl,
    String filePath, {
    void Function(int sent, int total)? onProgress,
  });

  /// عدد مقاطع الفيديو الحالية للمورد (الحد الأقصى 20).
  Future<int> getVendorVideoCount();

  /// قائمة كل مقاطع الفيديو للمورد.
  Future<List<VendorVideoItemDto>> getVendorVideos();

  /// حذف مقطع لتحرير مكان لإضافة جديد.
  Future<void> deleteVideo(String videoId);
}

/// DTO لنتيجة init من الباك اند.
class UploadInitDto {
  const UploadInitDto({
    required this.uploadId,
    this.uploadUrl,
  });

  final String uploadId;
  final String? uploadUrl;
}
