class SavedPaymentMethod {
  final String id;
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;
  final String holderName;
  final DateTime? createdAt;

  const SavedPaymentMethod({
    required this.id,
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
    required this.holderName,
    this.createdAt,
  });

  String get maskedLine => '•••• $last4';
}
