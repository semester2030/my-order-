import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/core/widgets/error_state.dart';
import 'package:vendor_app/core/widgets/loading_view.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/analytics/presentation/providers/analytics_state.dart';
import 'package:vendor_app/modules/analytics/presentation/widgets/chart_card.dart';
import 'package:vendor_app/modules/analytics/presentation/widgets/metric_row.dart';

/// شاشة التحليلات — Phase 14.
class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(analyticsNotifierProvider.notifier).load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(analyticsNotifierProvider);

    if (state is AnalyticsLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: const Center(child: LoadingView()),
      );
    }

    if (state is AnalyticsError) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: ErrorState(
          message: state.message,
          onRetry: () => ref.read(analyticsNotifierProvider.notifier).load(),
        ),
      );
    }

    if (state is AnalyticsLoaded) {
      final s = state.snapshot;
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: RefreshIndicator(
          onRefresh: () => ref.read(analyticsNotifierProvider.notifier).load(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ChartCard(
                  title: AppLocalizations.of(context).analyticsSummary,
                  child: Column(
                    children: [
                      MetricRow(
                        label: AppLocalizations.of(context).pendingOrders,
                        value: '${s.pendingOrders}',
                        icon: Icons.pending_actions,
                      ),
                      Divider(height: 1, color: AppColors.divider),
                      MetricRow(
                        label: AppLocalizations.of(context).completedOrders,
                        value: '${s.completedOrders}',
                        icon: Icons.check_circle_outline,
                      ),
                      Divider(height: 1, color: AppColors.divider),
                      MetricRow(
                        label: AppLocalizations.of(context).totalRevenue,
                        value: Formatters.currency(s.totalRevenue),
                        icon: Icons.attach_money,
                      ),
                      Divider(height: 1, color: AppColors.divider),
                      MetricRow(
                        label: AppLocalizations.of(context).menuItemsCount,
                        value: '${s.menuItemsCount}',
                        icon: Icons.restaurant_menu,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: const Center(child: LoadingView()),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
        onPressed: () => context.pop(),
      ),
      title: Text(
        AppLocalizations.of(context).analytics,
        style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
