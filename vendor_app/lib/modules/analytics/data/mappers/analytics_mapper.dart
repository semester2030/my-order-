import '../../domain/entities/analytics_snapshot.dart';
import '../models/analytics_dto.dart';

/// تحويل DTO التحليلات إلى كيان النطاق — Phase 14.
class AnalyticsMapper {
  AnalyticsMapper._();

  static AnalyticsSnapshot toSnapshot(AnalyticsDto dto) {
    return AnalyticsSnapshot(
      pendingOrders: dto.pendingOrders,
      completedOrders: dto.completedOrders,
      totalRevenue: dto.totalRevenue,
      menuItemsCount: dto.menuItemsCount,
    );
  }
}
