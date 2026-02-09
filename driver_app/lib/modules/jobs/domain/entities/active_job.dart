/// Active Job Entity
/// 
/// Domain entity representing an active job assignment
class ActiveJob {
  final String id;
  final String orderId;
  final String orderNumber;
  final String orderStatus;
  final double deliveryFee;
  final double driverEarnings;
  final double estimatedDistance; // km
  final int estimatedDuration; // minutes
  final JobLocation pickupLocation;
  final JobLocation deliveryLocation;
  final DateTime acceptedAt;

  ActiveJob({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.orderStatus,
    required this.deliveryFee,
    required this.driverEarnings,
    required this.estimatedDistance,
    required this.estimatedDuration,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.acceptedAt,
  });
}

/// Job Location Entity
class JobLocation {
  final double latitude;
  final double longitude;
  final String? address;

  JobLocation({
    required this.latitude,
    required this.longitude,
    this.address,
  });
}
