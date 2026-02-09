import 'package:vendor_app/shared/models/api_meta.dart';
import 'package:vendor_app/shared/models/paged_result.dart';

import '../models/order_dto.dart';
import '../models/order_item_dto.dart';
import 'orders_remote_ds.dart';

/// Stub للطلبات حتى ربط الـ API — Phase 8.
class OrdersRemoteDsStub implements OrdersRemoteDs {
  @override
  Future<PagedResult<OrderDto>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return PagedResult<OrderDto>(
      data: const [],
      meta: ApiMeta(page: page, limit: limit, total: 0, totalPages: 0),
    );
  }

  @override
  Future<OrderDto> getOrderById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    return OrderDto(
      id: id,
      customerName: 'عميل تجريبي',
      customerPhone: '0500000000',
      status: 'pending',
      totalAmount: 100.0,
      createdAt: DateTime.now().toIso8601String(),
      items: [
        OrderItemDto(
          id: 'item-1',
          name: 'وجبة تجريبية',
          quantity: 2,
          unitPrice: 50.0,
        ),
      ],
    );
  }

  @override
  Future<OrderDto> acceptOrder(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return getOrderById(id);
  }

  @override
  Future<OrderDto> rejectOrder(String id, {String? reason}) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return getOrderById(id);
  }

  @override
  Future<OrderDto> updateOrderStatus(String id, String status) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final order = await getOrderById(id);
    return OrderDto(
      id: order.id,
      customerName: order.customerName,
      customerPhone: order.customerPhone,
      status: status,
      totalAmount: order.totalAmount,
      createdAt: order.createdAt,
      items: order.items,
      notes: order.notes,
    );
  }
}
