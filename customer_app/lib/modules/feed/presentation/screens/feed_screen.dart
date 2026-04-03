// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/video/video_controller_pool.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/localization/app_localizations.dart';
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
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.addedToCartNamed(item.menuItem.name)),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mdAll,
          ),
          action: SnackBarAction(
            label: l.viewCart,
            textColor: AppColors.textInverse,
            onPressed: () {
              context.go(RouteNames.cart);
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l.addToCartFailed}: ${e.toString()}'),
          backgroundColor: SemanticColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.mdAll,
          ),
        ),
      );
    }
  }

  /// شريط علوي واحد: يمنع تكدّس سطرَي «اسم الفئة» و«الفلتر» فوق صندوق الطباخ/الوجبة في [DishOverlay].
  Widget _buildTopChrome() {
    final l = AppLocalizations.of(context);
    if (widget.category != null) {
      final categoryLabel = l.categoryLabel(widget.category!);
      return SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Insets.sm,
            vertical: Insets.xs,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 20),
                onPressed: () => context.go(RouteNames.categories),
                color: AppColors.textInverse,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.black26,
                  padding: const EdgeInsets.all(8),
                  minimumSize: const Size(40, 40),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              Expanded(
                child: Text(
                  categoryLabel,
                  style: TextStyles.titleSmall.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              _buildFilterButton(),
            ],
          ),
        ),
      );
    }
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Insets.sm,
          vertical: Insets.xs,
        ),
        child: Row(
          children: [
            const Spacer(),
            _buildFilterButton(),
          ],
        ),
      ),
    );
  }

  /// مسافة دفع [DishOverlay] أسفل الشريط العلوي (نفس المنطق بصرياً لكل الفئات).
  double get _dishOverlayTopInset =>
      widget.category != null ? 56.0 : 50.0;

  void _openFilterSheet() {
    final l = AppLocalizations.of(context);
    final notifier = ref.read(feedNotifierProvider.notifier);
    final distanceValues = [null, ...kFeedMaxDistanceOptions];
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.topLG,
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            final currentSort = notifier.currentSortBy;
            final currentMaxDist = notifier.currentMaxDistance;
            final distIndex = currentMaxDist == null
                ? 0
                : (kFeedMaxDistanceOptions.indexOf(currentMaxDist) + 1);
            return SafeArea(
              child: Padding(
                padding: EdgeInsets.all(Insets.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.tune_rounded, color: AppColors.primary, size: 24),
                        Gaps.smH,
                        Text(l.filters, style: TextStyles.titleLarge),
                      ],
                    ),
                    Gaps.lgV,
                    Text(l.sortByLabel, style: TextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
                    Gaps.smV,
                    Row(
                      children: [
                        _buildSortChip(setModalState, notifier, l, kFeedSortDistance, l.sortByDistance, Icons.near_me_outlined, currentSort),
                        Gaps.smH,
                        _buildSortChip(setModalState, notifier, l, kFeedSortRating, l.sortByRating, Icons.star_border_rounded, currentSort),
                        Gaps.smH,
                        _buildSortChip(setModalState, notifier, l, kFeedSortNewest, l.sortByNewest, Icons.schedule_rounded, currentSort),
                      ],
                    ),
                    Gaps.xlV,
                    Text(l.maxDistanceKm, style: TextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
                    Gaps.smV,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filled(
                          onPressed: distIndex > 0
                              ? () {
                                  final newVal = distanceValues[distIndex - 1];
                                  notifier.setMaxDistance(newVal);
                                  setModalState(() {});
                                }
                              : null,
                          icon: Icon(Icons.remove, color: distIndex > 0 ? AppColors.primary : AppColors.disabled),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primaryContainer,
                            disabledBackgroundColor: AppColors.disabledContainer,
                          ),
                        ),
                        Gaps.mdH,
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceVariant,
                            borderRadius: AppRadius.mdAll,
                          ),
                          child: Text(
                            currentMaxDist == null ? l.allDistances : l.distanceKm(currentMaxDist),
                            style: TextStyles.titleMedium,
                          ),
                        ),
                        Gaps.mdH,
                        IconButton.filled(
                          onPressed: distIndex < distanceValues.length - 1
                              ? () {
                                  final newVal = distanceValues[distIndex + 1];
                                  notifier.setMaxDistance(newVal);
                                  setModalState(() {});
                                }
                              : null,
                          icon: Icon(Icons.add, color: distIndex < distanceValues.length - 1 ? AppColors.primary : AppColors.disabled),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primaryContainer,
                            disabledBackgroundColor: AppColors.disabledContainer,
                          ),
                        ),
                      ],
                    ),
                    Gaps.lgV,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSortChip(
    void Function(void Function()) setModalState,
    FeedNotifier notifier,
    AppLocalizations l,
    String value,
    String label,
    IconData icon,
    String? currentSort,
  ) {
    final isSelected = currentSort == value || (currentSort == null && value == kFeedSortDistance);
    return Expanded(
      child: FilterChip(
        avatar: Icon(icon, size: 18, color: isSelected ? AppColors.primary : AppColors.textSecondary),
        label: Text(label, style: TextStyles.labelMedium),
        selected: isSelected,
        onSelected: (_) {
          notifier.setSortBy(value);
          setModalState(() {});
        },
        selectedColor: AppColors.primaryContainer,
        checkmarkColor: AppColors.primary,
      ),
    );
  }

  Widget _buildFilterButton() {
    final l = AppLocalizations.of(context);
    final notifier = ref.read(feedNotifierProvider.notifier);
    final currentSort = notifier.currentSortBy;
    final currentMaxDist = notifier.currentMaxDistance;
    final hasActiveFilter = currentMaxDist != null;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
      child: InkWell(
        onTap: _openFilterSheet,
        borderRadius: AppRadius.fullAll,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
          decoration: BoxDecoration(
            color: Colors.black38,
            borderRadius: AppRadius.fullAll,
            border: Border.all(color: hasActiveFilter ? AppColors.primary : Colors.white24),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.tune_rounded,
                size: 20,
                color: hasActiveFilter ? AppColors.primary : AppColors.textInverse,
              ),
              Gaps.smV,
              Text(
                currentMaxDist != null
                    ? '${l.sortByDistance} • ${l.distanceKm(currentMaxDist)}'
                    : (currentSort == kFeedSortRating
                        ? l.sortByRating
                        : currentSort == kFeedSortNewest
                            ? l.sortByNewest
                            : l.sortByDistance),
                style: TextStyles.labelMedium.copyWith(
                  color: hasActiveFilter ? AppColors.primary : AppColors.textInverse,
                ),
              ),
              Gaps.xsH,
              Icon(Icons.keyboard_arrow_down, size: 20, color: AppColors.textInverse),
            ],
          ),
        ),
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
            _buildTopChrome(),
          ],
        ),
        loading: () => Stack(
          children: [
            const LoadingView(),
            _buildTopChrome(),
          ],
        ),
        loaded: (items, page, hasMore) {
          if (items.isEmpty) {
            final l = AppLocalizations.of(context);
            final notifier = ref.read(feedNotifierProvider.notifier);
            final maxDist = notifier.currentMaxDistance;
            final catLabel = widget.category != null
                ? l.categoryLabel(widget.category!)
                : null;
            final emptyTitle = maxDist != null
                ? l.noVendorsWithinKm(maxDist)
                : (catLabel != null
                    ? '${l.noOffersInCategory} $catLabel'
                    : l.noOffersAvailable);
            return Stack(
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(Insets.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          maxDist != null ? Icons.location_off_outlined : Icons.lunch_dining,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        Gaps.mdV,
                        Text(
                          emptyTitle,
                          style: TextStyles.headlineMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Gaps.smV,
                        Text(
                          maxDist != null ? l.allDistances : l.tryAnotherCategory,
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Gaps.lgV,
                        if (maxDist != null)
                          FilledButton.icon(
                            onPressed: () => notifier.setMaxDistance(null),
                            icon: const Icon(Icons.location_on_outlined, size: 20),
                            label: Text(l.allDistances),
                            style: FilledButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                horizontal: Insets.lg,
                                vertical: Insets.sm,
                              ),
                            ),
                          )
                        else
                          FilledButton.icon(
                            onPressed: () => context.go(RouteNames.categories),
                            icon: const Icon(Icons.grid_view_rounded, size: 20),
                            label: Text(l.backToCategories),
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
                _buildTopChrome(),
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
                    topChromeInset: _dishOverlayTopInset,
                  );
                },
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: _buildTopChrome(),
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
              _buildTopChrome(),
            ],
          );
        },
      ),
    );
  }
}
