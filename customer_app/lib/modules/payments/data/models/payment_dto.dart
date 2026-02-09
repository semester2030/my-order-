import 'package:json_annotation/json_annotation.dart';

part 'payment_dto.g.dart';

@JsonSerializable()
class PaymentDto {
  final String id;
  @JsonKey(name: 'order_id')
  final String orderId;
  final String method;
  final String status;
  final double amount;
  @JsonKey(name: 'transaction_id')
  final String? transactionId;
  @JsonKey(name: 'gateway_response')
  final String? gatewayResponse;
  @JsonKey(name: 'failure_reason')
  final String? failureReason;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'updated_at')
  final String updatedAt;

  PaymentDto({
    required this.id,
    required this.orderId,
    required this.method,
    required this.status,
    required this.amount,
    this.transactionId,
    this.gatewayResponse,
    this.failureReason,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PaymentDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentDtoToJson(this);
}
