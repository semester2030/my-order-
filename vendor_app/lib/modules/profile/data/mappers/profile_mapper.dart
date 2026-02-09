import '../../domain/entities/vendor_profile.dart';
import '../models/vendor_profile_dto.dart';

/// Maps profile DTO to domain entity and back (Phase 6: updateProfile).
class ProfileMapper {
  ProfileMapper._();

  static VendorProfile toEntity(VendorProfileDto dto) {
    return VendorProfile(
      id: dto.id,
      name: dto.name,
      tradeName: dto.tradeName,
      email: dto.email,
      phoneNumber: dto.phoneNumber,
      description: dto.description,
      address: dto.address,
      city: dto.city,
      providerCategory: dto.providerCategory,
      popularCookingAddOns: dto.popularCookingAddOns,
      isActive: dto.isActive,
      isAcceptingOrders: dto.isAcceptingOrders,
      registrationStatus: dto.registrationStatus,
      rejectionReason: dto.rejectionReason,
    );
  }

  static VendorProfileDto toDto(VendorProfile entity) {
    return VendorProfileDto(
      id: entity.id,
      name: entity.name,
      tradeName: entity.tradeName,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      description: entity.description,
      address: entity.address,
      city: entity.city,
      providerCategory: entity.providerCategory,
      popularCookingAddOns: entity.popularCookingAddOns,
      isActive: entity.isActive,
      isAcceptingOrders: entity.isAcceptingOrders,
      registrationStatus: entity.registrationStatus,
      rejectionReason: entity.rejectionReason,
    );
  }
}
