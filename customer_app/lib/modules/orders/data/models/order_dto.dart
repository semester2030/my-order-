import 'package:json_annotation/json_annotation.dart';
import 'order_item_dto.dart';

part 'order_dto.g.dart';

@JsonSerializable()
class OrderVendorDto {
  @JsonKey(fromJson: _stringFromJson)
  final String id;
  @JsonKey(fromJson: _stringFromJson)
  final String name;
  final String? logo;
  final String? phoneNumber;

  OrderVendorDto({
    required this.id,
    required this.name,
    this.logo,
    this.phoneNumber,
  });

  factory OrderVendorDto.fromJson(Map<String, dynamic> json) =>
      _$OrderVendorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderVendorDtoToJson(this);

  static String _stringFromJson(dynamic value) {
    if (value is String) return value;
    if (value == null) return '';
    return value.toString();
  }
}

@JsonSerializable()
class OrderAddressDto {
  @JsonKey(fromJson: _stringFromJson)
  final String id;
  @JsonKey(fromJson: _stringFromJson)
  final String label;
  @JsonKey(fromJson: _stringFromJson)
  final String streetAddress;
  final String? building;
  final String? floor;
  final String? apartment;
  @JsonKey(fromJson: _stringFromJson)
  final String city;
  final String? district;

  OrderAddressDto({
    required this.id,
    required this.label,
    required this.streetAddress,
    this.building,
    this.floor,
    this.apartment,
    required this.city,
    this.district,
  });

  factory OrderAddressDto.fromJson(Map<String, dynamic> json) =>
      _$OrderAddressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderAddressDtoToJson(this);

  static String _stringFromJson(dynamic value) {
    if (value is String) return value;
    if (value == null) return '';
    return value.toString();
  }
}

@JsonSerializable()
class OrderDto {
  @JsonKey(fromJson: _stringFromJson)
  final String id;
  @JsonKey(fromJson: _stringFromJson)
  final String orderNumber;
  @JsonKey(fromJson: _stringFromJson)
  final String status;
  @JsonKey(fromJson: _vendorFromJson)
  final OrderVendorDto vendor;
  @JsonKey(fromJson: _addressFromJson)
  final OrderAddressDto address;
  @JsonKey(fromJson: _itemsFromJson)
  final List<OrderItemDto> items;
  @JsonKey(fromJson: _doubleFromJson)
  final double subtotal;
  @JsonKey(fromJson: _doubleFromJson)
  final double deliveryFee;
  @JsonKey(fromJson: _doubleFromJson)
  final double total;
  final String? estimatedDeliveryTime;
  final String? deliveredAt;
  final String? driverId;
  final String? driverPhone;
  final String? driverName;
  @JsonKey(fromJson: _doubleFromJsonNullable)
  final double? driverLatitude;
  @JsonKey(fromJson: _doubleFromJsonNullable)
  final double? driverLongitude;
  @JsonKey(fromJson: _stringFromJson)
  final String createdAt;
  @JsonKey(fromJson: _stringFromJson)
  final String updatedAt;

  OrderDto({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.vendor,
    required this.address,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    this.estimatedDeliveryTime,
    this.deliveredAt,
    this.driverId,
    this.driverPhone,
    this.driverName,
    this.driverLatitude,
    this.driverLongitude,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);

  static double _doubleFromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }

  static double? _doubleFromJsonNullable(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    return null;
  }

  static OrderVendorDto _vendorFromJson(dynamic value) {
    if (value == null) {
      return OrderVendorDto(
        id: '',
        name: 'Unknown Vendor',
        logo: null,
        phoneNumber: null,
      );
    }
    if (value is Map<String, dynamic>) {
      return OrderVendorDto.fromJson(value);
    }
    return OrderVendorDto(
      id: '',
      name: 'Unknown Vendor',
      logo: null,
      phoneNumber: null,
    );
  }

  static OrderAddressDto _addressFromJson(dynamic value) {
    if (value == null) {
      return OrderAddressDto(
        id: '',
        label: 'Unknown Address',
        streetAddress: '',
        building: null,
        floor: null,
        apartment: null,
        city: 'Riyadh',
        district: null,
      );
    }
    if (value is Map<String, dynamic>) {
      return OrderAddressDto.fromJson(value);
    }
    return OrderAddressDto(
      id: '',
      label: 'Unknown Address',
      streetAddress: '',
      building: null,
      floor: null,
      apartment: null,
      city: 'Riyadh',
      district: null,
    );
  }

  static List<OrderItemDto> _itemsFromJson(dynamic value) {
    if (value == null) {
      return [];
    }
    if (value is List) {
      return value
          .map((e) {
            if (e is Map<String, dynamic>) {
              return OrderItemDto.fromJson(e);
            }
            return null;
          })
          .whereType<OrderItemDto>()
          .toList();
    }
    return [];
  }

  static String _stringFromJson(dynamic value) {
    if (value is String) return value;
    if (value == null) return '';
    return value.toString();
  }
}
