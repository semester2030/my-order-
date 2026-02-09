import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/orders_repo.dart';
import '../../../../core/di/providers.dart';
import 'orders_state.dart';

final ordersNotifierProvider =
    StateNotifierProvider<OrdersNotifier, OrdersState>((ref) {
  final repository = ref.watch(ordersRepositoryProvider);
  return OrdersNotifier(repository);
});

class OrdersNotifier extends StateNotifier<OrdersState> {
  final OrdersRepository repository;

  OrdersNotifier(this.repository) : super(const OrdersState.initial()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    state = const OrdersState.loading();
    try {
      final orders = await repository.getOrders();
      state = OrdersState.loaded(orders);
    } catch (e) {
      state = OrdersState.error(e.toString());
    }
  }

  Future<void> refreshOrders() async {
    await loadOrders();
  }
}
