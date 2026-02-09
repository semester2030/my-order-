import 'package:json_annotation/json_annotation.dart';

part 'payment_confirm_dto.g.dart';

@JsonSerializable()
class PaymentConfirmDto {
  final String paymentId;
  final String transactionId;

  PaymentConfirmDto({
    required this.paymentId,
    required this.transactionId,
  });

  factory PaymentConfirmDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentConfirmDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentConfirmDtoToJson(this);
}
