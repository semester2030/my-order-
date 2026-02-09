// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feed_page_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaginationDto _$PaginationDtoFromJson(Map<String, dynamic> json) =>
    PaginationDto(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      totalPages: (json['totalPages'] as num).toInt(),
      hasMore: json['hasMore'] as bool,
    );

Map<String, dynamic> _$PaginationDtoToJson(PaginationDto instance) =>
    <String, dynamic>{
      'page': instance.page,
      'limit': instance.limit,
      'total': instance.total,
      'totalPages': instance.totalPages,
      'hasMore': instance.hasMore,
    };

FeedPageDto _$FeedPageDtoFromJson(Map<String, dynamic> json) => FeedPageDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => FeedItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination:
          PaginationDto.fromJson(json['pagination'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$FeedPageDtoToJson(FeedPageDto instance) =>
    <String, dynamic>{
      'items': instance.items,
      'pagination': instance.pagination,
    };
