// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorDto _$VendorDtoFromJson(Map<String, dynamic> json) => VendorDto(
      id: json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String?,
    );

Map<String, dynamic> _$VendorDtoToJson(VendorDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
    };

CartDto _$CartDtoFromJson(Map<String, dynamic> json) => CartDto(
      id: json['id'] as String,
      vendor: json['vendor'] == null
          ? null
          : VendorDto.fromJson(json['vendor'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>)
          .map((e) => CartItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      subtotal: CartDto._doubleFromJson(json['subtotal']),
      deliveryFee: CartDto._doubleFromJson(json['deliveryFee']),
      total: CartDto._doubleFromJson(json['total']),
    );

Map<String, dynamic> _$CartDtoToJson(CartDto instance) => <String, dynamic>{
      'id': instance.id,
      'vendor': instance.vendor,
      'items': instance.items,
      'subtotal': instance.subtotal,
      'deliveryFee': instance.deliveryFee,
      'total': instance.total,
    };
