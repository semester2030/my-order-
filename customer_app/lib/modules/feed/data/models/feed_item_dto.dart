import 'package:json_annotation/json_annotation.dart';

part 'feed_item_dto.g.dart';

@JsonSerializable()
class VendorDto {
  final String id;
  final String name;
  final String? logo;
  @JsonKey(fromJson: _doubleFromJson)
  final double rating;
  final int ratingCount;
  final String type;
  @JsonKey(name: 'acceptsCustomRequests', defaultValue: true)
  final bool acceptsCustomRequests;
  @JsonKey(name: 'providerCategory')
  final String? providerCategory;

  VendorDto({
    required this.id,
    required this.name,
    this.logo,
    required this.rating,
    required this.ratingCount,
    required this.type,
    this.acceptsCustomRequests = true,
    this.providerCategory,
  });

  factory VendorDto.fromJson(Map<String, dynamic> json) =>
      _$VendorDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VendorDtoToJson(this);

  static double _doubleFromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.parse(value);
    return 0.0;
  }
}

@JsonSerializable()
class VideoDto {
  final String id;
  final String playbackUrl;
  final String? thumbnailUrl;
  final int duration;

  VideoDto({
    required this.id,
    required this.playbackUrl,
    this.thumbnailUrl,
    required this.duration,
  });

  factory VideoDto.fromJson(Map<String, dynamic> json) =>
      _$VideoDtoFromJson(json);

  Map<String, dynamic> toJson() => _$VideoDtoToJson(this);
}

@JsonSerializable()
class FeedItemDto {
  final String id;
  final String name;
  final String? description;
  @JsonKey(fromJson: _doubleFromJson)
  final double price;
  final String? image;
  @JsonKey(fromJson: _boolFromJson)
  final bool isSignature;
  final VendorDto vendor;
  final VideoDto? video;
  final double? distance;

  FeedItemDto({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.image,
    required this.isSignature,
    required this.vendor,
    this.video,
    this.distance,
  });

  factory FeedItemDto.fromJson(Map<String, dynamic> json) =>
      _$FeedItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FeedItemDtoToJson(this);

  static double _doubleFromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      try {
        return double.parse(value);
      } catch (e) {
        return 0.0;
      }
    }
    return 0.0;
  }

  static bool _boolFromJson(dynamic value) {
    if (value is bool) return value;
    if (value == null) return false;
    if (value is int) return value != 0;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    return false;
  }
}
