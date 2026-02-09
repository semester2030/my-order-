// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuItemDto _$MenuItemDtoFromJson(Map<String, dynamic> json) => MenuItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      image: json['image'] as String?,
      price: MenuItemDto._doubleFromJson(json['price']),
    );

Map<String, dynamic> _$MenuItemDtoToJson(MenuItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
    };

CartItemDto _$CartItemDtoFromJson(Map<String, dynamic> json) => CartItemDto(
      id: json['id'] as String,
      menuItem: MenuItemDto.fromJson(json['menuItem'] as Map<String, dynamic>),
      quantity: (json['quantity'] as num).toInt(),
      price: CartItemDto._doubleFromJson(json['price']),
      subtotal: CartItemDto._doubleFromJson(json['subtotal']),
    );

Map<String, dynamic> _$CartItemDtoToJson(CartItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'menuItem': instance.menuItem,
      'quantity': instance.quantity,
      'price': instance.price,
      'subtotal': instance.subtotal,
    };
