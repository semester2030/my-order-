// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_item_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorDto _$VendorDtoFromJson(Map<String, dynamic> json) => VendorDto(
      id: json['id'] as String,
      name: json['name'] as String,
      logo: json['logo'] as String?,
      rating: VendorDto._doubleFromJson(json['rating']),
      ratingCount: (json['ratingCount'] as num).toInt(),
      type: json['type'] as String,
      acceptsCustomRequests: json['acceptsCustomRequests'] as bool? ?? true,
      providerCategory: json['providerCategory'] as String?,
    );

Map<String, dynamic> _$VendorDtoToJson(VendorDto instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'logo': instance.logo,
      'rating': instance.rating,
      'ratingCount': instance.ratingCount,
      'type': instance.type,
      'acceptsCustomRequests': instance.acceptsCustomRequests,
      'providerCategory': instance.providerCategory,
    };

VideoDto _$VideoDtoFromJson(Map<String, dynamic> json) => VideoDto(
      id: json['id'] as String,
      playbackUrl: json['playbackUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      duration: (json['duration'] as num).toInt(),
    );

Map<String, dynamic> _$VideoDtoToJson(VideoDto instance) => <String, dynamic>{
      'id': instance.id,
      'playbackUrl': instance.playbackUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'duration': instance.duration,
    };

FeedItemDto _$FeedItemDtoFromJson(Map<String, dynamic> json) => FeedItemDto(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      price: FeedItemDto._doubleFromJson(json['price']),
      image: json['image'] as String?,
      isSignature: FeedItemDto._boolFromJson(json['isSignature']),
      vendor: VendorDto.fromJson(json['vendor'] as Map<String, dynamic>),
      video: json['video'] == null
          ? null
          : VideoDto.fromJson(json['video'] as Map<String, dynamic>),
      distance: (json['distance'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$FeedItemDtoToJson(FeedItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'image': instance.image,
      'isSignature': instance.isSignature,
      'vendor': instance.vendor,
      'video': instance.video,
      'distance': instance.distance,
    };
