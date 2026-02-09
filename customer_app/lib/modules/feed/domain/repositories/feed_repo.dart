import '../entities/feed_item.dart';

class FeedPage {
  final List<FeedItem> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasMore;

  FeedPage({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasMore,
  });
}

abstract class FeedRepository {
  Future<FeedPage> getFeed({
    int page = 1,
    int limit = 10,
    String? vendorType,
    String? category,
    String? sortBy,
    String? city,
  });
}
