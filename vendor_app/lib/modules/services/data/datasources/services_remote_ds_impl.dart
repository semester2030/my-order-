import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';
import 'package:vendor_app/shared/models/api_meta.dart';
import 'package:vendor_app/shared/models/paged_result.dart';

import '../models/service_item_dto.dart';
import 'services_remote_ds.dart';

/// تنفيذ الخدمات عبر API الباك اند — Phase 18.
/// إن لم يكن للباك اند endpoint للخدمات، نستخدم قائمة الوجبات (نفس الباك اند غالباً).
class ServicesRemoteDsImpl implements ServicesRemoteDs {
  ServicesRemoteDsImpl(this._dio);

  final Dio _dio;

  @override
  Future<PagedResult<ServiceItemDto>> getServices({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get<dynamic>(
        Endpoints.vendorsServices,
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
      final items = <ServiceItemDto>[];
      for (final e in list) {
        if (e is Map<String, dynamic>) {
          items.add(ServiceItemDto.fromJson(e));
        }
      }
      final meta = metaMap != null
          ? ApiMeta.fromJson(metaMap)
          : ApiMeta(page: page, limit: limit, total: items.length, totalPages: 1);
      return PagedResult<ServiceItemDto>(data: items, meta: meta);
    }     on DioException catch (e) {
      final code = e.response?.statusCode;
      if (code == 404 || code == 501 || code == 500) {
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
    final response = await _dio.get<Map<String, dynamic>>(
      Endpoints.vendorServiceById(id),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return ServiceItemDto.fromJson(data);
  }

  @override
  Future<ServiceItemDto> addItem(ServiceItemDto dto) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorsServices,
      data: dto.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return ServiceItemDto.fromJson(data);
  }

  @override
  Future<ServiceItemDto> updateItem(ServiceItemDto dto) async {
    final response = await _dio.put<Map<String, dynamic>>(
      Endpoints.vendorServiceById(dto.id),
      data: dto.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return ServiceItemDto.fromJson(data);
  }
}
