/// Response DTO for GET /vendors/analytics or dashboard (Phase 5: أساس).
class DashboardStatsDto {
  const DashboardStatsDto({
    this.pendingOrders = 0,
    this.completedOrders = 0,
    this.totalRevenue = 0.0,
    this.menuItemsCount = 0,
  });

  final int pendingOrders;
  final int completedOrders;
  final double totalRevenue;
  final int menuItemsCount;

  factory DashboardStatsDto.fromJson(Map<String, dynamic> json) {
    return DashboardStatsDto(
      pendingOrders: json['pendingOrders'] as int? ?? 0,
      completedOrders: json['completedOrders'] as int? ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      menuItemsCount: json['menuItemsCount'] as int? ?? 0,
    );
  }
}
