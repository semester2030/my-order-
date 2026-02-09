// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'otp_verify_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OtpVerifyDto _$OtpVerifyDtoFromJson(Map<String, dynamic> json) => OtpVerifyDto(
      identifier: json['identifier'] as String,
      code: json['code'] as String,
    );

Map<String, dynamic> _$OtpVerifyDtoToJson(OtpVerifyDto instance) =>
    <String, dynamic>{
      'identifier': instance.identifier,
      'code': instance.code,
    };
