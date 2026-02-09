/// DTO لعنصر طلب — Phase 8 (متوافق مع API_CONTRACT).
class OrderItemDto {
  const OrderItemDto({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    this.addOns = const [],
  });

  final String id;
  final String name;
  final int quantity;
  final double unitPrice;
  final List<String> addOns;

  factory OrderItemDto.fromJson(Map<String, dynamic> json) {
    final addOnsRaw = json['addOns'];
    List<String> addOnsList = const [];
    if (addOnsRaw is List) {
      addOnsList = addOnsRaw.map((e) => e.toString()).toList();
    }
    return OrderItemDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      quantity: _toInt(json['quantity']),
      unitPrice: _toDouble(json['unitPrice']),
      addOns: addOnsList,
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'addOns': addOns,
    };
  }
}
