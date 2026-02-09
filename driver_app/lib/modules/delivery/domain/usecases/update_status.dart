import '../repositories/delivery_repo.dart';
import '../../data/models/update_delivery_status_dto.dart';

/// Update Status Use Case
/// 
/// Handles updating delivery status:
/// - Validates order ID and status
/// - Calls repository to update status
/// - Returns update result
class UpdateStatusUseCase {
  final DeliveryRepository repository;

  UpdateStatusUseCase(this.repository);

  /// Execute update status
  /// 
  /// [orderId] - Order ID
  /// [dto] - Status update data
  Future<Map<String, dynamic>> call(String orderId, UpdateDeliveryStatusDto dto) async {
    if (orderId.isEmpty) {
      throw ArgumentError('Order ID is required');
    }
    if (dto.status.isEmpty) {
      throw ArgumentError('Status is required');
    }
    
    // Validate status values
    final validStatuses = ['picked_up', 'on_the_way', 'delivered', 'cancelled'];
    if (!validStatuses.contains(dto.status)) {
      throw ArgumentError('Invalid status: ${dto.status}');
    }
    
    return await repository.updateDeliveryStatus(orderId, dto);
  }
}
