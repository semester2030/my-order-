import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/orders_repo.dart';
import '../../../../core/di/providers.dart';
import 'order_details_state.dart';

final orderDetailsNotifierProvider = StateNotifierProvider.family<
    OrderDetailsNotifier, OrderDetailsState, String>((ref, orderId) {
  final repository = ref.watch(ordersRepositoryProvider);
  return OrderDetailsNotifier(repository, orderId);
});

class OrderDetailsNotifier extends StateNotifier<OrderDetailsState> {
  final OrdersRepository repository;
  final String orderId;

  OrderDetailsNotifier(this.repository, this.orderId)
      : super(const OrderDetailsState.initial()) {
    loadOrderDetails();
  }

  Future<void> loadOrderDetails() async {
    state = const OrderDetailsState.loading();
    try {
      final order = await repository.getOrderDetails(orderId);
      state = OrderDetailsState.loaded(order);
    } catch (e) {
      state = OrderDetailsState.error(e.toString());
    }
  }

  Future<void> cancelOrder() async {
    state = const OrderDetailsState.loading();
    try {
      await repository.cancelOrder(orderId);
      await loadOrderDetails(); // Reload to get updated status
    } catch (e) {
      state = OrderDetailsState.error(e.toString());
    }
  }

  Future<void> refresh() async {
    await loadOrderDetails();
  }
}
