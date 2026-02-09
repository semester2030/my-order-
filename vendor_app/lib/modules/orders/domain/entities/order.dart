import 'package:equatable/equatable.dart';

import '../../../../shared/enums/order_status.dart';
import 'order_item.dart';

/// طلب — Phase 8.
class Order with EquatableMixin {
  const Order({
    required this.id,
    required this.customerName,
    this.customerPhone,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    this.items = const [],
    this.notes,
  });

  final String id;
  final String customerName;
  final String? customerPhone;
  final OrderStatus status;
  final double totalAmount;
  final DateTime createdAt;
  final List<OrderItem> items;
  final String? notes;

  @override
  List<Object?> get props => [id, customerName, customerPhone, status, totalAmount, createdAt, items, notes];
}
