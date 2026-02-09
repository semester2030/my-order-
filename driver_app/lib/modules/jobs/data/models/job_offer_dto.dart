import '../../../../shared/utils/json_parse.dart';

/// Job Offer DTO (for inbox)
class JobOfferDto {
  final String id;
  final String orderId;
  final String orderNumber;
  final double deliveryFee;
  final double driverEarnings;
  final double estimatedDistance; // km
  final int estimatedDuration; // minutes
  final Location pickupLocation;
  final Location deliveryLocation;
  final DateTime expiresAt;
  final DateTime createdAt;

  JobOfferDto({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.deliveryFee,
    required this.driverEarnings,
    required this.estimatedDistance,
    required this.estimatedDuration,
    required this.pickupLocation,
    required this.deliveryLocation,
    required this.expiresAt,
    required this.createdAt,
  });

  factory JobOfferDto.fromJson(Map<String, dynamic> json) {
    final pickup = json['pickupLocation'];
    final delivery = json['deliveryLocation'];
    return JobOfferDto(
      id: safeString(json['id']),
      orderId: safeString(json['orderId']),
      orderNumber: safeString(json['orderNumber']),
      deliveryFee: safeDouble(json['deliveryFee']),
      driverEarnings: safeDouble(json['driverEarnings']),
      estimatedDistance: safeDouble(json['estimatedDistance']),
      estimatedDuration: safeInt(json['estimatedDuration']),
      pickupLocation: pickup is Map<String, dynamic>
          ? Location.fromJson(pickup)
          : Location(latitude: 0, longitude: 0),
      deliveryLocation: delivery is Map<String, dynamic>
          ? Location.fromJson(delivery)
          : Location(latitude: 0, longitude: 0),
      expiresAt: _parseDateTime(json['expiresAt']),
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  static DateTime _parseDateTime(dynamic v) {
    if (v == null) return DateTime.now();
    try {
      final s = v is String ? v : v.toString();
      if (s.isEmpty) return DateTime.now();
      return DateTime.parse(s);
    } catch (_) {
      return DateTime.now();
    }
  }
}

/// Location model
class Location {
  final double latitude;
  final double longitude;

  Location({
    required this.latitude,
    required this.longitude,
  });

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      latitude: safeDouble(json['latitude']),
      longitude: safeDouble(json['longitude']),
    );
  }

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
