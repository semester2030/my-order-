import '../models/dashboard_stats_dto.dart';

/// Remote datasource for dashboard stats (Phase 5: stub؛ Phase 7/18: real API).
abstract interface class DashboardRemoteDs {
  Future<DashboardStatsDto> getStats();
}
