/// Response DTO for GET /vendors/profile (Phase 5–7).
class VendorProfileDto {
  const VendorProfileDto({
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
  final String? providerCategory;
  final String? popularCookingAddOns;
  final bool isActive;
  final bool isAcceptingOrders;
  /// pending | approved | rejected (Phase 7).
  final String? registrationStatus;
  /// سبب الرفض من الباك اند (Phase 17).
  final String? rejectionReason;

  factory VendorProfileDto.fromJson(Map<String, dynamic> json) {
    return VendorProfileDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      tradeName: json['tradeName'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      description: json['description'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      providerCategory: json['providerCategory'] as String?,
      popularCookingAddOns: json['popularCookingAddOns'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      isAcceptingOrders: json['isAcceptingOrders'] as bool? ?? true,
      registrationStatus: json['registrationStatus'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tradeName': tradeName,
      'email': email,
      'phoneNumber': phoneNumber,
      'description': description,
      'address': address,
      'city': city,
      'providerCategory': providerCategory,
      'popularCookingAddOns': popularCookingAddOns,
      'isActive': isActive,
      'isAcceptingOrders': isAcceptingOrders,
      'registrationStatus': registrationStatus,
      'rejectionReason': rejectionReason,
    };
  }
}
