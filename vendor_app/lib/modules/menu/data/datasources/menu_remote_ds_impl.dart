import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';
import 'package:vendor_app/shared/models/api_meta.dart';
import 'package:vendor_app/shared/models/paged_result.dart';

import '../models/menu_item_dto.dart';
import 'menu_remote_ds.dart';

/// تنفيذ القائمة عبر API الباك اند — Phase 18.
class MenuRemoteDsImpl implements MenuRemoteDs {
  MenuRemoteDsImpl(this._dio);

  final Dio _dio;

  @override
  Future<PagedResult<MenuItemDto>> getMenu({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get<dynamic>(
      Endpoints.vendorsMenu,
      queryParameters: {'page': page, 'limit': limit},
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    List<dynamic> list;
    Map<String, dynamic>? metaMap;
    if (data is List) {
      list = data;
      metaMap = null;
    } else if (data is Map<String, dynamic>) {
      list = data['data'] is List ? data['data'] as List<dynamic> : <dynamic>[];
      metaMap = data['meta'] is Map<String, dynamic> ? data['meta'] as Map<String, dynamic> : null;
    } else {
      list = <dynamic>[];
    }
    final items = <MenuItemDto>[];
    for (final e in list) {
      if (e is Map<String, dynamic>) {
        items.add(MenuItemDto.fromJson(_normalizeMenuItemJson(e)));
      }
    }
    final meta = metaMap != null
        ? ApiMeta.fromJson(metaMap)
        : ApiMeta(page: page, limit: limit, total: items.length, totalPages: 1);
    return PagedResult<MenuItemDto>(data: items, meta: meta);
  }

  /// الباك اند قد يرجع image بدل imageUrl، أو video/videoAssets — توحيد المفاتيح.
  static Map<String, dynamic> _normalizeMenuItemJson(Map<String, dynamic> e) {
    final m = Map<String, dynamic>.from(e);
    if (m.containsKey('image') && !m.containsKey('imageUrl')) {
      m['imageUrl'] = m['image'];
    }
    if (m.containsKey('video') && !m.containsKey('videoUrl')) {
      m['videoUrl'] = m['video'];
    }
    // isAvailable: دعم snake_case إن رجع الباك اند is_available
    if (m.containsKey('is_available') && !m.containsKey('isAvailable')) {
      m['isAvailable'] = m['is_available'];
    }
    // الباك اند يرجع videoAssets[] أو video_assets[] مع playbackUrl/playback_url و thumbnailUrl/thumbnail_url
    final videoAssets = m['videoAssets'] ?? m['video_assets'];
    if (videoAssets is List && videoAssets.isNotEmpty) {
      final first = videoAssets.first;
      if (first is Map) {
        final playbackUrl = first['playbackUrl'] ?? first['playback_url'];
        final thumbnailUrl = first['thumbnailUrl'] ?? first['thumbnail_url'];
        if (!m.containsKey('videoUrl') && playbackUrl != null) {
          m['videoUrl'] = playbackUrl is String ? playbackUrl : playbackUrl.toString();
        }
        if (!m.containsKey('videoThumbnailUrl') && thumbnailUrl != null) {
          m['videoThumbnailUrl'] = thumbnailUrl is String ? thumbnailUrl : thumbnailUrl.toString();
        }
      }
    }
    return m;
  }

  @override
  Future<MenuItemDto> getItemById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      Endpoints.vendorMenuItemById(id),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return MenuItemDto.fromJson(_normalizeMenuItemJson(data));
  }

  @override
  Future<MenuItemDto> addItem(MenuItemDto dto) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorsMenu,
      data: dto.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return MenuItemDto.fromJson(_normalizeMenuItemJson(data));
  }

  @override
  Future<MenuItemDto> updateItem(MenuItemDto dto) async {
    final response = await _dio.put<Map<String, dynamic>>(
      Endpoints.vendorMenuItemById(dto.id),
      data: dto.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return MenuItemDto.fromJson(_normalizeMenuItemJson(Map<String, dynamic>.from(data)));
  }

  @override
  Future<MenuItemDto> toggleAvailability(String id, bool isAvailable) async {
    final response = await _dio.patch<Map<String, dynamic>>(
      Endpoints.vendorMenuItemAvailability(id),
      data: {'isAvailable': isAvailable},
    );
    final data = response.data;
    if (data != null && data.isNotEmpty) {
      return MenuItemDto.fromJson(_normalizeMenuItemJson(data));
    }
    return getItemById(id);
  }
}
