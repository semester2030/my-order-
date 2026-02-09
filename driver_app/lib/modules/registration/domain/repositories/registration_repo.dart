import '../entities/driver_entity.dart';
import '../../data/models/register_step1_dto.dart';
import '../../data/models/register_step2_dto.dart';
import '../../data/models/register_step3_dto.dart';

/// Registration Repository
abstract class RegistrationRepository {
  Future<Map<String, dynamic>> registerStep1(RegisterStep1Dto dto);
  Future<Map<String, dynamic>> registerStep2(String driverId, RegisterStep2Dto dto);
  Future<Map<String, dynamic>> registerStep3(String driverId, RegisterStep3Dto dto);
  Future<DriverEntity> trackApplication(String driverId);
}
