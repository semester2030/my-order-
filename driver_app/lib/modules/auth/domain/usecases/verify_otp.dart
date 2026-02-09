import '../repositories/auth_repo.dart';
import '../../data/models/auth_tokens_dto.dart';

/// Verify OTP Use Case
/// 
/// Handles OTP verification:
/// - Validates phone and code
/// - Calls repository to verify OTP
/// - Returns auth tokens
class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase(this.repository);

  /// Execute OTP verification
  /// 
  /// [phone] - Driver phone number
  /// [code] - OTP code
  Future<AuthTokensDto> call(String phone, String code) async {
    if (phone.isEmpty) {
      throw ArgumentError('Phone number cannot be empty');
    }
    if (code.isEmpty) {
      throw ArgumentError('OTP code cannot be empty');
    }
    return await repository.verifyOtp(phone, code);
  }
}
