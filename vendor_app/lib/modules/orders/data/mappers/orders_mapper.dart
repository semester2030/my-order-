import 'package:vendor_app/shared/enums/order_status.dart';
import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import '../models/order_dto.dart';
import '../models/order_item_dto.dart';

/// تحويل DTOs الطلبات إلى كيانات النطاق — Phase 8.
class OrdersMapper {
  OrdersMapper._();

  static OrderItem toOrderItem(OrderItemDto dto) {
    return OrderItem(
      id: dto.id,
      name: dto.name,
      quantity: dto.quantity,
      unitPrice: dto.unitPrice,
      addOns: dto.addOns,
    );
  }

  static Order toOrder(OrderDto dto) {
    return Order(
      id: dto.id,
      customerName: dto.customerName,
      customerPhone: dto.customerPhone,
      status: OrderStatusX.fromString(dto.status) ?? OrderStatus.pending,
      totalAmount: dto.totalAmount,
      createdAt: DateTime.tryParse(dto.createdAt) ?? DateTime.now(),
      items: dto.items.map(toOrderItem).toList(),
      notes: dto.notes,
    );
  }

  static PagedResult<Order> toPagedOrders(PagedResult<OrderDto> dto) {
    return PagedResult<Order>(
      data: dto.data.map(toOrder).toList(),
      meta: dto.meta,
    );
  }
}
