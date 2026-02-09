import '../../../../shared/utils/json_parse.dart';
import 'job_offer_dto.dart';

/// Active Job DTO
class ActiveJobDto {
  final String id;
  final String orderId;
  final String orderNumber;
  final String orderStatus;
  final double deliveryFee;
  final double driverEarnings;
  final double estimatedDistance; // km
  final int estimatedDuration; // minutes
  final Location pickupLocation;
  final Location deliveryLocation;
  final OrderDetails order;
  final DateTime acceptedAt;

  ActiveJobDto({
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
    required this.order,
    required this.acceptedAt,
  });

  factory ActiveJobDto.fromJson(Map<String, dynamic> json) {
    // Handle null safety for nested objects
    final pickupLocationData = json['pickupLocation'];
    final deliveryLocationData = json['deliveryLocation'];
    final orderData = json['order'];
    
    if (pickupLocationData is! Map<String, dynamic> ||
        deliveryLocationData is! Map<String, dynamic> ||
        orderData is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON structure for ActiveJobDto');
    }
    
    return ActiveJobDto(
      id: safeString(json['id']),
      orderId: safeString(json['orderId']),
      orderNumber: safeString(json['orderNumber']),
      orderStatus: safeString(json['orderStatus']),
      deliveryFee: safeDouble(json['deliveryFee']),
      driverEarnings: safeDouble(json['driverEarnings']),
      estimatedDistance: safeDouble(json['estimatedDistance']),
      estimatedDuration: safeInt(json['estimatedDuration']),
      pickupLocation: Location.fromJson(pickupLocationData),
      deliveryLocation: Location.fromJson(deliveryLocationData),
      order: OrderDetails.fromJson(orderData),
      acceptedAt: _parseDateTime(json['acceptedAt']),
    );
  }

  static DateTime _parseDateTime(dynamic v) {
    if (v == null) return DateTime.now();
    try {
      final s = safeString(v);
      if (s.isEmpty) return DateTime.now();
      return DateTime.parse(s);
    } catch (_) {
      return DateTime.now();
    }
  }
}

/// Order Details
class OrderDetails {
  final String id;
  final String orderNumber;
  final String status;
  final double total;
  final VendorDetails vendor;
  final AddressDetails address;
  final List<OrderItem> items;

  OrderDetails({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.total,
    required this.vendor,
    required this.address,
    required this.items,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) {
    // Handle null safety for nested objects
    final vendorData = json['vendor'];
    final addressData = json['address'];
    final itemsData = json['items'];
    
    if (vendorData is! Map<String, dynamic> || addressData is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON structure for OrderDetails');
    }
    
    return OrderDetails(
      id: safeString(json['id']),
      orderNumber: safeString(json['orderNumber']),
      status: safeString(json['status']),
      total: safeDouble(json['total']),
      vendor: VendorDetails.fromJson(vendorData),
      address: AddressDetails.fromJson(addressData),
      items: itemsData is List
          ? (itemsData as List<dynamic>)
              .map((item) => item is Map<String, dynamic>
                  ? OrderItem.fromJson(item)
                  : throw FormatException('Invalid item format'))
              .toList()
          : [],
    );
  }
}

/// Vendor Details
class VendorDetails {
  final String id;
  final String name;
  final String address;

  VendorDetails({
    required this.id,
    required this.name,
    required this.address,
  });

  factory VendorDetails.fromJson(Map<String, dynamic> json) {
    return VendorDetails(
      id: safeString(json['id']),
      name: safeString(json['name']),
      address: safeString(json['address']),
    );
  }
}

/// Address Details
class AddressDetails {
  final String streetAddress;
  final String city;
  final String district;

  AddressDetails({
    required this.streetAddress,
    required this.city,
    required this.district,
  });

  factory AddressDetails.fromJson(Map<String, dynamic> json) {
    return AddressDetails(
      streetAddress: safeString(json['streetAddress']),
      city: safeString(json['city']),
      district: safeString(json['district']),
    );
  }
}

/// Order Item
class OrderItem {
  final String id;
  final String name;
  final int quantity;
  final double price;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: safeString(json['id']),
      name: safeString(json['name']),
      quantity: safeInt(json['quantity']),
      price: safeDouble(json['price']),
    );
  }
}

