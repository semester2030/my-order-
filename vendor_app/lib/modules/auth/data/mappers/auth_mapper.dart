import '../../domain/entities/register_result.dart';
import '../../domain/entities/vendor_session.dart';
import '../models/login_response_dto.dart';
import '../models/register_response_dto.dart';

/// Maps auth DTOs to domain entities.
class AuthMapper {
  AuthMapper._();

  /// Maps [LoginResponseDto] to [VendorSession].
  /// Computes [VendorSession.expiresAt] from [LoginResponseDto.expiresIn] when present.
  static VendorSession toSession(LoginResponseDto dto) {
    DateTime? expiresAt;
    if (dto.expiresIn != null && dto.expiresIn! > 0) {
      expiresAt = DateTime.now().add(Duration(seconds: dto.expiresIn!));
    }
    return VendorSession(
      accessToken: dto.accessToken,
      refreshToken: dto.refreshToken,
      expiresAt: expiresAt,
    );
  }

  /// Maps [RegisterResponseDto] to [RegisterResult].
  static RegisterResult toRegisterResult(RegisterResponseDto dto) {
    return RegisterResult(
      vendorId: dto.vendorId,
      status: dto.status,
      message: dto.message,
    );
  }
}
