import '../../../../shared/utils/json_parse.dart';

/// Delivery Details DTO
class DeliveryDetailsDto {
  final String orderId;
  final String orderNumber;
  final String status;
  final double total;
  final double deliveryFee;
  final VendorDetails vendor;
  final CustomerDetails customer;
  final DeliveryAddress deliveryAddress;
  final List<OrderItem> items;
  final DateTime? estimatedDeliveryTime;
  final DateTime createdAt;

  DeliveryDetailsDto({
    required this.orderId,
    required this.orderNumber,
    required this.status,
    required this.total,
    required this.deliveryFee,
    required this.vendor,
    required this.customer,
    required this.deliveryAddress,
    required this.items,
    this.estimatedDeliveryTime,
    required this.createdAt,
  });

  factory DeliveryDetailsDto.fromJson(Map<String, dynamic> json) {
    // Handle null safety for nested objects
    final vendorData = json['vendor'];
    final customerData = json['customer'];
    final addressData = json['deliveryAddress'];
    final itemsData = json['items'];
    
    if (vendorData is! Map<String, dynamic> ||
        customerData is! Map<String, dynamic> ||
        addressData is! Map<String, dynamic>) {
      throw FormatException('Invalid JSON structure for DeliveryDetailsDto');
    }
    
    return DeliveryDetailsDto(
      orderId: safeString(json['orderId']),
      orderNumber: safeString(json['orderNumber']),
      status: safeString(json['status']),
      total: safeDouble(json['total']),
      deliveryFee: safeDouble(json['deliveryFee']),
      vendor: VendorDetails.fromJson(vendorData),
      customer: CustomerDetails.fromJson(customerData),
      deliveryAddress: DeliveryAddress.fromJson(addressData),
      items: itemsData is List
          ? (itemsData as List<dynamic>)
              .map((item) => item is Map<String, dynamic>
                  ? OrderItem.fromJson(item)
                  : throw FormatException('Invalid item format'))
              .toList()
          : [],
      estimatedDeliveryTime: _parseDateTimeNullable(json['estimatedDeliveryTime']),
      createdAt: _parseDateTime(json['createdAt']),
    );
  }

  static DateTime? _parseDateTimeNullable(dynamic v) {
    if (v == null) return null;
    try {
      return DateTime.parse(safeString(v));
    } catch (_) {
      return null;
    }
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

/// Vendor Details
class VendorDetails {
  final String id;
  final String name;
  final String address;
  final String? phoneNumber;
  final double latitude;
  final double longitude;

  VendorDetails({
    required this.id,
    required this.name,
    required this.address,
    this.phoneNumber,
    required this.latitude,
    required this.longitude,
  });

  factory VendorDetails.fromJson(Map<String, dynamic> json) {
    return VendorDetails(
      id: safeString(json['id']),
      name: safeString(json['name']),
      address: safeString(json['address']),
      phoneNumber: safeStringNullable(json['phoneNumber']),
      latitude: safeDouble(json['latitude']),
      longitude: safeDouble(json['longitude']),
    );
  }
}

/// Customer Details
class CustomerDetails {
  final String id;
  final String? name;
  final String phone;

  CustomerDetails({
    required this.id,
    this.name,
    required this.phone,
  });

  factory CustomerDetails.fromJson(Map<String, dynamic> json) {
    return CustomerDetails(
      id: safeString(json['id']),
      name: safeStringNullable(json['name']),
      phone: safeString(json['phone']),
    );
  }
}

/// Delivery Address
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

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) {
    return DeliveryAddress(
      streetAddress: safeString(json['streetAddress']),
      city: safeString(json['city']),
      district: safeString(json['district']),
      latitude: safeDouble(json['latitude']),
      longitude: safeDouble(json['longitude']),
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
