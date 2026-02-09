import '../repositories/delivery_repo.dart';
import '../../data/models/delivery_details_dto.dart';

/// Get Assignment Details Use Case
/// 
/// Handles fetching delivery assignment details:
/// - Validates order ID
/// - Calls repository to get delivery details
/// - Returns delivery details
class GetAssignmentDetailsUseCase {
  final DeliveryRepository repository;

  GetAssignmentDetailsUseCase(this.repository);

  /// Execute get assignment details
  /// 
  /// [orderId] - Order ID
  Future<DeliveryDetailsDto> call(String orderId) async {
    if (orderId.isEmpty) {
      throw ArgumentError('Order ID is required');
    }
    return await repository.getDeliveryDetails(orderId);
  }
}
