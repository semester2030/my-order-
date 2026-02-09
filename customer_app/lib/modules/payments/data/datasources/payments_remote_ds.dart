import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../models/payment_dto.dart';
import '../models/payment_init_dto.dart';
import '../models/payment_confirm_dto.dart';

abstract class PaymentsRemoteDataSource {
  Future<PaymentDto> initiatePayment(String orderId, String method);
  Future<PaymentDto> confirmPayment(String paymentId, String transactionId);
  Future<PaymentDto> getPayment(String paymentId);
  Future<List<PaymentDto>> getOrderPayments(String orderId);
}

class PaymentsRemoteDataSourceImpl implements PaymentsRemoteDataSource {
  final ApiClient apiClient;

  PaymentsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<PaymentDto> initiatePayment(String orderId, String method) async {
    try {
      final dto = PaymentInitDto(orderId: orderId, method: method);
      final response = await apiClient.post(
        Endpoints.initiatePayment,
        data: dto.toJson(),
      );
      return PaymentDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<PaymentDto> confirmPayment(
    String paymentId,
    String transactionId,
  ) async {
    try {
      final dto = PaymentConfirmDto(
        paymentId: paymentId,
        transactionId: transactionId,
      );
      final response = await apiClient.post(
        Endpoints.confirmPayment,
        data: dto.toJson(),
      );
      return PaymentDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<PaymentDto> getPayment(String paymentId) async {
    try {
      final response = await apiClient.get(
        Endpoints.getPayment.replaceAll('{id}', paymentId),
      );
      return PaymentDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<List<PaymentDto>> getOrderPayments(String orderId) async {
    try {
      final response = await apiClient.get(
        Endpoints.getOrderPayments.replaceAll('{orderId}', orderId),
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((json) => PaymentDto.fromJson(json as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }
}
