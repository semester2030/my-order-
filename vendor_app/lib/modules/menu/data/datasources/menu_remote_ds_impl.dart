import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';
import 'package:vendor_app/shared/models/api_meta.dart';
import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/menu_offering_terms_status.dart';
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
    if (!m.containsKey('id') && m.containsKey('menu_item_id')) {
      m['id'] = m['menu_item_id'];
    }
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
    if (m.containsKey('profile_promo') && !m.containsKey('profilePromo')) {
      m['profilePromo'] = m['profile_promo'];
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
  Future<MenuItemDto> addItem(MenuItemDto dto, {bool kitchenProfilePromo = false}) async {
    final formData = FormData.fromMap(<String, dynamic>{
      'name': dto.name,
      if (dto.description != null && dto.description!.trim().isNotEmpty)
        'description': dto.description,
      if (dto.price != null) 'price': dto.price.toString(),
      'isSignature': 'false',
      'isAvailable': dto.isAvailable ? 'true' : 'false',
      if (kitchenProfilePromo) 'profilePromo': 'true',
    });

    final path = dto.imageUrl;
    if (path != null &&
        path.isNotEmpty &&
        !path.startsWith('http://') &&
        !path.startsWith('https://')) {
      final name = path.contains('/') ? path.split('/').last : path.split('\\').last;
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(path, filename: name),
        ),
      );
    } else if (path != null && path.trim().isNotEmpty && (path.startsWith('http://') || path.startsWith('https://'))) {
      formData.fields.add(MapEntry('imageUrl', path.trim()));
    }

    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorsMenu,
      data: formData,
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return MenuItemDto.fromJson(_normalizeMenuItemJson(data));
  }

  @override
  Future<MenuItemDto> updateItem(MenuItemDto dto) async {
    final formData = FormData.fromMap(<String, dynamic>{
      'name': dto.name,
      if (dto.description != null) 'description': dto.description,
      if (dto.price != null) 'price': dto.price.toString(),
      'isSignature': 'false',
      'isAvailable': dto.isAvailable ? 'true' : 'false',
    });

    final path = dto.imageUrl;
    if (path != null &&
        path.isNotEmpty &&
        !path.startsWith('http://') &&
        !path.startsWith('https://')) {
      final name = path.contains('/') ? path.split('/').last : path.split('\\').last;
      formData.files.add(
        MapEntry(
          'image',
          await MultipartFile.fromFile(path, filename: name),
        ),
      );
    } else if (path != null && path.trim().isNotEmpty && (path.startsWith('http://') || path.startsWith('https://'))) {
      formData.fields.add(MapEntry('imageUrl', path.trim()));
    }

    final response = await _dio.put<Map<String, dynamic>>(
      Endpoints.vendorMenuItemById(dto.id),
      data: formData,
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return MenuItemDto.fromJson(_normalizeMenuItemJson(Map<String, dynamic>.from(data)));
  }

  @override
  Future<MenuOfferingTermsStatus> getMenuOfferingTermsStatus() async {
    final response = await _dio.get<Map<String, dynamic>>(
      Endpoints.vendorsMenuOfferingTermsStatus,
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return MenuOfferingTermsStatus.fromJson(data);
  }

  @override
  Future<void> acceptMenuOfferingTerms(String documentVersion) async {
    await _dio.post<void>(
      Endpoints.vendorsMenuOfferingTermsAccept,
      data: <String, dynamic>{'documentVersion': documentVersion},
    );
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
