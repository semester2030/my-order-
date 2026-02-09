import 'package:equatable/equatable.dart';

/// عنصر طلب — وجبة أو إضافة (Phase 8).
class OrderItem with EquatableMixin {
  const OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.addOns = const [],
  });

  final String id;
  final String name;
  final int quantity;
  final double unitPrice;
  final List<String> addOns;

  double get subtotal => quantity * unitPrice;

  @override
  List<Object?> get props => [id, name, quantity, unitPrice, addOns];
}
