import 'package:equatable/equatable.dart';

/// Domain entity: dashboard stats (Phase 5: أساس).
class DashboardStats with EquatableMixin {
  const DashboardStats({
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
