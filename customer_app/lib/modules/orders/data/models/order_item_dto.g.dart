// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderMenuItemDto _$OrderMenuItemDtoFromJson(Map<String, dynamic> json) =>
    OrderMenuItemDto(
      id: OrderMenuItemDto._stringFromJson(json['id']),
      name: OrderMenuItemDto._stringFromJson(json['name']),
      description: json['description'] as String?,
      image: json['image'] as String?,
      price: OrderMenuItemDto._doubleFromJson(json['price']),
    );

Map<String, dynamic> _$OrderMenuItemDtoToJson(OrderMenuItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image,
      'price': instance.price,
    };

OrderItemDto _$OrderItemDtoFromJson(Map<String, dynamic> json) => OrderItemDto(
      id: OrderItemDto._stringFromJson(json['id']),
      menuItem: OrderItemDto._menuItemFromJson(json['menuItem']),
      quantity: (json['quantity'] as num).toInt(),
      price: OrderItemDto._doubleFromJson(json['price']),
      subtotal: OrderItemDto._doubleFromJson(json['subtotal']),
    );

Map<String, dynamic> _$OrderItemDtoToJson(OrderItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'menuItem': instance.menuItem,
      'quantity': instance.quantity,
      'price': instance.price,
      'subtotal': instance.subtotal,
    };
