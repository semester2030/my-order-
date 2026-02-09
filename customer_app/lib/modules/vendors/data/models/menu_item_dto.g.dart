// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItemDto _$MenuItemDtoFromJson(Map<String, dynamic> json) => MenuItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: MenuItemDto._doubleFromJson(json['price']),
      image: json['image'] as String?,
      isSignature: MenuItemDto._boolFromJson(json['is_signature']),
      isAvailable: MenuItemDto._boolFromJson(json['is_available']),
    );

Map<String, dynamic> _$MenuItemDtoToJson(MenuItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'image': instance.image,
      'is_signature': instance.isSignature,
      'is_available': instance.isAvailable,
    };
