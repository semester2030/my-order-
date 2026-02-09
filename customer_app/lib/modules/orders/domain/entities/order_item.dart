import 'package:equatable/equatable.dart';
import '../../../feed/domain/entities/feed_item.dart';

class OrderItem extends Equatable {
  final String id;
  final String menuItemId;
  final MenuItem menuItem;
  final int quantity;
  final double price; // Price at time of order

  const OrderItem({
    required this.id,
    required this.menuItemId,
    required this.menuItem,
    required this.quantity,
    required this.price,
  });

  double get subtotal => price * quantity;

  @override
  List<Object?> get props => [id, menuItemId, menuItem, quantity, price];
}
