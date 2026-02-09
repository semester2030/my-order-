import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../models/address_dto.dart';

abstract class AddressesRemoteDataSource {
  Future<List<AddressDto>> getAddresses();
  Future<AddressDto> getDefaultAddress();
  Future<AddressDto> addAddress(Map<String, dynamic> addressData);
  Future<AddressDto> updateAddress(String id, Map<String, dynamic> addressData);
  Future<void> deleteAddress(String id);
}

class AddressesRemoteDataSourceImpl implements AddressesRemoteDataSource {
  final ApiClient apiClient;

  AddressesRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<AddressDto>> getAddresses() async {
    try {
      final response = await apiClient.get(Endpoints.getAddresses);
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((json) => AddressDto.fromJson(json as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<AddressDto> getDefaultAddress() async {
    try {
      final response = await apiClient.get('${Endpoints.getAddresses}/default');
      // Ensure city is always a string (handle null or invalid values)
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['city'] == null || 
          (responseData['city'] is String && (responseData['city'] as String).isEmpty) ||
          responseData['city'] == 'CA' || 
          responseData['city'] == 'California') {
        responseData['city'] = 'Riyadh';
      }
      return AddressDto.fromJson(responseData);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<AddressDto> addAddress(Map<String, dynamic> addressData) async {
    try {
      final response = await apiClient.post(
        Endpoints.addAddress,
        data: addressData,
      );
      // Ensure city is always a string (handle null or invalid values)
      final responseData = response.data as Map<String, dynamic>;
      if (responseData['city'] == null || 
          (responseData['city'] is String && (responseData['city'] as String).isEmpty) ||
          responseData['city'] == 'CA' || 
          responseData['city'] == 'California') {
        responseData['city'] = 'Riyadh';
      }
      return AddressDto.fromJson(responseData);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<AddressDto> updateAddress(
    String id,
    Map<String, dynamic> addressData,
  ) async {
    try {
      final response = await apiClient.put(
        Endpoints.updateAddress.replaceAll('{id}', id),
        data: addressData,
      );
      return AddressDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<void> deleteAddress(String id) async {
    try {
      await apiClient.delete(Endpoints.deleteAddress.replaceAll('{id}', id));
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }
}
