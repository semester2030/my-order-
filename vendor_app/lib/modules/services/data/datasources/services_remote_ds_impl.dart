import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';
import 'package:vendor_app/shared/models/api_meta.dart';
import 'package:vendor_app/shared/models/paged_result.dart';

import '../models/service_item_dto.dart';
import 'services_remote_ds.dart';

/// تنفيذ «الخدمات» عبر **مسار القائمة** في الباكند (`/vendors/menu`) مع `multipart/form-data` للصور.
class ServicesRemoteDsImpl implements ServicesRemoteDs {
  ServicesRemoteDsImpl(this._dio);

  final Dio _dio;

  @override
  Future<PagedResult<ServiceItemDto>> getServices({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get<dynamic>(Endpoints.vendorsMenu);
      final data = response.data;
      if (data == null) {
        throw NetworkException('استجابة فارغة من الخادم');
      }
      final List<dynamic> raw = data is List
          ? data
          : (data is Map<String, dynamic> && data['data'] is List)
              ? data['data'] as List<dynamic>
              : <dynamic>[];
      final items = <ServiceItemDto>[];
      for (final e in raw) {
        if (e is Map<String, dynamic>) {
          items.add(ServiceItemDto.fromJson(e));
        }
      }
      final start = (page - 1) * limit;
      final slice = start >= items.length
          ? <ServiceItemDto>[]
          : items.sublist(
              start,
              start + limit > items.length ? items.length : start + limit,
            );
      final total = items.length;
      final totalPages = limit <= 0
          ? 1
          : total == 0
              ? 0
              : ((total + limit - 1) ~/ limit);
      return PagedResult<ServiceItemDto>(
        data: slice,
        meta: ApiMeta(
          page: page,
          limit: limit,
          total: total,
          totalPages: totalPages,
        ),
      );
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 404 || code == 501) {
        return PagedResult<ServiceItemDto>(
          data: [],
          meta: ApiMeta(page: page, limit: limit, total: 0, totalPages: 0),
        );
      }
      rethrow;
    }
  }

  @override
  Future<ServiceItemDto> getItemById(String id) async {
    final paged = await getServices(page: 1, limit: 500);
    for (final item in paged.data) {
      if (item.id == id) return item;
    }
    throw NetworkException('العنصر غير موجود');
  }

  @override
  Future<ServiceItemDto> addItem(ServiceItemDto dto) async {
    final formData = FormData.fromMap(<String, dynamic>{
      'name': dto.name,
      if (dto.description != null && dto.description!.trim().isNotEmpty)
        'description': dto.description,
      'price': (dto.price ?? 0).toString(),
      'isSignature': 'false',
      'isAvailable': dto.isActive ? 'true' : 'false',
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
    }

    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorsMenu,
      data: formData,
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return ServiceItemDto.fromJson(data);
  }

  @override
  Future<ServiceItemDto> updateItem(ServiceItemDto dto) async {
    final formData = FormData.fromMap(<String, dynamic>{
      'name': dto.name,
      if (dto.description != null) 'description': dto.description,
      if (dto.price != null) 'price': dto.price!.toString(),
      'isSignature': 'false',
      'isAvailable': dto.isActive ? 'true' : 'false',
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
    }

    final response = await _dio.put<Map<String, dynamic>>(
      Endpoints.vendorServiceById(dto.id),
      data: formData,
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return ServiceItemDto.fromJson(data);
  }
}
