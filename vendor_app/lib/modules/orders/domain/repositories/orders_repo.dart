import 'package:vendor_app/core/errors/failure.dart';
import 'package:vendor_app/core/utils/result.dart' as res;
import 'package:vendor_app/shared/enums/order_status.dart';
import 'package:vendor_app/shared/models/paged_result.dart';

import '../entities/order.dart';

/// مستودع الطلبات — Phase 8 (قوائم + تفاصيل + قبول/رفض/تحديث حالة).
abstract interface class OrdersRepo {
  Future<res.Result<PagedResult<Order>, Failure>> getOrders({
    int page = 1,
    int limit = 20,
    OrderStatus? status,
  });

  Future<res.Result<Order, Failure>> getOrderById(String id);

  Future<res.Result<Order, Failure>> acceptOrder(String id);

  Future<res.Result<Order, Failure>> rejectOrder(String id, {String? reason});

  Future<res.Result<Order, Failure>> updateOrderStatus(String id, OrderStatus status);
}
