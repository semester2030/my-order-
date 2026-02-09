import '../../domain/repositories/orders_repo.dart';
import '../../domain/entities/order.dart';
import '../datasources/orders_remote_ds.dart';
import '../mappers/orders_mapper.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource remoteDataSource;

  OrdersRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Order> createOrder(String addressId, {String? notes}) async {
    final dto = await remoteDataSource.createOrder(addressId, notes: notes);
    return OrdersMapper.mapOrderFromDto(dto);
  }

  @override
  Future<List<Order>> getOrders() async {
    final dtos = await remoteDataSource.getOrders();
    return OrdersMapper.mapOrdersFromDto(dtos);
  }

  @override
  Future<Order> getOrderDetails(String orderId) async {
    final dto = await remoteDataSource.getOrderDetails(orderId);
    return OrdersMapper.mapOrderFromDto(dto);
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    await remoteDataSource.cancelOrder(orderId);
  }
}
