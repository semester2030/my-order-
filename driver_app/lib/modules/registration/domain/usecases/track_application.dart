import '../repositories/registration_repo.dart';
import '../entities/driver_entity.dart';

/// Track Application Use Case
/// 
/// Handles tracking driver application status:
/// - Validates driver ID
/// - Calls repository to get application status
/// - Returns driver entity with status
class TrackApplicationUseCase {
  final RegistrationRepository repository;

  TrackApplicationUseCase(this.repository);

  /// Execute track application
  /// 
  /// [driverId] - Driver ID
  Future<DriverEntity> call(String driverId) async {
    if (driverId.isEmpty) {
      throw ArgumentError('Driver ID is required');
    }
    return await repository.trackApplication(driverId);
  }
}
