import '../../domain/entities/search_result.dart';
import '../models/search_result_dto.dart';
import '../../../vendors/data/mappers/vendors_mapper.dart';

class SearchMapper {
  static SearchResult mapSearchResultFromDto(SearchResultDto dto) {
    return SearchResult(
      vendor: VendorsMapper.mapVendorFromDto(dto.vendor),
      distance: dto.distance,
    );
  }

  static List<SearchResult> mapSearchResultsFromDto(
    List<SearchResultDto> dtos,
  ) {
    return dtos.map((dto) => mapSearchResultFromDto(dto)).toList();
  }
}
