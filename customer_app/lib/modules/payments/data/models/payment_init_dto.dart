import 'package:json_annotation/json_annotation.dart';

part 'payment_init_dto.g.dart';

@JsonSerializable()
class PaymentInitDto {
  final String orderId;
  final String method; // 'apple_pay', 'mada', 'stc_pay'

  PaymentInitDto({
    required this.orderId,
    required this.method,
  });

  factory PaymentInitDto.fromJson(Map<String, dynamic> json) =>
      _$PaymentInitDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentInitDtoToJson(this);
}
