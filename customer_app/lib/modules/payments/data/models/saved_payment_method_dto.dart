class CreateSavedPaymentMethodPayload {
  final String holderName;
  final String last4;
  final int expMonth;
  final int expYear;

  const CreateSavedPaymentMethodPayload({
    required this.holderName,
    required this.last4,
    required this.expMonth,
    required this.expYear,
  });

  Map<String, dynamic> toJson() => {
        'holderName': holderName,
        'last4': last4,
        'expMonth': expMonth,
        'expYear': expYear,
      };
}

class SavedPaymentMethodDto {
  final String id;
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;
  final String holderName;
  final String? createdAt;

  const SavedPaymentMethodDto({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    required this.holderName,
    this.createdAt,
  });

  factory SavedPaymentMethodDto.fromJson(Map<String, dynamic> json) {
    return SavedPaymentMethodDto(
      id: json['id'] as String,
      brand: json['brand'] as String? ?? 'mada',
      last4: json['last4'] as String,
      expMonth: (json['expMonth'] as num).toInt(),
      expYear: (json['expYear'] as num).toInt(),
      holderName: json['holderName'] as String,
      createdAt: json['createdAt'] as String?,
    );
  }
}
