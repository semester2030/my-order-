// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/order.dart';
import '../providers/order_details_notifier.dart';
import '../widgets/rating_stars.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../feed/domain/entities/feed_item.dart';

class RatingScreen extends ConsumerStatefulWidget {
  final String orderId;

  const RatingScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  int _rating = 0;
  String? _review;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final orderState = ref.watch(orderDetailsNotifierProvider(widget.orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Rate Your Order',
          style: TextStyles.titleLarge,
        ),
      ),
      body: orderState.when(
        initial: () => const LoadingView(),
        loading: () => const LoadingView(),
        loaded: (order) => _buildRatingContent(context, order),
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

  Widget _buildRatingContent(BuildContext context, Order order) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gaps.xlV,
                // Vendor info
                _VendorInfoCard(vendor: order.vendor),
                Gaps.xlV,
                // Rating section
                Container(
                  padding: const EdgeInsets.all(Insets.xl),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceElevated,
                    borderRadius: AppRadius.lgAll,
                    boxShadow: AppShadows.elevation2,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'How was your experience?',
                        style: TextStyles.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      Gaps.xlV,
                      RatingStars(
                        rating: _rating,
                        onRatingChanged: (rating) {
                          setState(() {
                            _rating = rating;
                          });
                        },
                        size: 48.0,
                      ),
                      Gaps.xlV,
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Tell us more about your experience (optional)',
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
                        maxLines: 5,
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
                Gaps.lgV,
                // Order summary
                Container(
                  padding: const EdgeInsets.all(Insets.lg),
                  decoration: BoxDecoration(
                    color: AppColors.warmSurface,
                    borderRadius: AppRadius.mdAll,
                    boxShadow: AppShadows.elevation1,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Order Summary',
                        style: TextStyles.titleMedium,
                      ),
                      Gaps.mdV,
                      const Divider(color: AppColors.warmDivider),
                      Gaps.mdV,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Order Number',
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            order.orderNumber,
                            style: TextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Gaps.smV,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total',
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            '${order.total.toStringAsFixed(2)} SAR',
                            style: TextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
                  onPressed: _rating > 0 && !_isSubmitting
                      ? _handleSubmitRating
                      : null,
                  text: 'Submit Rating',
                  width: double.infinity,
                  isLoading: _isSubmitting,
                ),
                Gaps.mdV,
                TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
                          context.go(RouteNames.orders);
                        },
                  child: Text(
                    'Skip',
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
      if (reviewText.isEmpty) {}

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Thank you for your feedback!'),
          backgroundColor: SemanticColors.success,
        ),
      );

      // Navigate to orders
      context.go(RouteNames.orders);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit rating: ${e.toString()}'),
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
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: AppRadius.smAll,
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
              ),
            )
          else
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: AppRadius.smAll,
              ),
              child: Icon(
                Icons.restaurant,
                color: AppColors.primary,
                size: 40,
              ),
            ),
          Gaps.mdH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor.name,
                  style: TextStyles.titleLarge,
                ),
                Gaps.xsV,
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 18,
                      color: AppColors.accent,
                    ),
                    Gaps.xsH,
                    Text(
                      vendor.rating.toStringAsFixed(1),
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Gaps.smH,
                    Text(
                      '(${vendor.ratingCount} reviews)',
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
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
