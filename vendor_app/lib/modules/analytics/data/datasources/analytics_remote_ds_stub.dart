import '../models/analytics_dto.dart';
import 'analytics_remote_ds.dart';

/// Stub للتحليلات حتى ربط الـ API — Phase 14.
class AnalyticsRemoteDsStub implements AnalyticsRemoteDs {
  @override
  Future<AnalyticsDto> getAnalytics({String? from, String? to}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const AnalyticsDto(
      pendingOrders: 5,
      completedOrders: 120,
      totalRevenue: 15000.0,
      menuItemsCount: 25,
    );
  }
}
