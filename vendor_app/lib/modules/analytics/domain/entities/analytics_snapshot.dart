import 'package:equatable/equatable.dart';

/// لقطة التحليلات — Phase 14 (متوافق مع API_CONTRACT).
class AnalyticsSnapshot with EquatableMixin {
  const AnalyticsSnapshot({
    this.pendingOrders = 0,
    this.completedOrders = 0,
    this.totalRevenue = 0.0,
    this.menuItemsCount = 0,
  });

  final int pendingOrders;
  final int completedOrders;
  final double totalRevenue;
  final int menuItemsCount;

  @override
  List<Object?> get props => [pendingOrders, completedOrders, totalRevenue, menuItemsCount];
}
