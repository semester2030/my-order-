import 'package:equatable/equatable.dart';

import '../../domain/entities/dashboard_stats.dart';

/// Dashboard UI state (Phase 5: أساس).
sealed class DashboardState with EquatableMixin {
  const DashboardState();

  @override
  List<Object?> get props => [];
}

final class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

final class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

final class DashboardLoaded extends DashboardState {
  const DashboardLoaded(this.stats);
  final DashboardStats stats;

  @override
  List<Object?> get props => [stats];
}

final class DashboardError extends DashboardState {
  const DashboardError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
