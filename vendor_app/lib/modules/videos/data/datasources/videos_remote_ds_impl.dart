import 'dart:io';

import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';

import 'videos_remote_ds.dart';

/// تنفيذ رفع الفيديو/الملفات عبر API الباك اند — Phase 18.
class VideosRemoteDsImpl implements VideosRemoteDs {
  VideosRemoteDsImpl(this._dio);

  final Dio _dio;

  @override
  Future<UploadInitDto> initUpload({
    required String fileName,
    required String mimeType,
    int? fileSizeBytes,
  }) async {
    final body = <String, dynamic>{
      'fileName': fileName,
      'mimeType': mimeType,
      if (fileSizeBytes != null) 'fileSizeBytes': fileSizeBytes,
    };
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.videosUploadInit,
      data: body,
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return UploadInitDto(
      uploadId: data['uploadId'] as String? ?? '',
      uploadUrl: data['uploadUrl'] as String?,
      cloudflareAssetId: data['cloudflareAssetId'] as String?,
    );
  }

  @override
  Future<UploadInitDto> initUploadForMenuItem({
    required String menuItemId,
    required String fileName,
    required int fileSizeBytes,
  }) async {
    final body = <String, dynamic>{
      'menuItemId': menuItemId,
      'fileName': fileName,
      'fileSize': fileSizeBytes,
    };
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.videosUploadInit,
      data: body,
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return UploadInitDto(
      uploadId: data['uploadId'] as String? ?? '',
      uploadUrl: data['uploadUrl'] as String?,
      cloudflareAssetId: data['cloudflareAssetId'] as String?,
    );
  }

  @override
  Future<void> completeUploadForMenuItem({
    required String uploadId,
    required String menuItemId,
    required String cloudflareAssetId,
  }) async {
    await _dio.post<void>(
      Endpoints.videosUploadComplete,
      data: {
        'uploadId': uploadId,
        'menuItemId': menuItemId,
        'cloudflareAssetId': cloudflareAssetId,
      },
    );
  }

  @override
  Future<String> completeUpload(String uploadId) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.videosUploadComplete,
      data: {'uploadId': uploadId},
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    final url = data['url'] as String? ?? data['fileUrl'] as String?;
    if (url != null && url.isNotEmpty) {
      return url;
    }
    return 'https://example.com/uploads/$uploadId';
  }

  @override
  Future<String> uploadToUrl(
    String uploadUrl,
    String filePath, {
    void Function(int sent, int total)? onProgress,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw NetworkException('الملف غير موجود');
    }
    final bytes = await file.readAsBytes();
    await _dio.put<String>(
      uploadUrl,
      data: bytes,
      options: Options(
        contentType: 'application/octet-stream',
        headers: <String, dynamic>{'Content-Length': bytes.length},
      ),
      onSendProgress: onProgress,
    );
    return uploadUrl;
  }

  @override
  Future<void> uploadFileToCloudflareUrl(
    String uploadUrl,
    String filePath, {
    void Function(int sent, int total)? onProgress,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw NetworkException('الملف غير موجود');
    }
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        filePath,
        filename: filePath.split(RegExp(r'[/\\]')).last,
      ),
    });
    await _dio.post<void>(
      uploadUrl,
      data: formData,
      options: Options(
        contentType: 'multipart/form-data',
        sendTimeout: const Duration(minutes: 10),
      ),
      onSendProgress: onProgress,
    );
  }

  @override
  Future<int> getVendorVideoCount() async {
    final response = await _dio.get<Map<String, dynamic>>(Endpoints.videosVendorCount);
    final data = response.data;
    if (data == null) return 0;
    final count = data['count'];
    if (count is int) return count;
    if (count is num) return count.toInt();
    return 0;
  }

  @override
  Future<List<VendorVideoItemDto>> getVendorVideos() async {
    final response = await _dio.get<dynamic>(Endpoints.videosVendorList);
    final list = response.data;
    if (list is! List) return [];
    return list.map((e) {
      final map = e is Map<String, dynamic> ? e : <String, dynamic>{};
      return VendorVideoItemDto(
        id: map['id'] as String? ?? '',
        menuItemId: map['menuItemId'] as String? ?? map['menu_item_id'] as String? ?? '',
        playbackUrl: map['playbackUrl'] as String? ?? map['playback_url'] as String?,
        thumbnailUrl: map['thumbnailUrl'] as String? ?? map['thumbnail_url'] as String?,
        menuItemName: map['menuItemName'] as String? ?? map['menu_item_name'] as String?,
        duration: (map['duration'] as num?)?.toInt(),
      );
    }).where((e) => e.id.isNotEmpty).toList();
  }

  @override
  Future<void> deleteVideo(String videoId) async {
    await _dio.delete<void>(Endpoints.videosDelete(videoId));
  }

  @override
  Future<void> uploadVideoForMenuItem(String menuItemId, String filePath, {void Function(int sent, int total)? onProgress}) async {
    final file = File(filePath);
    if (!await file.exists()) {
      throw NetworkException('الملف غير موجود');
    }
    final fileSize = await file.length();
    final fileName = filePath.split(RegExp(r'[/\\]')).last;

    // 1) init — طلب صغير من Render (لا يعاني timeout)
    final init = await initUploadForMenuItem(
      menuItemId: menuItemId,
      fileName: fileName,
      fileSizeBytes: fileSize,
    );

    final uploadUrl = init.uploadUrl;
    final cloudflareAssetId = init.cloudflareAssetId ?? init.uploadId;
    if (uploadUrl == null || uploadUrl.isEmpty) {
      throw NetworkException('لم يُرجع الخادم رابط رفع');
    }

    // 2) رفع مباشر إلى Cloudflare (POST multipart — لا يمر عبر Render)
    await uploadFileToCloudflareUrl(uploadUrl, filePath, onProgress: onProgress);

    // 3) complete — طلب صغير من Render (يحفظ السجل في video_assets)
    await completeUploadForMenuItem(
      uploadId: init.uploadId,
      menuItemId: menuItemId,
      cloudflareAssetId: cloudflareAssetId,
    );
  }
}
