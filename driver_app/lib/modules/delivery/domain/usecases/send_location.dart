import '../repositories/delivery_repo.dart';
import '../../data/models/update_location_dto.dart';

/// Send Location Use Case
/// 
/// Handles sending driver location update:
/// - Validates order ID and location
/// - Calls repository to update location
/// - Returns update result
class SendLocationUseCase {
  final DeliveryRepository repository;

  SendLocationUseCase(this.repository);

  /// Execute send location
  /// 
  /// [orderId] - Order ID
  /// [dto] - Location update data
  Future<Map<String, dynamic>> call(String orderId, UpdateLocationDto dto) async {
    if (orderId.isEmpty) {
      throw ArgumentError('Order ID is required');
    }
    if (dto.latitude < -90 || dto.latitude > 90) {
      throw ArgumentError('Invalid latitude');
    }
    if (dto.longitude < -180 || dto.longitude > 180) {
      throw ArgumentError('Invalid longitude');
    }
    return await repository.updateLocation(orderId, dto);
  }
}
