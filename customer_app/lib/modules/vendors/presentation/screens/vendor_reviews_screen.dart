// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../domain/entities/vendor.dart';
import '../providers/vendor_notifier.dart';
import '../widgets/vendor_header.dart';
import 'package:intl/intl.dart';

class VendorReviewsScreen extends ConsumerWidget {
  final String vendorId;

  const VendorReviewsScreen({
    super.key,
    required this.vendorId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final vendorState = ref.watch(vendorNotifierProvider(vendorId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l.reviews,
          style: TextStyles.titleLarge,
        ),
      ),
      body: vendorState.when(
        initial: () => const LoadingView(),
        loading: () => const LoadingView(),
        loaded: (vendor, menuItems) => _buildReviewsContent(context, vendor, l),
        error: (message) => ErrorState(
          message: message,
          onRetry: () {
            ref.read(vendorNotifierProvider(vendorId).notifier).refresh();
          },
        ),
      ),
    );
  }

  Widget _buildReviewsContent(
      BuildContext context, Vendor vendor, AppLocalizations l) {
    final reviews = <_Review>[];

    return Column(
      children: [
        VendorHeader(vendor: vendor),
        Expanded(
          child: reviews.isEmpty
              ? EmptyState(
                  icon: Icons.reviews_outlined,
                  title: l.noReviewsYet,
                  message: l.beFirstToReview(vendor.name),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(Insets.lg),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviews[index];
                    return _ReviewCard(review: review);
                  },
                ),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final _Review review;

  const _ReviewCard({
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Insets.md),
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.elevation1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and rating
          Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryContainer,
                child: Text(
                  review.userName[0].toUpperCase(),
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Gaps.mdH,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: TextStyles.titleSmall,
                    ),
                    Gaps.xsV,
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          final starIndex = index + 1;
                          final isFilled = starIndex <= review.rating;
                          return Icon(
                            isFilled ? Icons.star : Icons.star_border,
                            size: 16,
                            color: isFilled ? AppColors.accent : AppColors.border,
                          );
                        }),
                        Gaps.xsH,
                        Text(
                          DateFormat('MMM dd, yyyy').format(review.date),
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
          // Review text
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            Gaps.mdV,
            Text(
              review.comment!,
              style: TextStyles.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

// Temporary review model - will be replaced with actual entity
class _Review {
  final String userName;
  final int rating;
  final String? comment;
  final DateTime date;

  _Review({
    required this.userName,
    required this.rating,
    required this.comment,
    required this.date,
  });
}
