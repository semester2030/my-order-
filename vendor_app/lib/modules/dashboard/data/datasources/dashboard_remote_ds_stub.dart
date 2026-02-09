import '../models/dashboard_stats_dto.dart';
import 'dashboard_remote_ds.dart';

/// Stub: يرجع إحصائيات وهمية حتى ربط الـ API.
class DashboardRemoteDsStub implements DashboardRemoteDs {
  @override
  Future<DashboardStatsDto> getStats() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const DashboardStatsDto(
      pendingOrders: 3,
      completedOrders: 42,
      totalRevenue: 12500.0,
      menuItemsCount: 12,
    );
  }
}
