import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';
import 'package:vendor_app/shared/models/api_meta.dart';
import 'package:vendor_app/shared/models/paged_result.dart';

import '../models/staff_member_dto.dart';
import 'staff_remote_ds.dart';

/// تنفيذ الموظفين عبر API الباك اند — Phase 18.
class StaffRemoteDsImpl implements StaffRemoteDs {
  StaffRemoteDsImpl(this._dio);

  final Dio _dio;

  @override
  Future<PagedResult<StaffMemberDto>> getStaff({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dio.get<dynamic>(
      Endpoints.vendorsStaff,
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
    final items = <StaffMemberDto>[];
    for (final e in list) {
      if (e is Map<String, dynamic>) {
        items.add(StaffMemberDto.fromJson(e));
      }
    }
    final meta = metaMap != null
        ? ApiMeta.fromJson(metaMap)
        : ApiMeta(page: page, limit: limit, total: items.length, totalPages: 1);
    return PagedResult<StaffMemberDto>(data: items, meta: meta);
  }

  @override
  Future<StaffMemberDto> getItemById(String id) async {
    final response = await _dio.get<Map<String, dynamic>>(
      Endpoints.vendorStaffById(id),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return StaffMemberDto.fromJson(data);
  }

  @override
  Future<StaffMemberDto> addItem(StaffMemberDto dto) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorsStaff,
      data: dto.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return StaffMemberDto.fromJson(data);
  }

  @override
  Future<StaffMemberDto> updateItem(StaffMemberDto dto) async {
    final response = await _dio.put<Map<String, dynamic>>(
      Endpoints.vendorStaffById(dto.id),
      data: dto.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return StaffMemberDto.fromJson(data);
  }
}
