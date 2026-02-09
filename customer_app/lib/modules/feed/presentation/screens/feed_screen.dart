// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/constants/provider_categories.dart';
import '../../../../core/video/video_controller_pool.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/routing/route_names.dart';
import '../../domain/entities/feed_item.dart';
import '../providers/feed_notifier.dart';
import '../widgets/feed_video_card.dart';
import '../../../cart/presentation/providers/cart_notifier.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key, this.category});

  final String? category;

  @override
  ConsumerState<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(feedNotifierProvider.notifier).setCategory(widget.category);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    VideoControllerPool.pauseAll();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
    VideoControllerPool.pauseAll();
  }

  Future<void> _onAddToCart(FeedItem item) async {
    try {
      await ref.read(cartNotifierProvider.notifier).addToCart(
            item.menuItem.id,
            1,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تمت إضافة ${item.menuItem.name} إلى السلة'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mdAll,
          ),
          action: SnackBarAction(
            label: 'عرض السلة',
            textColor: AppColors.textInverse,
            onPressed: () {
              context.go(RouteNames.cart);
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل الإضافة للسلة: ${e.toString()}'),
          backgroundColor: SemanticColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mdAll,
          ),
        ),
      );
    }
  }

  Widget _buildCategoryHeader() {
    final categoryLabel = widget.category != null
        ? ProviderCategories.label(widget.category!)
        : 'اكتشف';
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.sm,
          vertical: Insets.xs,
        ),
        child: Row(
          children: [
            if (widget.category != null)
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => context.go(RouteNames.categories),
                color: AppColors.textInverse,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black26,
                ),
              ),
            if (widget.category != null) SizedBox(width: Insets.xs),
            Expanded(
              child: Text(
                categoryLabel,
                style: TextStyles.titleMedium.copyWith(
                  color: AppColors.textInverse,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSortBar() {
    final notifier = ref.read(feedNotifierProvider.notifier);
    final currentSort = notifier.currentSortBy;
    final sortOptions = [
      (kFeedSortDistance, 'الأقرب', Icons.near_me_outlined),
      (kFeedSortRating, 'التقييم', Icons.star_border_rounded),
      (kFeedSortNewest, 'الأحدث', Icons.schedule_rounded),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
      child: Row(
        children: sortOptions.map((opt) {
          final (value, label, icon) = opt;
          final isSelected = currentSort == value || (currentSort == null && value == kFeedSortDistance);
          return Padding(
            padding: EdgeInsets.only(left: Insets.xs),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: isSelected ? AppColors.primary : AppColors.textInverse),
                  SizedBox(width: Insets.xs),
                  Text(label, style: TextStyles.labelMedium.copyWith(color: isSelected ? AppColors.primary : AppColors.textInverse)),
                ],
              ),
              selected: isSelected,
              onSelected: (_) {
                notifier.setSortBy(value);
              },
              backgroundColor: Colors.black38,
              selectedColor: AppColors.surface,
              checkmarkColor: AppColors.primary,
              side: BorderSide(color: isSelected ? AppColors.primary : Colors.white24),
              padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.videoBackground,
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
      body: feedState.when(
        initial: () => Stack(
          children: [
            const LoadingView(),
            if (widget.category != null) _buildCategoryHeader(),
          ],
        ),
        loading: () => Stack(
          children: [
            const LoadingView(),
            if (widget.category != null) _buildCategoryHeader(),
          ],
        ),
        loaded: (items, page, hasMore) {
          if (items.isEmpty) {
            final categoryLabel = widget.category != null
                ? ProviderCategories.label(widget.category!)
                : null;
            return Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(Insets.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lunch_dining,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        Gaps.mdV,
                        Text(
                          categoryLabel != null
                              ? 'لا عروض حالياً في $categoryLabel'
                              : 'لا عروض متاحة حالياً',
                          style: TextStyles.headlineMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Gaps.smV,
                        Text(
                          'جرّب فئة أخرى أو عد لاحقاً',
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Gaps.lgV,
                        FilledButton.icon(
                          onPressed: () => context.go(RouteNames.categories),
                          icon: const Icon(Icons.grid_view_rounded, size: 20),
                          label: const Text('العودة للفئات'),
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: Insets.lg,
                              vertical: Insets.sm,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (widget.category != null) _buildCategoryHeader(),
              ],
            );
          }

          return Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                itemCount: items.length + (hasMore ? 1 : 0),
                onPageChanged: (index) {
                  _onPageChanged(index);
                  if (index >= items.length - 2 && hasMore) {
                    ref.read(feedNotifierProvider.notifier).loadMore();
                  }
                },
                itemBuilder: (context, index) {
                  if (index >= items.length) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }
                  final item = items[index];
                  final isPlaying = index == _currentIndex;
                  return FeedVideoCard(
                    item: item,
                    isPlaying: isPlaying,
                    onAddToCart: () => _onAddToCart(item),
                    acceptsCustomRequests: item.vendor.acceptsCustomRequests,
                  );
                },
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (widget.category != null) _buildCategoryHeader(),
                    if (widget.category == null)
                      SafeArea(bottom: false, child: _buildSortBar())
                    else
                      _buildSortBar(),
                  ],
                ),
              ),
            ],
          );
        },
        error: (message) {
          // Check if error is about missing address
          final isAddressError = message.toLowerCase().contains('no delivery address') ||
              message.toLowerCase().contains('address');
          
          if (isAddressError) {
            // Redirect to address selection screen
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                context.go(RouteNames.selectAddressMap);
              }
            });
            // Show loading while redirecting
            return const LoadingView();
          }
          
          // For other errors, show error state with retry
          return Stack(
            children: [
              ErrorState(
                message: message,
                onRetry: () {
                  ref.read(feedNotifierProvider.notifier).refreshFeed();
                },
              ),
              if (widget.category != null) _buildCategoryHeader(),
            ],
          );
        },
      ),
    );
  }
}
