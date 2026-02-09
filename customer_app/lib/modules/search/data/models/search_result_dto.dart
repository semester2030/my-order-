import 'package:json_annotation/json_annotation.dart';
import '../../../vendors/data/models/vendor_dto.dart';

part 'search_result_dto.g.dart';

@JsonSerializable()
class SearchResultDto {
  final VendorDto vendor;
  final double? distance;

  SearchResultDto({
    required this.vendor,
    this.distance,
  });

  factory SearchResultDto.fromJson(Map<String, dynamic> json) =>
      _$SearchResultDtoFromJson(json);

  Map<String, dynamic> toJson() => _$SearchResultDtoToJson(this);
}
