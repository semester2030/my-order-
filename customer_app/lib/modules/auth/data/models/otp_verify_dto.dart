import 'package:json_annotation/json_annotation.dart';

part 'otp_verify_dto.g.dart';

@JsonSerializable()
class OtpVerifyDto {
  final String identifier;
  final String code;

  OtpVerifyDto({required this.identifier, required this.code});

  factory OtpVerifyDto.fromJson(Map<String, dynamic> json) =>
      _$OtpVerifyDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OtpVerifyDtoToJson(this);
}
