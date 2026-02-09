import '../../domain/entities/delivery_assignment.dart' as domain;
import '../../domain/entities/delivery_status.dart' as domain_status;
import '../../domain/entities/delivery_contact.dart';
import '../models/delivery_details_dto.dart' as data;

/// Delivery Mapper
/// 
/// Maps between DTOs (Data Layer) and Entities (Domain Layer)
class DeliveryMapper {
  /// Map DeliveryDetailsDto to DeliveryAssignment entity
  static domain.DeliveryAssignment toDeliveryAssignment(data.DeliveryDetailsDto dto) {
    // Map status string to domain status string (DeliveryAssignment expects String, not enum)
    final statusString = _mapStatus(dto.status);
    
    return domain.DeliveryAssignment(
      orderId: dto.orderId,
      orderNumber: dto.orderNumber,
      status: statusString,
      total: dto.total,
      deliveryFee: dto.deliveryFee,
      vendor: DeliveryContact(
        id: dto.vendor.id,
        name: dto.vendor.name,
        phone: dto.vendor.phoneNumber ?? '',
        address: dto.vendor.address,
      ),
      customer: DeliveryContact(
        id: dto.customer.id,
        name: dto.customer.name,
        phone: dto.customer.phone,
        address: null,
      ),
      deliveryAddress: domain.DeliveryAddress(
        streetAddress: dto.deliveryAddress.streetAddress,
        city: dto.deliveryAddress.city,
        district: dto.deliveryAddress.district,
        latitude: dto.deliveryAddress.latitude,
        longitude: dto.deliveryAddress.longitude,
      ),
      estimatedDeliveryTime: dto.estimatedDeliveryTime,
      createdAt: dto.createdAt,
    );
  }

  /// Map status string to DeliveryStatus (returns string, not enum)
  static String _mapStatus(String status) {
    // Validate and return status
    if (domain_status.DeliveryStatus.isValid(status)) {
      return status;
    }
    // Default to pending if invalid
    return domain_status.DeliveryStatus.pending;
  }
}
