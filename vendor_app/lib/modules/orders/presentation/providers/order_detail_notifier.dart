import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vendor_app/core/utils/result.dart' as res;
import 'package:vendor_app/shared/enums/order_status.dart';

import '../../domain/entities/order.dart';
import '../../domain/repositories/orders_repo.dart';
import 'order_detail_state.dart';

/// Notifier لتفاصيل الطلب — Phase 9 (جلب، قبول، رفض، تحديث حالة).
class OrderDetailNotifier extends StateNotifier<OrderDetailState> {
  OrderDetailNotifier(this._repo) : super(const OrderDetailInitial());

  final OrdersRepo _repo;

  Future<void> loadOrder(String id) async {
    state = const OrderDetailLoading();
    final result = await _repo.getOrderById(id);
    result.when(
      success: (order) => state = OrderDetailLoaded(order),
      failure: (f) => state = OrderDetailError(f.message),
    );
  }

  Future<bool> acceptOrder(String id) async {
    final previous = state;
    final order = previous is OrderDetailLoaded ? previous.order : null;
    if (order != null) state = OrderDetailSaving(order);
    final result = await _repo.acceptOrder(id);
    return result.when(
      success: (Order order) {
        state = OrderDetailLoaded(order);
        return true;
      },
      failure: (f) {
        state = OrderDetailError(f.message);
        loadOrder(id);
        return false;
      },
    );
  }

  Future<bool> rejectOrder(String id, {String? reason}) async {
    final previous = state;
    final order = previous is OrderDetailLoaded ? previous.order : null;
    if (order != null) state = OrderDetailSaving(order);
    final result = await _repo.rejectOrder(id, reason: reason);
    return result.when(
      success: (Order order) {
        state = OrderDetailLoaded(order);
        return true;
      },
      failure: (f) {
        state = OrderDetailError(f.message);
        loadOrder(id);
        return false;
      },
    );
  }

  Future<bool> updateOrderStatus(String id, OrderStatus status) async {
    final previous = state;
    final order = previous is OrderDetailLoaded ? previous.order : null;
    if (order != null) state = OrderDetailSaving(order);
    final result = await _repo.updateOrderStatus(id, status);
    return result.when(
      success: (Order order) {
        state = OrderDetailLoaded(order);
        return true;
      },
      failure: (f) {
        state = OrderDetailError(f.message);
        return false;
      },
    );
  }
}
