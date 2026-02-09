import '../repositories/registration_repo.dart';
import '../../data/models/register_step1_dto.dart';

/// Register Step 1 Use Case
/// 
/// Handles driver registration step 1:
/// - Validates DTO
/// - Calls repository to register step 1
/// - Returns driver ID and status
class RegisterStep1UseCase {
  final RegistrationRepository repository;

  RegisterStep1UseCase(this.repository);

  /// Execute registration step 1
  /// 
  /// [dto] - Registration step 1 data
  Future<Map<String, dynamic>> call(RegisterStep1Dto dto) async {
    if (dto.phoneNumber.isEmpty) {
      throw ArgumentError('Phone number is required');
    }
    return await repository.registerStep1(dto);
  }
}
