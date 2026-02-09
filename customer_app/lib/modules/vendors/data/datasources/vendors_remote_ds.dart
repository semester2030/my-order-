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
}
