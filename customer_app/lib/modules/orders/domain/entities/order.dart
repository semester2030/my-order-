import 'package:equatable/equatable.dart';
import 'order_item.dart';
import 'order_tracking.dart';
import '../../../feed/domain/entities/feed_item.dart';
import '../../../addresses/domain/entities/address.dart';

class Order extends Equatable {
  final String id;
  final String orderNumber;
  final OrderTracking tracking;
  final Vendor vendor;
  final Address address;
  final List<OrderItem> items;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.tracking,
    required this.vendor,
    required this.address,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        orderNumber,
        tracking,
        vendor,
        address,
        items,
        subtotal,
        deliveryFee,
        total,
        createdAt,
        updatedAt,
      ];
}
