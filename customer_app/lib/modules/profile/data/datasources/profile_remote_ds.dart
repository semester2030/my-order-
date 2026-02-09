import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../models/profile_dto.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileDto> getProfile();
  Future<ProfileDto> updateProfile({String? name, String? email});
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ProfileDto> getProfile() async {
    try {
      final response = await apiClient.get(Endpoints.userProfile);
      return ProfileDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }

  @override
  Future<ProfileDto> updateProfile({String? name, String? email}) async {
    try {
      final data = <String, dynamic>{};
      if (name != null) data['name'] = name;
      if (email != null) data['email'] = email;

      final response = await apiClient.put(
        Endpoints.userProfile,
        data: data,
      );
      return ProfileDto.fromJson(response.data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        throw e.error as NetworkException;
      }
      throw NetworkException.unknown(message: e.message ?? 'Unknown error');
    }
  }
}
