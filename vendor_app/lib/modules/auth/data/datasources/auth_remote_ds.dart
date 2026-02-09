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
}
