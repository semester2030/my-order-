import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';

import '../models/dashboard_stats_dto.dart';
import 'dashboard_remote_ds.dart';

/// تنفيذ Dashboard عبر GET /vendors/analytics — Phase 18.
class DashboardRemoteDsImpl implements DashboardRemoteDs {
  DashboardRemoteDsImpl(this._dio);

  final Dio _dio;

  @override
  Future<DashboardStatsDto> getStats() async {
    final response = await _dio.get<Map<String, dynamic>>(Endpoints.vendorsAnalytics);
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return DashboardStatsDto.fromJson(data);
  }
}
