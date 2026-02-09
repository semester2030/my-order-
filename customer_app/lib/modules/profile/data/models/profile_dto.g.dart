// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileDto _$ProfileDtoFromJson(Map<String, dynamic> json) => ProfileDto(
      id: ProfileDto._stringFromJson(json['id']),
      phone: ProfileDto._phoneFromJson(json['phone']),
      name: json['name'] as String?,
      email: json['email'] as String?,
      isVerified: ProfileDto._boolFromJson(json['is_verified']),
      createdAt: ProfileDto._stringFromJson(json['created_at']),
    );

Map<String, dynamic> _$ProfileDtoToJson(ProfileDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phone': instance.phone,
      'name': instance.name,
      'email': instance.email,
      'is_verified': instance.isVerified,
      'created_at': instance.createdAt,
    };
