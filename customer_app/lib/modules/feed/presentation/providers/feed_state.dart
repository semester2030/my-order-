import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/feed_item.dart';

part 'feed_state.freezed.dart';

@freezed
class FeedState with _$FeedState {
  const factory FeedState.initial() = _Initial;
  const factory FeedState.loading() = _Loading;
  const factory FeedState.loaded({
    required List<FeedItem> items,
    required int page,
    required bool hasMore,
  }) = _Loaded;
  const factory FeedState.error(String message) = _Error;
}
