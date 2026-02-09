import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/driver_profile_repo.dart';
import '../../data/repositories/driver_profile_repo_impl.dart';
import '../../data/datasources/driver_profile_remote_ds.dart';
import '../../../../core/di/providers.dart';
import '../../data/models/update_availability_dto.dart';
import 'driver_profile_state.dart';

/// Driver Profile Repository Provider
final driverProfileRepositoryProvider = Provider<DriverProfileRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = DriverProfileRemoteDataSourceImpl(apiClient: apiClient);
  return DriverProfileRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Driver Profile Notifier Provider
final driverProfileNotifierProvider =
    StateNotifierProvider<DriverProfileNotifier, DriverProfileState>((ref) {
  final repository = ref.watch(driverProfileRepositoryProvider);
  return DriverProfileNotifier(repository);
});

/// Driver Availability Notifier Provider
final driverAvailabilityNotifierProvider =
    StateNotifierProvider<DriverAvailabilityNotifier, DriverAvailabilityState>((ref) {
  final repository = ref.watch(driverProfileRepositoryProvider);
  return DriverAvailabilityNotifier(repository);
});

/// Driver Profile Notifier
class DriverProfileNotifier extends StateNotifier<DriverProfileState> {
  final DriverProfileRepository repository;

  DriverProfileNotifier(this.repository) : super(const DriverProfileInitial());

  Future<void> getProfile() async {
    state = const DriverProfileLoading();
    try {
      final profile = await repository.getProfile();
      state = DriverProfileLoaded(profile);
    } catch (e) {
      state = DriverProfileError(e.toString());
    }
  }
}

/// Driver Availability Notifier
class DriverAvailabilityNotifier extends StateNotifier<DriverAvailabilityState> {
  final DriverProfileRepository repository;

  DriverAvailabilityNotifier(this.repository) : super(const DriverAvailabilityInitial());

  Future<void> updateAvailability(bool isOnline) async {
    state = const DriverAvailabilityUpdating();
    try {
      final dto = UpdateAvailabilityDto(isOnline: isOnline);
      await repository.updateAvailability(dto);
      state = DriverAvailabilityUpdated(isOnline);
    } catch (e) {
      state = DriverAvailabilityError(e.toString());
    }
  }
}
