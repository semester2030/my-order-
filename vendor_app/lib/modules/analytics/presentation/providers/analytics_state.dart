import 'package:equatable/equatable.dart';

import '../../domain/entities/analytics_snapshot.dart';

/// حالة التحليلات — Phase 14.
sealed class AnalyticsState with EquatableMixin {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

final class AnalyticsInitial extends AnalyticsState {
  const AnalyticsInitial();
}

final class AnalyticsLoading extends AnalyticsState {
  const AnalyticsLoading();
}

final class AnalyticsLoaded extends AnalyticsState {
  const AnalyticsLoaded(this.snapshot);
  final AnalyticsSnapshot snapshot;

  @override
  List<Object?> get props => [snapshot];
}

final class AnalyticsError extends AnalyticsState {
  const AnalyticsError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
