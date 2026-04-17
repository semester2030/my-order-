import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../models/vendor_dto.dart';
import '../models/menu_item_dto.dart';

abstract class VendorsRemoteDataSource {
  Future<VendorDto> getVendor(String vendorId);
  Future<List<MenuItemDto>> getVendorMenu(String vendorId);
  Future<List<MenuItemDto>> getSignatureItems(String vendorId);
  Future<void> createEventRequest(Map<String, dynamic> body);
  Future<List<Map<String, dynamic>>> getMyEventRequests();
  Future<Map<String, dynamic>> getMyEventRequestById(String requestId);
  Future<void> declareHomeCookingPayment(
    String requestId, {
    required String paymentReference,
    String? notes,
  });
  Future<Map<String, dynamic>> confirmHomeCookingReceipt(String requestId);
  Future<void> cancelEventRequest(String requestId);
  Future<List<Map<String, dynamic>>> getVendorEventOffers(String vendorId);
  Future<void> createPrivateEventRequest(Map<String, dynamic> body);
}

class VendorsRemoteDataSourceImpl implements VendorsRemoteDataSource {
  final ApiClient apiClient;

  VendorsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<VendorDto> getVendor(String vendorId) async {
    try {
      final response = await apiClient.get(
        Endpoints.getVendorDetails.replaceAll('{id}', vendorId),
      );
      return VendorDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<List<MenuItemDto>> getVendorMenu(String vendorId) async {
    try {
      final response = await apiClient.get(
        Endpoints.getVendorMenu.replaceAll('{vendorId}', vendorId),
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => MenuItemDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<List<MenuItemDto>> getSignatureItems(String vendorId) async {
    try {
      final response = await apiClient.get(
        Endpoints.getSignatureItems.replaceAll('{vendorId}', vendorId),
      );
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => MenuItemDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<void> createEventRequest(Map<String, dynamic> body) async {
    try {
      await apiClient.post(Endpoints.createEventRequest, data: body);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getMyEventRequests() async {
    try {
      final response = await apiClient.get(Endpoints.listMyEventRequests);
      final data = response.data;
      if (data is! List<dynamic>) {
        return [];
      }
      return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<Map<String, dynamic>> getMyEventRequestById(String requestId) async {
    try {
      final response = await apiClient.get(Endpoints.eventRequestById(requestId));
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<void> declareHomeCookingPayment(
    String requestId, {
    required String paymentReference,
    String? notes,
  }) async {
    try {
      await apiClient.post(
        Endpoints.declareHomeCookingPayment(requestId),
        data: <String, dynamic>{
          'paymentReference': paymentReference,
          if (notes != null && notes.trim().isNotEmpty) 'notes': notes.trim(),
        },
      );
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<Map<String, dynamic>> confirmHomeCookingReceipt(String requestId) async {
    try {
      final response = await apiClient.post(
        Endpoints.confirmHomeCookingReceipt(requestId),
        data: <String, dynamic>{},
      );
      return Map<String, dynamic>.from(response.data as Map);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<void> cancelEventRequest(String requestId) async {
    try {
      await apiClient.post(Endpoints.cancelEventRequest(requestId));
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getVendorEventOffers(String vendorId) async {
    try {
      final response = await apiClient.get(Endpoints.vendorEventOffers(vendorId));
      final List<dynamic> data = response.data as List<dynamic>;
      return data.map((e) => e as Map<String, dynamic>).toList();
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<void> createPrivateEventRequest(Map<String, dynamic> body) async {
    try {
      await apiClient.post(Endpoints.privateEventRequests, data: body);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }
}
