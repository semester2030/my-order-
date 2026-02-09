import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../domain/repositories/search_repo.dart';
import 'search_state.dart';

final searchNotifierProvider =
    StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  final repository = ref.watch(searchRepositoryProvider);
  return SearchNotifier(repository);
});

class SearchNotifier extends StateNotifier<SearchState> {
  final SearchRepository repository;

  SearchNotifier(this.repository) : super(const SearchState.initial());

  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      state = const SearchState.initial();
      return;
    }

    state = const SearchState.loading();
    try {
      final results = await repository.searchVendors(query);
      state = SearchState.loaded(results);
    } catch (e) {
      state = SearchState.error(e.toString());
    }
  }

  void clear() {
    state = const SearchState.initial();
  }
}
