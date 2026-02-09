import '../repositories/registration_repo.dart';
import '../../data/models/register_step3_dto.dart';

/// Register Step 3 Use Case
/// 
/// Handles driver registration step 3:
/// - Validates DTO
/// - Calls repository to register step 3
/// - Returns driver ID and status
class RegisterStep3UseCase {
  final RegistrationRepository repository;

  RegisterStep3UseCase(this.repository);

  /// Execute registration step 3
  /// 
  /// [driverId] - Driver ID from step 1
  /// [dto] - Registration step 3 data
  Future<Map<String, dynamic>> call(String driverId, RegisterStep3Dto dto) async {
    if (driverId.isEmpty) {
      throw ArgumentError('Driver ID is required');
    }
    if (dto.insuranceCompany.isEmpty) {
      throw ArgumentError('Insurance company is required');
    }
    if (dto.bankName.isEmpty) {
      throw ArgumentError('Bank name is required');
    }
    return await repository.registerStep3(driverId, dto);
  }
}
