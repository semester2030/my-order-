// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorDto _$VendorDtoFromJson(Map<String, dynamic> json) => VendorDto(
      id: VendorDto._stringFromJson(json['id']),
      name: VendorDto._stringFromJson(json['name']),
      description: json['description'] as String?,
      logo: json['logo'] as String?,
      cover: json['cover'] as String?,
      rating: VendorDto._doubleFromJson(json['rating']),
      ratingCount: VendorDto._intFromJson(json['rating_count']),
      type: VendorDto._stringFromJson(json['type']),
      address: VendorDto._stringFromJson(json['address']),
      phoneNumber: VendorDto._stringFromJson(json['phone_number']),
      isActive: VendorDto._boolFromJson(json['is_active']),
      isAcceptingOrders: VendorDto._boolFromJson(json['is_accepting_orders']),
      providerCategory: json['provider_category'] as String?,
      popularCookingAddOns: VendorDto._popularCookingAddOnsFromJson(json['popular_cooking_add_ons']),
    );

Map<String, dynamic> _$VendorDtoToJson(VendorDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'logo': instance.logo,
      'cover': instance.cover,
      'rating': instance.rating,
      'rating_count': instance.ratingCount,
      'type': instance.type,
      'address': instance.address,
      'phone_number': instance.phoneNumber,
      'is_active': instance.isActive,
      'is_accepting_orders': instance.isAcceptingOrders,
      'provider_category': instance.providerCategory,
      'popular_cooking_add_ons': instance.popularCookingAddOns?.map((e) => <String, dynamic>{'name': e.name, 'price': e.price}).toList(),
    };
