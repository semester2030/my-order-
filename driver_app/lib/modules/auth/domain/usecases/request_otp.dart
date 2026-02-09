import '../repositories/auth_repo.dart';

/// Request OTP Use Case
/// 
/// Handles OTP request:
/// - Validates phone number
/// - Calls repository to request OTP
class RequestOtpUseCase {
  final AuthRepository repository;

  RequestOtpUseCase(this.repository);

  /// Execute OTP request
  /// 
  /// [phone] - Driver phone number
  Future<Map<String, dynamic>> call(String phone) async {
    if (phone.isEmpty) {
      throw ArgumentError('Phone number cannot be empty');
    }
    return await repository.requestOtp(phone);
  }
}
