import '../../domain/entities/vendor_onboarding_status.dart';
import '../models/login_request_dto.dart';
import '../models/login_response_dto.dart';
import '../models/register_response_dto.dart';
import '../models/register_vendor_dto.dart';

/// Remote datasource for auth: login, register, refresh.
/// Phase 2: interface only; real HTTP calls in Phase 7; refresh in Phase 17.
abstract interface class AuthRemoteDs {
  /// POST /auth/vendor/login. Returns tokens on success.
  Future<LoginResponseDto> login(LoginRequestDto request);

  /// POST /vendors/register. Returns vendorId, status, message on success.
  Future<RegisterResponseDto> register(RegisterVendorDto dto);

  /// POST /auth/refresh. Returns new tokens (Phase 17).
  Future<LoginResponseDto> refresh(String refreshToken);

  /// POST /auth/account/delete — يتطلب Bearer؛ حذف أو إلغاء تعريف الحساب حسب سياسة الخادم.
  Future<void> deleteAccount(String currentPassword);

  /// POST /auth/vendor/password-reset/request — رسالة للمستخدم؛ [devOtp] في بيئة التطوير/القائمة البيضاء فقط.
  Future<({String message, String? devOtp})> requestVendorPasswordReset(
    String email,
  );

  /// POST /auth/vendor/password-reset/confirm
  Future<void> confirmVendorPasswordReset({
    required String email,
    required String code,
    required String newPassword,
  });

  /// GET /auth/vendor/onboarding/status — بريد، لوائح، إصدارات مطلوبة.
  Future<VendorOnboardingStatus> getVendorOnboardingStatus();

  /// POST /auth/vendor/onboarding/legal/accept
  Future<void> acceptVendorLegalDocument(String documentVersion);
}
