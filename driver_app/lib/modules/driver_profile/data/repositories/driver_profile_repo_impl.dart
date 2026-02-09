import '../../domain/repositories/driver_profile_repo.dart';
import '../../data/models/driver_profile_dto.dart';
import '../../data/models/update_availability_dto.dart';
import '../datasources/driver_profile_remote_ds.dart';

/// Driver Profile Repository Implementation
class DriverProfileRepositoryImpl implements DriverProfileRepository {
  final DriverProfileRemoteDataSource remoteDataSource;

  DriverProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<bool> checkDriverExists() async {
    return await remoteDataSource.checkDriverExists();
  }

  @override
  Future<DriverProfileDto> getProfile() async {
    return await remoteDataSource.getProfile();
  }

  @override
  Future<Map<String, dynamic>> updateAvailability(UpdateAvailabilityDto dto) async {
    return await remoteDataSource.updateAvailability(dto);
  }
}
