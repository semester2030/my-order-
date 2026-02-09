import '../../domain/repositories/search_repo.dart';
import '../../domain/entities/search_result.dart';
import '../datasources/search_remote_ds.dart';
import '../mappers/search_mapper.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;

  SearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SearchResult>> searchVendors(String query) async {
    final dtos = await remoteDataSource.searchVendors(query);
    return SearchMapper.mapSearchResultsFromDto(dtos);
  }
}
