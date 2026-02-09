import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../models/cart_dto.dart';

abstract class CartRemoteDataSource {
  Future<CartDto> getCart();
  Future<CartDto> addToCart(String menuItemId, int quantity);
  Future<CartDto> updateCartItem(String itemId, int quantity);
  Future<CartDto> removeCartItem(String itemId);
  Future<void> clearCart();
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final ApiClient apiClient;

  CartRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<CartDto> getCart() async {
    try {
      final response = await apiClient.get(Endpoints.getCart);
      return CartDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<CartDto> addToCart(String menuItemId, int quantity) async {
    try {
      final response = await apiClient.post(
        Endpoints.addToCart,
        data: {
          'menuItemId': menuItemId,
          'quantity': quantity,
        },
      );
      return CartDto.fromJson(response.data['cart'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<CartDto> updateCartItem(String itemId, int quantity) async {
    try {
      final response = await apiClient.put(
        Endpoints.updateCartItem.replaceAll('{id}', itemId),
        data: {'quantity': quantity},
      );
      return CartDto.fromJson(response.data['cart'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<CartDto> removeCartItem(String itemId) async {
    try {
      final response = await apiClient.delete(
        Endpoints.removeCartItem.replaceAll('{id}', itemId),
      );
      return CartDto.fromJson(response.data['cart'] as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<void> clearCart() async {
    try {
      await apiClient.delete(Endpoints.clearCart);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }
}
