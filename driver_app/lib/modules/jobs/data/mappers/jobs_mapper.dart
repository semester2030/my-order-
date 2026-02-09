import '../../domain/entities/active_job.dart';
import '../models/active_job_dto.dart';
import '../models/job_offer_dto.dart';

/// Jobs Mapper
/// 
/// Maps between DTOs (Data Layer) and Entities (Domain Layer)
class JobsMapper {
  /// Map ActiveJobDto to ActiveJob entity
  static ActiveJob toActiveJobEntity(ActiveJobDto dto) {
    return ActiveJob(
      id: dto.id,
      orderId: dto.orderId,
      orderNumber: dto.orderNumber,
      orderStatus: dto.orderStatus,
      deliveryFee: dto.deliveryFee,
      driverEarnings: dto.driverEarnings,
      estimatedDistance: dto.estimatedDistance,
      estimatedDuration: dto.estimatedDuration,
      pickupLocation: JobLocation(
        latitude: dto.pickupLocation.latitude,
        longitude: dto.pickupLocation.longitude,
        address: null, // Location model doesn't have address field
      ),
      deliveryLocation: JobLocation(
        latitude: dto.deliveryLocation.latitude,
        longitude: dto.deliveryLocation.longitude,
        address: null, // Location model doesn't have address field
      ),
      acceptedAt: dto.acceptedAt,
    );
  }

  /// Map JobOfferDto to ActiveJob entity (when accepted)
  static ActiveJob? toActiveJobFromOffer(JobOfferDto? offer) {
    if (offer == null) return null;
    
    // Note: JobOfferDto doesn't have all fields needed for ActiveJob
    // This is a placeholder - actual mapping would need more data
    return ActiveJob(
      id: offer.id,
      orderId: offer.orderId,
      orderNumber: offer.orderNumber,
      orderStatus: 'accepted',
      deliveryFee: offer.deliveryFee,
      driverEarnings: offer.driverEarnings,
      estimatedDistance: offer.estimatedDistance,
      estimatedDuration: offer.estimatedDuration,
      pickupLocation: JobLocation(
        latitude: offer.pickupLocation.latitude,
        longitude: offer.pickupLocation.longitude,
        address: null, // Location model doesn't have address field
      ),
      deliveryLocation: JobLocation(
        latitude: offer.deliveryLocation.latitude,
        longitude: offer.deliveryLocation.longitude,
        address: null, // Location model doesn't have address field
      ),
      acceptedAt: DateTime.now(),
    );
  }
}
