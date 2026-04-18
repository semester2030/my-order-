// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/network/endpoints.dart';
import '../../domain/entities/order.dart';
import '../providers/order_details_notifier.dart';
import '../widgets/rating_stars.dart';
import '../../../feed/domain/entities/feed_item.dart';

/// تقييم موحّد: طلب توصيل (`order`) أو طلب حجز/طبخ (`event_request`).
class RatingScreen extends ConsumerStatefulWidget {
  const RatingScreen({
    super.key,
    required this.subjectId,
    this.subjectType = 'order',
  });

  final String subjectId;
  /// `order` | `event_request`
  final String subjectType;

  @override
  ConsumerState<RatingScreen> createState() => _RatingScreenState();
}

Vendor _vendorFromEventRow(Map<String, dynamic> row) {
  final raw = row['vendor'];
  if (raw is! Map<String, dynamic>) {
    return const Vendor(
      id: '',
      name: '—',
      logo: null,
      rating: 0,
      ratingCount: 0,
      type: '',
    );
  }
  final id = (raw['id'] ?? '').toString();
  final name =
      (raw['name'] ?? raw['tradeName'] ?? raw['trade_name'] ?? '—').toString();
  final logoRaw = raw['logo'] ?? raw['logoUrl'] ?? raw['logo_url'];
  final logoUrl = Endpoints.resolveMenuImageUrl(logoRaw?.toString());
  final rating = double.tryParse((raw['rating'] ?? 0).toString()) ?? 0;
  final rc = int.tryParse(
        (raw['ratingCount'] ?? raw['rating_count'] ?? 0).toString(),
      ) ??
      0;
  final type = (raw['type'] ?? '').toString();
  return Vendor(
    id: id,
    name: name,
    logo: logoUrl,
    rating: rating,
    ratingCount: rc,
    type: type,
    acceptsCustomRequests: true,
    providerCategory: raw['providerCategory']?.toString() ??
        raw['provider_category']?.toString(),
  );
}

class _RatingScreenState extends ConsumerState<RatingScreen> {
  int _rating = 0;
  String? _review;
  bool _isSubmitting = false;

  Map<String, dynamic>? _eventRow;
  String? _eventError;
  bool _eventLoading = false;

  bool get _isOrder => widget.subjectType == 'order';

  @override
  void initState() {
    super.initState();
    if (!_isOrder) {
      _loadEvent();
    }
  }

  Future<void> _loadEvent() async {
    setState(() {
      _eventLoading = true;
      _eventError = null;
    });
    try {
      final row = await ref
          .read(vendorsRepositoryProvider)
          .getMyCustomerEventRequestById(widget.subjectId);
      if (!mounted) return;
      setState(() {
        _eventRow = row;
        _eventLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _eventError = e.toString();
        _eventLoading = false;
      });
    }
  }

  Future<void> _handleSubmitRating(AppLocalizations l) async {
    if (_rating == 0) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await ref.read(serviceExperienceRepositoryProvider).submitReview(
            subjectType: widget.subjectType,
            subjectId: widget.subjectId,
            stars: _rating,
            publicComment: _review,
          );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.thankYouForFeedback),
          backgroundColor: SemanticColors.success,
        ),
      );

      context.go(RouteNames.categories);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isSubmitting = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l.ratingSubmitFailed}: ${e.toString()}'),
          backgroundColor: SemanticColors.error,
        ),
      );
    }
  }

  Widget _buildRatingContent(BuildContext context, Vendor vendor, AppLocalizations l) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gaps.xlV,
                _VendorInfoCard(vendor: vendor),
                Gaps.xlV,
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
                        l.rateYourExperience,
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
                if (_isOrder) ...[
                  Gaps.lgV,
                  _OrderSummaryCard(subjectId: widget.subjectId),
                ],
              ],
            ),
          ),
        ),
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
                      ? () => _handleSubmitRating(l)
                      : null,
                  text: l.submitRating,
                  width: double.infinity,
                  isLoading: _isSubmitting,
                ),
                Gaps.mdV,
                TextButton(
                  onPressed: _isSubmitting
                      ? null
                      : () {
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    if (_isOrder) {
      final orderState = ref.watch(orderDetailsNotifierProvider(widget.subjectId));

      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: Text(
            l.rateYourExperience,
            style: TextStyles.titleLarge,
          ),
        ),
        body: orderState.when(
          initial: () => const LoadingView(),
          loading: () => const LoadingView(),
          loaded: (order) => _buildRatingContent(context, order.vendor, l),
          error: (message) => ErrorState(
            message: message,
            onRetry: () {
              ref.read(orderDetailsNotifierProvider(widget.subjectId).notifier).loadOrderDetails();
            },
          ),
        ),
      );
    }

    if (_eventLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: Text(l.rateYourExperience, style: TextStyles.titleLarge)),
        body: const LoadingView(),
      );
    }

    if (_eventError != null || _eventRow == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: Text(l.rateYourExperience, style: TextStyles.titleLarge)),
        body: ErrorState(
          message: _eventError ?? '—',
          onRetry: _loadEvent,
        ),
      );
    }

    final vendor = _vendorFromEventRow(_eventRow!);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.rateYourExperience, style: TextStyles.titleLarge),
      ),
      body: _buildRatingContent(context, vendor, l),
    );
  }
}

class _OrderSummaryCard extends ConsumerWidget {
  const _OrderSummaryCard({required this.subjectId});

  final String subjectId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderDetailsNotifierProvider(subjectId));
    return orderState.maybeWhen(
      loaded: (order) => _OrderSummaryInner(order: order),
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _OrderSummaryInner extends StatelessWidget {
  const _OrderSummaryInner({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Container(
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
            AppLocalizations.of(context).isAr ? 'ملخص الطلب' : 'Order summary',
            style: TextStyles.titleMedium,
          ),
          Gaps.mdV,
          const Divider(color: AppColors.warmDivider),
          Gaps.mdV,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).isAr ? 'رقم الطلب' : 'Order number',
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
                AppLocalizations.of(context).total,
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
    );
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
                      '(${vendor.ratingCount})',
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
