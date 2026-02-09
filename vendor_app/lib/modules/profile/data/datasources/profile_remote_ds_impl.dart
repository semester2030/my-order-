import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';

import '../models/vendor_profile_dto.dart';
import 'profile_remote_ds.dart';

/// تنفيذ Profile عبر الباك اند — Phase 7.
class ProfileRemoteDsImpl implements ProfileRemoteDs {
  ProfileRemoteDsImpl(this._dio);

  final Dio _dio;

  @override
  Future<VendorProfileDto> getProfile() async {
    final response = await _dio.get<Map<String, dynamic>>(Endpoints.vendorsProfile);
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return VendorProfileDto.fromJson(data);
  }

  @override
  Future<VendorProfileDto> updateProfile(VendorProfileDto dto) async {
    final response = await _dio.put<Map<String, dynamic>>(
      Endpoints.vendorsProfile,
      data: dto.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return VendorProfileDto.fromJson(data);
  }

  @override
  Future<void> changePassword(String currentPassword, String newPassword) async {
    await _dio.post<void>(
      Endpoints.vendorsChangePassword,
      data: <String, dynamic>{
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }
}
