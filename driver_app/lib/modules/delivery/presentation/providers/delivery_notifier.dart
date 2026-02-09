import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/delivery_repo.dart';
import '../../data/repositories/delivery_repo_impl.dart';
import '../../data/datasources/delivery_remote_ds.dart';
import '../../../../core/di/providers.dart';
import '../../data/models/update_location_dto.dart';
import '../../data/models/update_delivery_status_dto.dart';
import 'delivery_state.dart';

/// Delivery Repository Provider
final deliveryRepositoryProvider = Provider<DeliveryRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = DeliveryRemoteDataSourceImpl(apiClient: apiClient);
  return DeliveryRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Delivery Details Notifier Provider
final deliveryDetailsNotifierProvider =
    StateNotifierProvider<DeliveryDetailsNotifier, DeliveryDetailsState>((ref) {
  final repository = ref.watch(deliveryRepositoryProvider);
  return DeliveryDetailsNotifier(repository);
});

/// Update Location Notifier Provider
final updateLocationNotifierProvider =
    StateNotifierProvider<UpdateLocationNotifier, UpdateLocationState>((ref) {
  final repository = ref.watch(deliveryRepositoryProvider);
  return UpdateLocationNotifier(repository);
});

/// Update Delivery Status Notifier Provider
final updateDeliveryStatusNotifierProvider =
    StateNotifierProvider<UpdateDeliveryStatusNotifier, UpdateDeliveryStatusState>((ref) {
  final repository = ref.watch(deliveryRepositoryProvider);
  return UpdateDeliveryStatusNotifier(repository);
});

/// Delivery Details Notifier
class DeliveryDetailsNotifier extends StateNotifier<DeliveryDetailsState> {
  final DeliveryRepository repository;

  DeliveryDetailsNotifier(this.repository) : super(const DeliveryDetailsInitial());

  Future<void> getDeliveryDetails(String orderId) async {
    state = const DeliveryDetailsLoading();
    try {
      final details = await repository.getDeliveryDetails(orderId);
      state = DeliveryDetailsLoaded(details);
    } catch (e) {
      state = DeliveryDetailsError(e.toString());
    }
  }
}

/// Update Location Notifier
class UpdateLocationNotifier extends StateNotifier<UpdateLocationState> {
  final DeliveryRepository repository;

  UpdateLocationNotifier(this.repository) : super(const UpdateLocationInitial());

  Future<void> updateLocation(String orderId, double latitude, double longitude) async {
    state = const UpdateLocationUpdating();
    try {
      final dto = UpdateLocationDto(latitude: latitude, longitude: longitude);
      await repository.updateLocation(orderId, dto);
      state = UpdateLocationSuccess(latitude: latitude, longitude: longitude);
    } catch (e) {
      state = UpdateLocationError(e.toString());
    }
  }
}

/// Update Delivery Status Notifier
class UpdateDeliveryStatusNotifier extends StateNotifier<UpdateDeliveryStatusState> {
  final DeliveryRepository repository;

  UpdateDeliveryStatusNotifier(this.repository) : super(const UpdateDeliveryStatusInitial());

  Future<void> updateDeliveryStatus(String orderId, String status) async {
    state = const UpdateDeliveryStatusUpdating();
    try {
      final dto = UpdateDeliveryStatusDto(status: status);
      await repository.updateDeliveryStatus(orderId, dto);
      state = UpdateDeliveryStatusSuccess(status);
    } catch (e) {
      state = UpdateDeliveryStatusError(e.toString());
    }
  }
}
