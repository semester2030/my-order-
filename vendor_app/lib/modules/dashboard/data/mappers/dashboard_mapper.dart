import '../../domain/entities/dashboard_stats.dart';
import '../models/dashboard_stats_dto.dart';

/// Maps dashboard DTO to domain entity.
class DashboardMapper {
  DashboardMapper._();

  static DashboardStats toEntity(DashboardStatsDto dto) {
    return DashboardStats(
      pendingOrders: dto.pendingOrders,
      completedOrders: dto.completedOrders,
      totalRevenue: dto.totalRevenue,
      menuItemsCount: dto.menuItemsCount,
    );
  }
}
