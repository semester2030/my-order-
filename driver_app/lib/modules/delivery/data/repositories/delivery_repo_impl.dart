import '../../domain/repositories/delivery_repo.dart';
import '../../data/models/delivery_details_dto.dart';
import '../../data/models/update_location_dto.dart';
import '../../data/models/update_delivery_status_dto.dart';
import '../datasources/delivery_remote_ds.dart';

/// Delivery Repository Implementation
class DeliveryRepositoryImpl implements DeliveryRepository {
  final DeliveryRemoteDataSource remoteDataSource;

  DeliveryRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<DeliveryDetailsDto> getDeliveryDetails(String orderId) async {
    return await remoteDataSource.getDeliveryDetails(orderId);
  }

  @override
  Future<Map<String, dynamic>> updateLocation(String orderId, UpdateLocationDto dto) async {
    return await remoteDataSource.updateLocation(orderId, dto);
  }

  @override
  Future<Map<String, dynamic>> updateDeliveryStatus(
    String orderId,
    UpdateDeliveryStatusDto dto,
  ) async {
    return await remoteDataSource.updateDeliveryStatus(orderId, dto);
  }
}
