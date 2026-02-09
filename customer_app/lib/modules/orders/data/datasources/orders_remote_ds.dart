import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../models/order_dto.dart';

abstract class OrdersRemoteDataSource {
  Future<OrderDto> createOrder(String addressId, {String? notes});
  Future<List<OrderDto>> getOrders();
  Future<OrderDto> getOrderDetails(String orderId);
  Future<void> cancelOrder(String orderId);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  final ApiClient apiClient;

  OrdersRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<OrderDto> createOrder(String addressId, {String? notes}) async {
    try {
      final response = await apiClient.post(
        Endpoints.createOrder,
        data: {
          'addressId': addressId,
          if (notes != null) 'notes': notes,
        },
      );
      return OrderDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<List<OrderDto>> getOrders() async {
    try {
      final response = await apiClient.get(Endpoints.getOrders);
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => OrderDto.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<OrderDto> getOrderDetails(String orderId) async {
    try {
      final response = await apiClient.get(
        Endpoints.getOrderDetails.replaceAll('{id}', orderId),
      );
      return OrderDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<void> cancelOrder(String orderId) async {
    try {
      await apiClient.delete(
        Endpoints.cancelOrder.replaceAll('{id}', orderId),
      );
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }
}
