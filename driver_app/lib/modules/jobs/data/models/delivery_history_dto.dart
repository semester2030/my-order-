import '../../../../shared/utils/json_parse.dart';

/// Single delivery in driver's history
class DeliveryHistoryItemDto {
  final String id;
  final String orderId;
  final String orderNumber;
  final String orderStatus;
  final DateTime? deliveredAt;
  final double driverEarnings;
  final String vendorName;
  final DateTime? acceptedAt;

  DeliveryHistoryItemDto({
    required this.id,
    required this.orderId,
    required this.orderNumber,
    required this.orderStatus,
    this.deliveredAt,
    required this.driverEarnings,
    required this.vendorName,
    this.acceptedAt,
  });

  factory DeliveryHistoryItemDto.fromJson(Map<String, dynamic> json) {
    return DeliveryHistoryItemDto(
      id: safeString(json['id']),
      orderId: safeString(json['orderId']),
      orderNumber: safeString(json['orderNumber']),
      orderStatus: safeString(json['orderStatus']),
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.tryParse(json['deliveredAt'].toString())
          : null,
      driverEarnings: safeDouble(json['driverEarnings']),
      vendorName: safeString(json['vendorName']),
      acceptedAt: json['acceptedAt'] != null
          ? DateTime.tryParse(json['acceptedAt'].toString())
          : null,
    );
  }

  bool get isDelivered => orderStatus == 'delivered';
  bool get isCancelled => orderStatus == 'cancelled';
}

/// Response from GET /jobs/history
class DeliveryHistoryDto {
  final double totalEarnings;
  final List<DeliveryHistoryItemDto> deliveries;

  DeliveryHistoryDto({
    required this.totalEarnings,
    required this.deliveries,
  });

  factory DeliveryHistoryDto.fromJson(Map<String, dynamic> json) {
    final list = json['deliveries'];
    final total = json['totalEarnings'];
    return DeliveryHistoryDto(
      totalEarnings: total is num ? total.toDouble() : 0.0,
      deliveries: list is List
          ? list
              .map((e) => DeliveryHistoryItemDto.fromJson(
                  e is Map<String, dynamic> ? e : <String, dynamic>{}))
              .toList()
          : [],
    );
  }
}
