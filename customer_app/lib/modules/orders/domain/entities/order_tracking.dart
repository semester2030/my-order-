import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  outForDelivery,
  delivered,
  cancelled,
}

class OrderTracking extends Equatable {
  final OrderStatus status;
  final DateTime? estimatedDeliveryTime;
  final DateTime? deliveredAt;
  final String? driverId;
  final String? driverPhone;
  final String? driverName;
  final double? driverLatitude;
  final double? driverLongitude;

  const OrderTracking({
    required this.status,
    this.estimatedDeliveryTime,
    this.deliveredAt,
    this.driverId,
    this.driverName,
    this.driverPhone,
    this.driverLatitude,
    this.driverLongitude,
  });

  @override
  List<Object?> get props => [
        status,
        estimatedDeliveryTime,
        deliveredAt,
        driverId,
        driverPhone,
        driverName,
        driverLatitude,
        driverLongitude,
      ];
}
