import '../entities/order.dart';

abstract class OrdersRepository {
  Future<Order> createOrder(
    String addressId, {
    String? notes,
    String? requestedReadyAt,
    String? orderType,
  });
  Future<List<Order>> getOrders();
  Future<Order> getOrderDetails(String orderId);
  Future<void> cancelOrder(String orderId);
}
