import 'package:equatable/equatable.dart';
import 'cart_item.dart';
import '../../../feed/domain/entities/feed_item.dart';

class Cart extends Equatable {
  final String id;
  final String? vendorId;
  final Vendor? vendor;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;

  const Cart({
    required this.id,
    this.vendorId,
    this.vendor,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
  });

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  @override
  List<Object?> get props => [id, vendorId, vendor, items, subtotal, deliveryFee, total];
}
