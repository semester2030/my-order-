import 'dart:convert';

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
    this.bankName,
    this.bankAccountNumber,
    this.iban,
    this.accountHolderName,
    this.swiftCode,
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
  final String? bankName;
  final String? bankAccountNumber;
  final String? iban;
  final String? accountHolderName;
  final String? swiftCode;

  factory VendorProfileDto.fromJson(Map<String, dynamic> json) {
    final pca = json['popularCookingAddOns'];
    String? popularStr;
    if (pca is String) {
      popularStr = pca;
    } else if (pca is List) {
      popularStr = jsonEncode(pca);
    }

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
      popularCookingAddOns: popularStr,
      isActive: json['isActive'] as bool? ?? true,
      isAcceptingOrders: json['isAcceptingOrders'] as bool? ?? true,
      registrationStatus: json['registrationStatus'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      bankName: json['bankName'] as String?,
      bankAccountNumber: json['bankAccountNumber'] as String?,
      iban: json['iban'] as String?,
      accountHolderName: json['accountHolderName'] as String?,
      swiftCode: json['swiftCode'] as String?,
    );
  }

  /// جسم PUT `/vendors/profile` — بدون حقول غير مصرّح بها (forbidNonWhitelisted).
  Map<String, dynamic> toGeneralProfileUpdatePayload() {
    dynamic popularPayload;
    final raw = popularCookingAddOns;
    if (raw != null && raw.trim().isNotEmpty) {
      try {
        popularPayload = jsonDecode(raw);
      } catch (_) {
        popularPayload = raw;
      }
    }

    return <String, dynamic>{
      'name': name,
      'tradeName': tradeName,
      'email': email,
      'phoneNumber': phoneNumber,
      'description': description,
      'address': address,
      'city': city,
      'isActive': isActive,
      'isAcceptingOrders': isAcceptingOrders,
      if (popularPayload != null) 'popularCookingAddOns': popularPayload,
    };
  }

  /// تحديث حقول التحويل البنكي فقط (لا يُرسل باقي الحقول).
  Map<String, dynamic> toBankingUpdatePayload() {
    return <String, dynamic>{
      'bankName': bankName,
      'bankAccountNumber': bankAccountNumber,
      'iban': iban,
      'accountHolderName': accountHolderName,
      'swiftCode': swiftCode,
    };
  }
}
