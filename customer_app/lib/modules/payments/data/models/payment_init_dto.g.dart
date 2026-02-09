// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_init_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentInitDto _$PaymentInitDtoFromJson(Map<String, dynamic> json) =>
    PaymentInitDto(
      orderId: json['orderId'] as String,
      method: json['method'] as String,
    );

Map<String, dynamic> _$PaymentInitDtoToJson(PaymentInitDto instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'method': instance.method,
    };
