import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/feed_repo.dart';
import '../../data/repositories/feed_repo_impl.dart';
import '../../data/datasources/feed_remote_ds.dart';
import '../../../../core/di/providers.dart';
import '../../domain/entities/feed_item.dart';
import 'feed_state.dart';

final feedRepositoryProvider = Provider<FeedRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = FeedRemoteDataSourceImpl(apiClient: apiClient);
  return FeedRepositoryImpl(remoteDataSource: remoteDataSource);
});

final feedNotifierProvider =
    StateNotifierProvider<FeedNotifier, FeedState>((ref) {
  final repository = ref.watch(feedRepositoryProvider);
  return FeedNotifier(repository);
});

/// Supported sort options for feed (must match backend: distance | rating | newest).
const String kFeedSortDistance = 'distance';
const String kFeedSortRating = 'rating';
const String kFeedSortNewest = 'newest';

class FeedNotifier extends StateNotifier<FeedState> {
  final FeedRepository repository;
  int _currentPage = 1;
  final int _limit = 10;
  String? _vendorType;
  String? _category;
  String? _sortBy;
  String? _city;
  List<FeedItem> _items = [];

  FeedNotifier(this.repository) : super(const FeedState.initial()) {
    // Don't auto-load feed - let FeedScreen call loadFeed() explicitly
    // This prevents loading feed when user doesn't have an address
  }

  Future<void> loadFeed({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _items = [];
      state = const FeedState.loading();
    } else {
      // Check if already loading
      final isAlreadyLoading = state.maybeWhen(
        loading: () => true,
        orElse: () => false,
      );
      if (isAlreadyLoading) {
        return; // Already loading
      }
      state = const FeedState.loading();
    }

    try {
      final feedPage = await repository.getFeed(
        page: _currentPage,
        limit: _limit,
        vendorType: _vendorType,
        category: _category,
        sortBy: _sortBy,
        city: _city,
      );

      if (refresh) {
        _items = feedPage.items;
      } else {
        _items.addAll(feedPage.items);
      }

      _currentPage++;

      state = FeedState.loaded(
        items: _items,
        page: _currentPage - 1,
        hasMore: feedPage.hasMore,
      );
    } catch (e) {
      state = FeedState.error(e.toString());
    }
  }

  Future<void> refreshFeed() async {
    await loadFeed(refresh: true);
  }

  Future<void> loadMore() async {
    state.maybeWhen(
      loaded: (items, page, hasMore) {
        if (hasMore) {
          loadFeed();
        }
      },
      orElse: () {},
    );
  }

  void filterByVendorType(String? vendorType) {
    _vendorType = vendorType;
    loadFeed(refresh: true);
  }

  void setCategory(String? category) {
    _category = category;
    loadFeed(refresh: true);
  }

  void setSortBy(String? sortBy) {
    _sortBy = sortBy;
    loadFeed(refresh: true);
  }

  void setCity(String? city) {
    _city = city?.trim().isEmpty == true ? null : city?.trim();
    loadFeed(refresh: true);
  }

  String? get currentSortBy => _sortBy;
  String? get currentCity => _city;
}
