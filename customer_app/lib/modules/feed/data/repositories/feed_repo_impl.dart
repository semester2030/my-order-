import '../../domain/repositories/feed_repo.dart';
import '../datasources/feed_remote_ds.dart';
import '../mappers/feed_mapper.dart';

class FeedRepositoryImpl implements FeedRepository {
  final FeedRemoteDataSource remoteDataSource;

  FeedRepositoryImpl({required this.remoteDataSource});

  @override
  Future<FeedPage> getFeed({
    int page = 1,
    int limit = 10,
    String? vendorType,
    String? category,
    String? sortBy,
    String? city,
  }) async {
    final dto = await remoteDataSource.getFeed(
      page: page,
      limit: limit,
      vendorType: vendorType,
      category: category,
      sortBy: sortBy,
      city: city,
    );

    return FeedPage(
      items: FeedMapper.mapFeedItemsFromDto(dto.items),
      page: dto.pagination.page,
      limit: dto.pagination.limit,
      total: dto.pagination.total,
      totalPages: dto.pagination.totalPages,
      hasMore: dto.pagination.hasMore,
    );
  }
}
