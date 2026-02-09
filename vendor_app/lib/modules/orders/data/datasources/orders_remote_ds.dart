import 'package:vendor_app/shared/models/paged_result.dart';

import '../models/order_dto.dart';

/// مصدر بيانات الطلبات عن بعد — Phase 8.
abstract interface class OrdersRemoteDs {
  Future<PagedResult<OrderDto>> getOrders({
    int page = 1,
    int limit = 20,
    String? status,
  });

  Future<OrderDto> getOrderById(String id);

  Future<OrderDto> acceptOrder(String id);

  Future<OrderDto> rejectOrder(String id, {String? reason});

  Future<OrderDto> updateOrderStatus(String id, String status);
}
