import 'package:equatable/equatable.dart';

import '../../domain/entities/order.dart';

/// حالة تفاصيل الطلب — Phase 9.
sealed class OrderDetailState with EquatableMixin {
  const OrderDetailState();

  @override
  List<Object?> get props => [];
}

final class OrderDetailInitial extends OrderDetailState {
  const OrderDetailInitial();
}

final class OrderDetailLoading extends OrderDetailState {
  const OrderDetailLoading();
}

final class OrderDetailLoaded extends OrderDetailState {
  const OrderDetailLoaded(this.order);
  final Order order;

  @override
  List<Object?> get props => [order];
}

final class OrderDetailError extends OrderDetailState {
  const OrderDetailError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// أثناء تنفيذ إجراء (قبول/رفض/تحديث حالة) — نعرض الطلب السابق.
final class OrderDetailSaving extends OrderDetailState {
  const OrderDetailSaving(this.order);
  final Order order;

  @override
  List<Object?> get props => [order];
}
