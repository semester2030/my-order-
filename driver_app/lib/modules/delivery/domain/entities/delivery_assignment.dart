import 'delivery_contact.dart';

/// Delivery Assignment Entity
/// 
/// Domain entity representing a delivery assignment
class DeliveryAssignment {
  final String orderId;
  final String orderNumber;
  final String status; // Using String instead of DeliveryStatus class
  final double total;
  final double deliveryFee;
  final DeliveryContact vendor;
  final DeliveryContact customer;
  final DeliveryAddress deliveryAddress;
  final DateTime? estimatedDeliveryTime;
  final DateTime createdAt;

  DeliveryAssignment({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.total,
    required this.deliveryFee,
    required this.vendor,
    required this.customer,
    required this.deliveryAddress,
    this.estimatedDeliveryTime,
    required this.createdAt,
  });
}

/// Delivery Address Entity
class DeliveryAddress {
  final String streetAddress;
  final String city;
  final String district;
  final double latitude;
  final double longitude;

  DeliveryAddress({
    required this.streetAddress,
    required this.city,
    required this.district,
    required this.latitude,
    required this.longitude,
  });
}
