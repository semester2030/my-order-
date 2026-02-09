/// DTO للتحليلات — Phase 14 (متوافق مع API_CONTRACT).
class AnalyticsDto {
  const AnalyticsDto({
    this.pendingOrders = 0,
    this.completedOrders = 0,
    this.totalRevenue = 0.0,
    this.menuItemsCount = 0,
  });

  final int pendingOrders;
  final int completedOrders;
  final double totalRevenue;
  final int menuItemsCount;

  factory AnalyticsDto.fromJson(Map<String, dynamic> json) {
    return AnalyticsDto(
      pendingOrders: json['pendingOrders'] as int? ?? 0,
      completedOrders: json['completedOrders'] as int? ?? 0,
      totalRevenue: (json['totalRevenue'] as num?)?.toDouble() ?? 0.0,
      menuItemsCount: json['menuItemsCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'pendingOrders': pendingOrders,
      'completedOrders': completedOrders,
      'totalRevenue': totalRevenue,
      'menuItemsCount': menuItemsCount,
    };
  }
}
