import '../repositories/registration_repo.dart';
import '../../data/models/register_step2_dto.dart';

/// Register Step 2 Use Case
/// 
/// Handles driver registration step 2:
/// - Validates DTO
/// - Calls repository to register step 2
/// - Returns driver ID and status
class RegisterStep2UseCase {
  final RegistrationRepository repository;

  RegisterStep2UseCase(this.repository);

  /// Execute registration step 2
  /// 
  /// [driverId] - Driver ID from step 1
  /// [dto] - Registration step 2 data
  Future<Map<String, dynamic>> call(String driverId, RegisterStep2Dto dto) async {
    if (driverId.isEmpty) {
      throw ArgumentError('Driver ID is required');
    }
    if (dto.fullName.isEmpty) {
      throw ArgumentError('Full name is required');
    }
    if (dto.licensePhotoFront.isEmpty || dto.licensePhotoBack.isEmpty) {
      throw ArgumentError('License photos are required');
    }
    if (dto.vehiclePhoto.isEmpty) {
      throw ArgumentError('Vehicle photo is required');
    }
    return await repository.registerStep2(driverId, dto);
  }
}
