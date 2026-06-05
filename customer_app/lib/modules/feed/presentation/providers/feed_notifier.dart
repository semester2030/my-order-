import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/feed_repo.dart';
import '../../data/repositories/feed_repo_impl.dart';
import '../../data/datasources/feed_remote_ds.dart';
import '../../../../core/di/providers.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';
import '../../../auth/presentation/providers/guest_mode_notifier.dart';
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
  final isGuest = ref.watch(guestModeProvider);
  final isAuth = ref.watch(authNotifierProvider).maybeWhen(
        authenticated: (_) => true,
        orElse: () => false,
      );
  return FeedNotifier(
    repository,
    usePublicBrowse: isGuest && !isAuth,
  );
});

/// Supported sort options for feed (must match backend: distance | rating | newest).
const String kFeedSortDistance = 'distance';
const String kFeedSortRating = 'rating';
const String kFeedSortNewest = 'newest';

/// مسافات الفلتر (كم) — يجب أن تطابق الـ backend
const List<int> kFeedMaxDistanceOptions = [5, 10, 15, 25];

class FeedNotifier extends StateNotifier<FeedState> {
  final FeedRepository repository;
  final bool usePublicBrowse;
  int _currentPage = 1;
  final int _limit = 10;
  String? _vendorType;
  String? _category;
  String? _sortBy;
  String? _city;
  int? _maxDistance;
  List<FeedItem> _items = [];

  FeedNotifier(this.repository, {this.usePublicBrowse = false})
      : super(const FeedState.initial()) {
    if (usePublicBrowse) {
      _sortBy = kFeedSortNewest;
    }
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
        maxDistance: usePublicBrowse ? null : _maxDistance,
        publicBrowse: usePublicBrowse,
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

  void setMaxDistance(int? km) {
    _maxDistance = km;
    loadFeed(refresh: true);
  }

  String? get currentSortBy => _sortBy;
  String? get currentCity => _city;
  int? get currentMaxDistance => _maxDistance;
}
