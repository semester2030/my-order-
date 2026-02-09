import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../../domain/entities/order_tracking.dart';
import '../../../feed/domain/entities/feed_item.dart';
import '../../../addresses/domain/entities/address.dart';
import '../models/order_dto.dart' as order_dto;
import '../models/order_item_dto.dart' as order_item_dto;

class OrdersMapper {
  static OrderStatus mapStatusFromString(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'confirmed':
        return OrderStatus.confirmed;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready':
        return OrderStatus.ready;
      case 'out_for_delivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  static Vendor mapVendorFromDto(order_dto.OrderVendorDto dto) {
    return Vendor(
      id: dto.id,
      name: dto.name,
      logo: dto.logo,
      rating: 0.0, // Not provided in order DTO
      ratingCount: 0, // Not provided in order DTO
      type: '', // Not provided in order DTO
    );
  }

  static Address mapAddressFromDto(order_dto.OrderAddressDto dto) {
    return Address(
      id: dto.id,
      label: dto.label,
      streetAddress: dto.streetAddress,
      building: dto.building,
      floor: dto.floor,
      apartment: dto.apartment,
      city: dto.city,
      district: dto.district,
      postalCode: null, // Not provided
      latitude: 0.0, // Not provided
      longitude: 0.0, // Not provided
      isDefault: false,
      isActive: true,
    );
  }

  static MenuItem mapMenuItemFromDto(order_item_dto.OrderMenuItemDto dto) {
    return MenuItem(
      id: dto.id,
      name: dto.name,
      description: dto.description,
      image: dto.image,
      price: dto.price,
      isSignature: false, // Not provided in order DTO
    );
  }

  static OrderItem mapOrderItemFromDto(order_item_dto.OrderItemDto dto) {
    return OrderItem(
      id: dto.id,
      menuItemId: dto.menuItem.id,
      menuItem: mapMenuItemFromDto(dto.menuItem),
      quantity: dto.quantity,
      price: dto.price,
    );
  }

  static List<OrderItem> mapOrderItemsFromDto(
      List<order_item_dto.OrderItemDto> dtos,) {
    return dtos.map((dto) => mapOrderItemFromDto(dto)).toList();
  }

  static OrderTracking mapTrackingFromDto(order_dto.OrderDto dto) {
    return OrderTracking(
      status: mapStatusFromString(dto.status),
      estimatedDeliveryTime: dto.estimatedDeliveryTime != null
          ? _parseDateTime(dto.estimatedDeliveryTime!)
          : null,
      deliveredAt:
          dto.deliveredAt != null ? _parseDateTime(dto.deliveredAt!) : null,
      driverId: dto.driverId,
      driverPhone: dto.driverPhone,
      driverName: dto.driverName,
      driverLatitude: dto.driverLatitude,
      driverLongitude: dto.driverLongitude,
    );
  }

  static Order mapOrderFromDto(order_dto.OrderDto dto) {
    return Order(
      id: dto.id,
      orderNumber: dto.orderNumber,
      tracking: mapTrackingFromDto(dto),
      vendor: mapVendorFromDto(dto.vendor),
      address: mapAddressFromDto(dto.address),
      items: mapOrderItemsFromDto(dto.items),
      subtotal: dto.subtotal,
      deliveryFee: dto.deliveryFee,
      total: dto.total,
      createdAt: _parseDateTime(dto.createdAt),
      updatedAt: _parseDateTime(dto.updatedAt),
    );
  }

  static DateTime _parseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      // If date parsing fails, return current time
      return DateTime.now();
    }
  }

  static List<Order> mapOrdersFromDto(List<order_dto.OrderDto> dtos) {
    return dtos.map((dto) => mapOrderFromDto(dto)).toList();
  }
}
