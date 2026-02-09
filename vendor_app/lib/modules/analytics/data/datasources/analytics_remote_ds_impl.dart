import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';

import '../models/analytics_dto.dart';
import 'analytics_remote_ds.dart';

/// تنفيذ التحليلات عبر GET /vendors/analytics — Phase 18.
class AnalyticsRemoteDsImpl implements AnalyticsRemoteDs {
  AnalyticsRemoteDsImpl(this._dio);

  final Dio _dio;

  @override
  Future<AnalyticsDto> getAnalytics({String? from, String? to}) async {
    final query = <String, dynamic>{
      if (from != null && from.isNotEmpty) 'from': from,
      if (to != null && to.isNotEmpty) 'to': to,
    };
    final response = await _dio.get<Map<String, dynamic>>(
      Endpoints.vendorsAnalytics,
      queryParameters: query.isNotEmpty ? query : null,
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return AnalyticsDto.fromJson(data);
  }
}
