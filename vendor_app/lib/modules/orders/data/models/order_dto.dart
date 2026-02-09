import 'order_item_dto.dart';

/// DTO للطلب — Phase 8 (متوافق مع API_CONTRACT).
class OrderDto {
  const OrderDto({
    required this.id,
    required this.customerName,
    this.customerPhone,
    required this.status,
    required this.totalAmount,
    required this.createdAt,
    this.items = const [],
    this.notes,
  });

  final String id;
  final String customerName;
  final String? customerPhone;
  final String status;
  final double totalAmount;
  final String createdAt;
  final List<OrderItemDto> items;
  final String? notes;

  factory OrderDto.fromJson(Map<String, dynamic> json) {
    final itemsRaw = json['items'];
    List<OrderItemDto> itemsList = const [];
    if (itemsRaw is List) {
      itemsList = itemsRaw
          .map((e) => OrderItemDto.fromJson(e is Map<String, dynamic> ? e : <String, dynamic>{}))
          .toList();
    }
    return OrderDto(
      id: json['id'] as String? ?? '',
      customerName: json['customerName'] as String? ?? '',
      customerPhone: json['customerPhone'] as String?,
      status: json['status'] as String? ?? 'pending',
      totalAmount: _toDouble(json['totalAmount']),
      createdAt: _toString(json['createdAt']),
      items: itemsList,
      notes: json['notes'] as String?,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static String _toString(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is DateTime) return value.toIso8601String();
    return value.toString();
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'status': status,
      'totalAmount': totalAmount,
      'createdAt': createdAt,
      'items': items.map((e) => e.toJson()).toList(),
      'notes': notes,
    };
  }
}
