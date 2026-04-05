import 'package:dio/dio.dart';

import 'package:vendor_app/core/errors/app_exception.dart';
import 'package:vendor_app/core/network/endpoints.dart';

import '../../domain/entities/vendor_onboarding_status.dart';
import '../models/login_request_dto.dart';
import '../models/vendor_email_otp_request_result.dart';
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

  @override
  Future<VendorOnboardingStatus> getVendorOnboardingStatus() async {
    final response = await _dio.get<Map<String, dynamic>>(
      Endpoints.authVendorOnboardingStatus,
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return VendorOnboardingStatus.fromJson(data);
  }

  @override
  Future<void> acceptVendorLegalDocument(String documentVersion) async {
    await _dio.post<void>(
      Endpoints.authVendorOnboardingLegalAccept,
      data: <String, dynamic>{'documentVersion': documentVersion.trim()},
    );
  }

  @override
  Future<VendorEmailOtpRequestResult> requestVendorEmailVerificationOtp() async {
    final response = await _dio.post<Map<String, dynamic>>(
      Endpoints.authVendorOnboardingEmailRequestOtp,
    );
    final data = response.data;
    if (data == null) {
      throw NetworkException('استجابة فارغة من الخادم');
    }
    return VendorEmailOtpRequestResult.fromJson(data);
  }

  @override
  Future<void> verifyVendorEmailWithOtp(String code) async {
    await _dio.post<void>(
      Endpoints.authVendorOnboardingEmailVerify,
      data: <String, dynamic>{'code': code.trim()},
    );
  }
}
