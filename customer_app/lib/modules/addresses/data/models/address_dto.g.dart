// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressDto _$AddressDtoFromJson(Map<String, dynamic> json) => AddressDto(
      id: AddressDto._stringFromJson(json['id']),
      userId: AddressDto._stringFromJson(json['user_id']),
      label: AddressDto._stringFromJson(json['label']),
      streetAddress: AddressDto._stringFromJson(json['street_address']),
      building: json['building'] as String?,
      floor: json['floor'] as String?,
      apartment: json['apartment'] as String?,
      city: AddressDto._stringFromJson(json['city']),
      district: json['district'] as String?,
      postalCode: json['postal_code'] as String?,
      latitude: AddressDto._doubleFromJson(json['latitude']),
      longitude: AddressDto._doubleFromJson(json['longitude']),
      isDefault: AddressDto._boolFromJson(json['is_default']),
      isActive: AddressDto._boolFromJson(json['is_active']),
      createdAt: AddressDto._stringFromJson(json['created_at']),
      updatedAt: AddressDto._stringFromJson(json['updated_at']),
    );

Map<String, dynamic> _$AddressDtoToJson(AddressDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'label': instance.label,
      'street_address': instance.streetAddress,
      'building': instance.building,
      'floor': instance.floor,
      'apartment': instance.apartment,
      'city': instance.city,
      'district': instance.district,
      'postal_code': instance.postalCode,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'is_default': instance.isDefault,
      'is_active': instance.isActive,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
