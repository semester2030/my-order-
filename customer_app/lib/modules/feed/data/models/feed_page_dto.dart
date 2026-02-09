import 'package:json_annotation/json_annotation.dart';
import 'feed_item_dto.dart';

part 'feed_page_dto.g.dart';

@JsonSerializable()
class PaginationDto {
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasMore;

  PaginationDto({
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasMore,
  });

  factory PaginationDto.fromJson(Map<String, dynamic> json) =>
      _$PaginationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PaginationDtoToJson(this);
}

@JsonSerializable()
class FeedPageDto {
  final List<FeedItemDto> items;
  final PaginationDto pagination;

  FeedPageDto({
    required this.items,
    required this.pagination,
  });

  factory FeedPageDto.fromJson(Map<String, dynamic> json) =>
      _$FeedPageDtoFromJson(json);

  Map<String, dynamic> toJson() => _$FeedPageDtoToJson(this);
}
