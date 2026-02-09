import '../../data/models/delivery_details_dto.dart';
import '../../data/models/update_location_dto.dart';
import '../../data/models/update_delivery_status_dto.dart';

/// Delivery Repository
abstract class DeliveryRepository {
  Future<DeliveryDetailsDto> getDeliveryDetails(String orderId);
  Future<Map<String, dynamic>> updateLocation(String orderId, UpdateLocationDto dto);
  Future<Map<String, dynamic>> updateDeliveryStatus(
    String orderId,
    UpdateDeliveryStatusDto dto,
  );
}
