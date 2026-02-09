// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderVendorDto _$OrderVendorDtoFromJson(Map<String, dynamic> json) =>
    OrderVendorDto(
      id: OrderVendorDto._stringFromJson(json['id']),
      name: OrderVendorDto._stringFromJson(json['name']),
      logo: json['logo'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$OrderVendorDtoToJson(OrderVendorDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
      'phoneNumber': instance.phoneNumber,
    };

OrderAddressDto _$OrderAddressDtoFromJson(Map<String, dynamic> json) =>
    OrderAddressDto(
      id: OrderAddressDto._stringFromJson(json['id']),
      label: OrderAddressDto._stringFromJson(json['label']),
      streetAddress: OrderAddressDto._stringFromJson(json['streetAddress']),
      building: json['building'] as String?,
      floor: json['floor'] as String?,
      apartment: json['apartment'] as String?,
      city: OrderAddressDto._stringFromJson(json['city']),
      district: json['district'] as String?,
    );

Map<String, dynamic> _$OrderAddressDtoToJson(OrderAddressDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'streetAddress': instance.streetAddress,
      'building': instance.building,
      'floor': instance.floor,
      'apartment': instance.apartment,
      'city': instance.city,
      'district': instance.district,
    };

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) => OrderDto(
      id: OrderDto._stringFromJson(json['id']),
      orderNumber: OrderDto._stringFromJson(json['orderNumber']),
      status: OrderDto._stringFromJson(json['status']),
      vendor: OrderDto._vendorFromJson(json['vendor']),
      address: OrderDto._addressFromJson(json['address']),
      items: OrderDto._itemsFromJson(json['items']),
      subtotal: OrderDto._doubleFromJson(json['subtotal']),
      deliveryFee: OrderDto._doubleFromJson(json['deliveryFee']),
      total: OrderDto._doubleFromJson(json['total']),
      estimatedDeliveryTime: json['estimatedDeliveryTime'] as String?,
      deliveredAt: json['deliveredAt'] as String?,
      driverId: json['driverId'] as String?,
      driverPhone: json['driverPhone'] as String?,
      driverName: json['driverName'] as String?,
      driverLatitude: OrderDto._doubleFromJsonNullable(json['driverLatitude']),
      driverLongitude:
          OrderDto._doubleFromJsonNullable(json['driverLongitude']),
      createdAt: OrderDto._stringFromJson(json['createdAt']),
      updatedAt: OrderDto._stringFromJson(json['updatedAt']),
    );

Map<String, dynamic> _$OrderDtoToJson(OrderDto instance) => <String, dynamic>{
      'id': instance.id,
      'orderNumber': instance.orderNumber,
      'status': instance.status,
      'vendor': instance.vendor,
      'address': instance.address,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'deliveryFee': instance.deliveryFee,
      'total': instance.total,
      'estimatedDeliveryTime': instance.estimatedDeliveryTime,
      'deliveredAt': instance.deliveredAt,
      'driverId': instance.driverId,
      'driverPhone': instance.driverPhone,
      'driverName': instance.driverName,
      'driverLatitude': instance.driverLatitude,
      'driverLongitude': instance.driverLongitude,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
