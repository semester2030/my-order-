import '../repositories/driver_profile_repo.dart';
import '../../data/models/driver_profile_dto.dart';

/// Get Driver Profile Use Case
/// 
/// Handles fetching driver profile:
/// - Calls repository to get profile
/// - Returns driver profile
class GetDriverProfileUseCase {
  final DriverProfileRepository repository;

  GetDriverProfileUseCase(this.repository);

  /// Execute get driver profile
  Future<DriverProfileDto> call() async {
    return await repository.getProfile();
  }
}
