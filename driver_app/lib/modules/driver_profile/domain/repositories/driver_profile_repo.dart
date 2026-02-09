import '../../data/models/driver_profile_dto.dart';
import '../../data/models/update_availability_dto.dart';

/// Driver Profile Repository
abstract class DriverProfileRepository {
  Future<bool> checkDriverExists();
  Future<DriverProfileDto> getProfile();
  Future<Map<String, dynamic>> updateAvailability(UpdateAvailabilityDto dto);
}
