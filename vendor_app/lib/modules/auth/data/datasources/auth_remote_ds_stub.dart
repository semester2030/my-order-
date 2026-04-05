import '../../domain/entities/vendor_onboarding_status.dart';
import '../models/login_request_dto.dart';
import '../models/vendor_email_otp_request_result.dart';
import '../models/login_response_dto.dart';
import '../models/register_response_dto.dart';
import 'auth_remote_ds.dart';
import '../models/register_vendor_dto.dart';

/// Stub implementation: throws until real API is wired in Phase 7.
class AuthRemoteDsStub implements AuthRemoteDs {
  @override
  Future<LoginResponseDto> login(LoginRequestDto request) async {
    throw UnimplementedError('Auth API not wired yet (Phase 7)');
  }

  @override
  Future<RegisterResponseDto> register(RegisterVendorDto dto) async {
    throw UnimplementedError('Auth API not wired yet (Phase 7)');
  }

  @override
  Future<LoginResponseDto> refresh(String refreshToken) async {
    throw UnimplementedError('Auth refresh not wired (Phase 17)');
  }

  @override
  Future<void> deleteAccount(String currentPassword) async {
    throw UnimplementedError('deleteAccount not wired');
  }

  @override
  Future<({String message, String? devOtp})> requestVendorPasswordReset(
    String email,
  ) async {
    throw UnimplementedError('vendor password reset not wired');
  }

  @override
  Future<void> confirmVendorPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  }) async {
    throw UnimplementedError('vendor password reset not wired');
  }

  @override
  Future<VendorOnboardingStatus> getVendorOnboardingStatus() async {
    return const VendorOnboardingStatus(
      emailVerified: true,
      legalAccepted: true,
      requiredLegalDocumentVersion: 'stub',
    );
  }

  @override
  Future<void> acceptVendorLegalDocument(String documentVersion) async {}

  @override
  Future<VendorEmailOtpRequestResult> requestVendorEmailVerificationOtp() async {
    return const VendorEmailOtpRequestResult(
      sent: true,
      message: 'stub',
      code: '123456',
    );
  }

  @override
  Future<void> verifyVendorEmailWithOtp(String code) async {}
}
