import 'package:equatable/equatable.dart';

/// Domain entity: vendor profile (أساس — Phase 5).
class VendorProfile with EquatableMixin {
    const VendorProfile({
    required this.id,
    required this.name,
    this.tradeName,
    this.email,
    this.phoneNumber,
    this.description,
    this.address,
    this.city,
    this.providerCategory,
    this.popularCookingAddOns,
    this.isActive = true,
    this.isAcceptingOrders = true,
    this.registrationStatus,
    this.rejectionReason,
  });

  final String id;
  final String name;
  final String? tradeName;
  final String? email;
  final String? phoneNumber;
  final String? description;
  final String? address;
  final String? city;
  /// home_cooking | popular_cooking | private_events | grilling
  final String? providerCategory;
  /// JSON array of {name, price} for popular_cooking add-ons (Phase 12).
  final String? popularCookingAddOns;
  final bool isActive;
  final bool isAcceptingOrders;
  /// pending | approved | rejected — من الباك اند (Phase 7).
  final String? registrationStatus;
  /// سبب الرفض من الباك اند إن وُجد (Phase 17).
  final String? rejectionReason;

  @override
  List<Object?> get props => [
        id,
        name,
        tradeName,
        email,
        phoneNumber,
        description,
        address,
        city,
        providerCategory,
        popularCookingAddOns,
        isActive,
        isAcceptingOrders,
        registrationStatus,
        rejectionReason,
      ];
}
