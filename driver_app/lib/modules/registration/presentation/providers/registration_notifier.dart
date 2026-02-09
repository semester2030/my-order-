import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/registration_repo.dart';
import '../../data/repositories/registration_repo_impl.dart';
import '../../data/datasources/registration_remote_ds.dart';
import '../../../../core/di/providers.dart';
import '../../data/models/register_step1_dto.dart';
import '../../data/models/register_step2_dto.dart';
import '../../data/models/register_step3_dto.dart';
import 'registration_state.dart';

/// Registration Repository Provider
final registrationRepositoryProvider = Provider<RegistrationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = RegistrationRemoteDataSourceImpl(apiClient: apiClient);
  return RegistrationRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Registration Notifier Provider
final registrationNotifierProvider =
    StateNotifierProvider<RegistrationNotifier, RegistrationState>((ref) {
  final repository = ref.watch(registrationRepositoryProvider);
  return RegistrationNotifier(repository);
});

/// Registration Notifier
class RegistrationNotifier extends StateNotifier<RegistrationState> {
  final RegistrationRepository repository;

  RegistrationNotifier(this.repository) : super(const RegistrationInitial());

  Future<void> registerStep1(RegisterStep1Dto dto) async {
    state = const RegistrationLoading();
    try {
      final response = await repository.registerStep1(dto);
      state = RegistrationStep1Success(
        driverId: response['driverId'] as String,
        userId: response['userId'] as String,
        status: response['status'] as String,
      );
    } catch (e) {
      state = RegistrationError(e.toString());
    }
  }

  Future<void> registerStep2(String driverId, RegisterStep2Dto dto) async {
    state = const RegistrationLoading();
    try {
      final response = await repository.registerStep2(driverId, dto);
      state = RegistrationStep2Success(
        driverId: response['driverId'] as String,
        status: response['status'] as String,
      );
    } catch (e) {
      state = RegistrationError(e.toString());
    }
  }

  Future<void> registerStep3(String driverId, RegisterStep3Dto dto) async {
    state = const RegistrationLoading();
    try {
      final response = await repository.registerStep3(driverId, dto);
      state = RegistrationStep3Success(
        driverId: response['driverId'] as String,
        status: response['status'] as String,
      );
    } catch (e) {
      state = RegistrationError(e.toString());
    }
  }

  Future<void> trackApplication(String driverId) async {
    state = const RegistrationLoading();
    try {
      final driver = await repository.trackApplication(driverId);
      state = RegistrationTrackSuccess(driver);
    } catch (e) {
      state = RegistrationError(e.toString());
    }
  }
}
