// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_confirm_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentConfirmDto _$PaymentConfirmDtoFromJson(Map<String, dynamic> json) =>
    PaymentConfirmDto(
      paymentId: json['paymentId'] as String,
      transactionId: json['transactionId'] as String,
    );

Map<String, dynamic> _$PaymentConfirmDtoToJson(PaymentConfirmDto instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'transactionId': instance.transactionId,
    };
