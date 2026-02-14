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

  /// رفع ملف إلى Cloudflare (POST multipart/form-data — field اسمه "file").
  Future<void> uploadFileToCloudflareUrl(
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

  /// init مع menuItemId — للرفع المباشر إلى Cloudflare (يتجنب timeout على Render).
  Future<UploadInitDto> initUploadForMenuItem({
    required String menuItemId,
    required String fileName,
    required int fileSizeBytes,
  });

  /// complete مع menuItemId و cloudflareAssetId.
  Future<void> completeUploadForMenuItem({
    required String uploadId,
    required String menuItemId,
    required String cloudflareAssetId,
  });

  /// رفع فيديو لصنف قائمة — يستخدم الرفع المباشر إلى Cloudflare (لا يمر الملف عبر Render).
  Future<void> uploadVideoForMenuItem(String menuItemId, String filePath, {void Function(int sent, int total)? onProgress});
}

/// DTO لنتيجة init من الباك اند.
class UploadInitDto {
  const UploadInitDto({
    required this.uploadId,
    this.uploadUrl,
    this.cloudflareAssetId,
  });

  final String uploadId;
  final String? uploadUrl;
  final String? cloudflareAssetId;
}
