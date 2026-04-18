// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/design_system.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/di/providers.dart';
import '../../domain/entities/vendor.dart';
import '../providers/vendor_notifier.dart';
import '../widgets/vendor_header.dart';

class VendorReviewsScreen extends ConsumerStatefulWidget {
  final String vendorId;

  const VendorReviewsScreen({
    super.key,
    required this.vendorId,
  });

  @override
  ConsumerState<VendorReviewsScreen> createState() => _VendorReviewsScreenState();
}

class _VendorReviewsScreenState extends ConsumerState<VendorReviewsScreen> {
  List<Map<String, dynamic>> _items = [];
  int _total = 0;
  bool _loading = true;
  String? _error;
  int _page = 1;
  static const _pageSize = 20;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load(reset: true));
  }

  Future<void> _load({bool reset = false}) async {
    if (reset) {
      setState(() {
        _page = 1;
        _loading = true;
        _error = null;
      });
    }
    try {
      final res = await ref.read(serviceExperienceRepositoryProvider).getPublicVendorReviews(
            widget.vendorId,
            page: _page,
            limit: _pageSize,
          );
      if (!mounted) return;
      final raw = res['items'];
      final list = <Map<String, dynamic>>[];
      if (raw is List) {
        for (final e in raw) {
          if (e is Map) list.add(Map<String, dynamic>.from(e));
        }
      }
      final tot = int.tryParse(res['total']?.toString() ?? '') ?? list.length;
      setState(() {
        _items = list;
        _total = tot;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final vendorState = ref.watch(vendorNotifierProvider(widget.vendorId));

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
        loaded: (vendor, menuItems) => _buildBody(context, vendor, l),
        error: (message) => ErrorState(
          message: message,
          onRetry: () {
            ref.read(vendorNotifierProvider(widget.vendorId).notifier).refresh();
          },
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, Vendor vendor, AppLocalizations l) {
    if (_loading) {
      return Column(
        children: [
          VendorHeader(vendor: vendor),
          const Expanded(child: LoadingView()),
        ],
      );
    }
    if (_error != null) {
      return Column(
        children: [
          VendorHeader(vendor: vendor),
          Expanded(
            child: ErrorState(message: _error!, onRetry: () => _load(reset: true)),
          ),
        ],
      );
    }

    return Column(
      children: [
        VendorHeader(vendor: vendor),
        Expanded(
          child: _items.isEmpty
              ? EmptyState(
                  icon: Icons.reviews_outlined,
                  title: l.noReviewsYet,
                  message: l.beFirstToReview(vendor.name),
                )
              : RefreshIndicator(
                  onRefresh: () => _load(reset: true),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(Insets.lg),
                    itemCount: _items.length + (_items.length < _total ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _items.length) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: Insets.md),
                          child: Center(
                            child: TextButton(
                              onPressed: () async {
                                _page++;
                                try {
                                  final res = await ref
                                      .read(serviceExperienceRepositoryProvider)
                                      .getPublicVendorReviews(
                                        widget.vendorId,
                                        page: _page,
                                        limit: _pageSize,
                                      );
                                  if (!mounted) return;
                                  final raw = res['items'];
                                  final more = <Map<String, dynamic>>[];
                                  if (raw is List) {
                                    for (final e in raw) {
                                      if (e is Map) more.add(Map<String, dynamic>.from(e));
                                    }
                                  }
                                  setState(() => _items = [..._items, ...more]);
                                } catch (_) {
                                  _page--;
                                }
                              },
                              child: Text(l.isAr ? 'تحميل المزيد' : 'Load more'),
                            ),
                          ),
                        );
                      }
                      final row = _items[index];
                      return _PublicReviewCard(row: row, locale: l.locale);
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

class _PublicReviewCard extends StatelessWidget {
  const _PublicReviewCard({
    required this.row,
    required this.locale,
  });

  final Map<String, dynamic> row;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final stars = int.tryParse((row['stars'] ?? 0).toString()) ?? 0;
    final comment = row['publicComment'] ?? row['public_comment'];
    final createdRaw = row['createdAt'] ?? row['created_at'];
    DateTime? dt;
    if (createdRaw is String) {
      dt = DateTime.tryParse(createdRaw);
    }
    final dateStr = dt != null
        ? DateFormat.yMMMd(locale.languageCode).format(dt.toLocal())
        : '';

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
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.primaryContainer,
                child: Icon(Icons.person, color: AppColors.primary, size: 22),
              ),
              Gaps.mdH,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      locale.languageCode == 'ar' ? 'عميل' : 'Customer',
                      style: TextStyles.titleSmall,
                    ),
                    Gaps.xsV,
                    Row(
                      children: [
                        ...List.generate(5, (index) {
                          final starIndex = index + 1;
                          final isFilled = starIndex <= stars;
                          return Icon(
                            isFilled ? Icons.star : Icons.star_border,
                            size: 16,
                            color: isFilled ? AppColors.accent : AppColors.border,
                          );
                        }),
                        if (dateStr.isNotEmpty) ...[
                          Gaps.xsH,
                          Text(
                            dateStr,
                            style: TextStyles.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (comment != null && comment.toString().trim().isNotEmpty) ...[
            Gaps.mdV,
            Text(
              comment.toString(),
              style: TextStyles.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
