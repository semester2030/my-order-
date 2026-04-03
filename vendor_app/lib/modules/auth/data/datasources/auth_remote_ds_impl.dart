import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';

import '../models/login_request_dto.dart';
import '../models/login_response_dto.dart';
import '../models/register_response_dto.dart';
import '../models/register_vendor_dto.dart';
import 'auth_remote_ds.dart';

/// تنفيذ Auth عبر الباك اند — Phase 7.
class AuthRemoteDsImpl implements AuthRemoteDs {
  AuthRemoteDsImpl(this._dio);

  final Dio _dio;

  @override
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.authVendorLogin,
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return LoginResponseDto.fromJson(data);
  }

  @override
  Future<RegisterResponseDto> register(RegisterVendorDto dto) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.vendorsRegister,
      data: dto.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return RegisterResponseDto.fromJson(data);
  }

  @override
  Future<LoginResponseDto> refresh(String refreshToken) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.authRefresh,
      data: <String, dynamic>{'refreshToken': refreshToken},
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return LoginResponseDto.fromJson(data);
  }

  @override
  Future<void> deleteAccount(String currentPassword) async {
    await _dio.post<void>(
      Endpoints.accountDelete,
      data: <String, dynamic>{'currentPassword': currentPassword},
    );
  }

  @override
  Future<({String message, String? devOtp})> requestVendorPasswordReset(
    String email,
  ) async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.authVendorPasswordResetRequest,
      data: <String, dynamic>{'email': email.trim()},
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    final message = data['message'] as String? ?? '';
    final devOtp = data['code'] as String?;
    return (message: message, devOtp: devOtp);
  }

  @override
  Future<void> confirmVendorPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    await _dio.post<void>(
      Endpoints.authVendorPasswordResetConfirm,
      data: <String, dynamic>{
        'email': email.trim(),
        'code': code.trim(),
        'newPassword': newPassword,
      },
    );
  }
}
