import '../../domain/repositories/registration_repo.dart';
import '../../domain/entities/driver_entity.dart';
import '../datasources/registration_remote_ds.dart';
import '../models/register_step1_dto.dart';
import '../models/register_step2_dto.dart';
import '../models/register_step3_dto.dart';

/// Registration Repository Implementation
class RegistrationRepositoryImpl implements RegistrationRepository {
  final RegistrationRemoteDataSource remoteDataSource;

  RegistrationRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<Map<String, dynamic>> registerStep1(RegisterStep1Dto dto) async {
    return await remoteDataSource.registerStep1(dto);
  }

  @override
  Future<Map<String, dynamic>> registerStep2(String driverId, RegisterStep2Dto dto) async {
    return await remoteDataSource.registerStep2(driverId, dto);
  }

  @override
  Future<Map<String, dynamic>> registerStep3(String driverId, RegisterStep3Dto dto) async {
    return await remoteDataSource.registerStep3(driverId, dto);
  }

  @override
  Future<DriverEntity> trackApplication(String driverId) async {
    return await remoteDataSource.trackApplication(driverId);
  }
}
