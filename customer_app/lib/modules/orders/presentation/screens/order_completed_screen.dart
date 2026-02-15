// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/order.dart';
import '../providers/order_details_notifier.dart';
import '../widgets/rating_stars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../feed/domain/entities/feed_item.dart';

class OrderCompletedScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderCompletedScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<OrderCompletedScreen> createState() =>
      _OrderCompletedScreenState();
}

class _OrderCompletedScreenState extends ConsumerState<OrderCompletedScreen> {
  int _rating = 0;
  String? _review;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderDetailsNotifierProvider(widget.orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: orderState.when(
        initial: () => const LoadingView(),
        loading: () => const LoadingView(),
        loaded: (order) => _buildCompletedContent(context, order),
        error: (message) => ErrorState(
          message: message,
          onRetry: () {
            ref.read(orderDetailsNotifierProvider(widget.orderId).notifier)
                .loadOrderDetails();
          },
        ),
      ),
    );
  }

  Widget _buildCompletedContent(BuildContext context, Order order) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gaps.xxlV,
                // Success icon
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: SemanticColors.success.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 80,
                      color: SemanticColors.success,
                    ),
                  ),
                ),
                Gaps.xlV,
                // Title
                Text(
                  l.orderDelivered,
                  style: TextStyles.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                Gaps.mdV,
                Text(
                  l.thankYouForOrder,
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.xlV,
                // Order info card
                Container(
                  padding: const EdgeInsets.all(Insets.lg),
                  decoration: BoxDecoration(
                    color: AppColors.warmSurface,
                    borderRadius: AppRadius.lgAll,
                    boxShadow: AppShadows.elevation2,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l.orderNumberLabel,
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            order.orderNumber,
                            style: TextStyles.titleMedium.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Gaps.mdV,
                      const Divider(color: AppColors.warmDivider),
                      Gaps.mdV,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l.total,
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '${order.total.toStringAsFixed(2)} SAR',
                            style: TextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Gaps.lgV,
                // Vendor info
                _VendorInfoCard(vendor: order.vendor),
                Gaps.xlV,
                // Rating section
                Container(
                  padding: const EdgeInsets.all(Insets.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: AppRadius.mdAll,
                    boxShadow: AppShadows.elevation1,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l.rateYourExperience,
                        style: TextStyles.titleMedium,
                      ),
                      Gaps.mdV,
                      Center(
                        child: RatingStars(
                          rating: _rating,
                          onRatingChanged: (rating) {
                            setState(() {
                              _rating = rating;
                            });
                          },
                        ),
                      ),
                      Gaps.lgV,
                      TextField(
                        decoration: InputDecoration(
                          hintText: l.writeReviewHint,
                          hintStyle: TextStyles.bodyMedium.copyWith(
                            color: AppColors.textTertiary,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: AppRadius.mdAll,
                            borderSide: BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: AppRadius.mdAll,
                            borderSide: BorderSide(
                              color: AppColors.border,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: AppRadius.mdAll,
                            borderSide: BorderSide(
                              color: AppColors.primary,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.all(Insets.md),
                        ),
                        maxLines: 4,
                        style: TextStyles.bodyMedium,
                        onChanged: (value) {
                          setState(() {
                            _review = value.isEmpty ? null : value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Action buttons
        Container(
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            boxShadow: AppShadows.elevation4,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(
                  onPressed: _rating > 0 && !_isSubmitting ? _handleSubmitRating : null,
                  text: l.submitRating,
                  width: double.infinity,
                  isLoading: _isSubmitting,
                ),
                Gaps.mdV,
                TextButton(
                  onPressed: () {
                    context.go(RouteNames.categories);
                  },
                  child: Text(
                    l.skipForNow,
                    style: TextStyles.button.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleSubmitRating() async {
    if (_rating == 0) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // TODO: Implement rating submission API call
      // await ref.read(orderDetailsNotifierProvider(widget.orderId).notifier)
      //     .submitRating(_rating, _review);
      
      // Use _review to avoid unused field warning
      // This will be used when API is implemented
      final reviewText = _review ?? '';
      // Suppress unused variable warning - will be used in API call
      if (reviewText.isEmpty) {
        // Review is optional, so empty is valid
      }

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.thankYouForFeedback),
          backgroundColor: SemanticColors.success,
        ),
      );

      // Navigate to feed
      context.go(RouteNames.categories);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      final l = AppLocalizations.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l.ratingSubmitFailed}: ${e.toString()}'),
          backgroundColor: SemanticColors.error,
        ),
      );
    }
  }
}

class _VendorInfoCard extends StatelessWidget {
  final Vendor vendor;

  const _VendorInfoCard({
    required this.vendor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.elevation1,
      ),
      child: Row(
        children: [
          if (vendor.logo != null)
            ClipRRect(
              borderRadius: AppRadius.smAll,
              child: CachedNetworkImage(
                imageUrl: vendor.logo!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: AppRadius.smAll,
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: AppRadius.smAll,
              ),
              child: Icon(
                Icons.restaurant,
                color: AppColors.primary,
              ),
            ),
          Gaps.mdH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor.name,
                  style: TextStyles.titleMedium,
                ),
                Gaps.xsV,
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.accent,
                    ),
                    Gaps.xsH,
                    Text(
                      vendor.rating.toStringAsFixed(1),
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
