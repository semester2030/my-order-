import 'videos_remote_ds.dart';

/// Stub لرفع الفيديو حتى ربط الـ API — Phase 15.
class VideosRemoteDsStub implements VideosRemoteDs {
  @override
  Future<UploadInitDto> initUpload({
    required String fileName,
    required String mimeType,
    int? fileSizeBytes,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return UploadInitDto(
      uploadId: 'upload-${DateTime.now().millisecondsSinceEpoch}',
      uploadUrl: 'https://example.com/upload',
    );
  }

  @override
  Future<String> completeUpload(String uploadId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return 'https://example.com/media/$uploadId';
  }

  @override
  Future<String> uploadToUrl(
    String uploadUrl,
    String filePath, {
    void Function(int sent, int total)? onProgress,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return '$uploadUrl/completed';
  }

  @override
  Future<int> getVendorVideoCount() async => 0;

  @override
  Future<List<VendorVideoItemDto>> getVendorVideos() async => [];

  @override
  Future<void> deleteVideo(String videoId) async {}
}
