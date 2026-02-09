import 'package:equatable/equatable.dart';

import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/order.dart';

/// حالة قائمة الطلبات — Phase 9.
sealed class OrdersState with EquatableMixin {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

final class OrdersInitial extends OrdersState {
  const OrdersInitial();
}

final class OrdersLoading extends OrdersState {
  const OrdersLoading();
}

final class OrdersLoaded extends OrdersState {
  const OrdersLoaded(this.result);
  final PagedResult<Order> result;

  @override
  List<Object?> get props => [result];
}

final class OrdersError extends OrdersState {
  const OrdersError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
