import 'package:equatable/equatable.dart';

import '../../domain/entities/side_order_item.dart';

/// حالة الطلبات الجانبية — Phase 12 (من profile popularCookingAddOns).
sealed class SideOrdersState with EquatableMixin {
  const SideOrdersState();

  @override
  List<Object?> get props => [];
}

final class SideOrdersInitial extends SideOrdersState {
  const SideOrdersInitial();
}

final class SideOrdersLoading extends SideOrdersState {
  const SideOrdersLoading();
}

final class SideOrdersLoaded extends SideOrdersState {
  const SideOrdersLoaded(this.items);
  final List<SideOrderItem> items;

  @override
  List<Object?> get props => [items];
}

final class SideOrdersError extends SideOrdersState {
  const SideOrdersError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class SideOrdersSaving extends SideOrdersState {
  const SideOrdersSaving();
}
