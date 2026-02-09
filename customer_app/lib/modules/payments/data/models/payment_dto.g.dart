// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentDto _$PaymentDtoFromJson(Map<String, dynamic> json) => PaymentDto(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      method: json['method'] as String,
      status: json['status'] as String,
      amount: (json['amount'] as num).toDouble(),
      transactionId: json['transaction_id'] as String?,
      gatewayResponse: json['gateway_response'] as String?,
      failureReason: json['failure_reason'] as String?,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );

Map<String, dynamic> _$PaymentDtoToJson(PaymentDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'method': instance.method,
      'status': instance.status,
      'amount': instance.amount,
      'transaction_id': instance.transactionId,
      'gateway_response': instance.gatewayResponse,
      'failure_reason': instance.failureReason,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
