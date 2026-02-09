// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../providers/search_notifier.dart';
import '../widgets/search_input.dart';
import '../widgets/vendor_search_tile.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  String _lastQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (query.trim() != _lastQuery) {
      _lastQuery = query.trim();
      if (query.trim().isNotEmpty) {
        ref.read(searchNotifierProvider.notifier).search(query.trim());
      } else {
        ref.read(searchNotifierProvider.notifier).clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(searchNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyles.titleLarge,
        ),
      ),
      body: Column(
        children: [
          // Search input
          Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: SearchInput(
              controller: _searchController,
              onChanged: _onSearchChanged,
              onClear: () {
                ref.read(searchNotifierProvider.notifier).clear();
              },
            ),
          ),
          // Results
          Expanded(
            child: searchState.when(
              initial: () => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 64,
                      color: AppColors.textTertiary,
                    ),
                    Gaps.mdV,
                    Text(
                      'البحث عن طباخين أو وجبات',
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const LoadingView(),
              loaded: (results) {
                if (results.isEmpty) {
                  return EmptyState(
                    icon: Icons.search_off,
                    title: 'No results found',
                    message: 'Try a different search term',
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: Insets.lg),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: Insets.md),
                      child: VendorSearchTile(result: results[index]),
                    );
                  },
                );
              },
              error: (message) => ErrorState(
                message: message,
                onRetry: () {
                  if (_searchController.text.trim().isNotEmpty) {
                    ref
                        .read(searchNotifierProvider.notifier)
                        .search(_searchController.text.trim());
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
