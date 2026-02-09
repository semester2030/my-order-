import '../repositories/driver_profile_repo.dart';
import '../../data/models/update_availability_dto.dart';

/// Set Availability Use Case
/// 
/// Handles updating driver availability:
/// - Validates DTO
/// - Calls repository to update availability
/// - Returns update result
class SetAvailabilityUseCase {
  final DriverProfileRepository repository;

  SetAvailabilityUseCase(this.repository);

  /// Execute set availability
  /// 
  /// [dto] - Availability update data
  Future<Map<String, dynamic>> call(UpdateAvailabilityDto dto) async {
    return await repository.updateAvailability(dto);
  }
}
