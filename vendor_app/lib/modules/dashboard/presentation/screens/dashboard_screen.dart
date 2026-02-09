import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/widgets/empty_state.dart';
import 'package:vendor_app/core/widgets/error_state.dart';
import 'package:vendor_app/core/widgets/loading_view.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/modules/dashboard/presentation/providers/dashboard_state.dart';
import 'package:vendor_app/modules/dashboard/presentation/widgets/orders_summary_card.dart';
import 'package:vendor_app/modules/dashboard/presentation/widgets/stat_card.dart';

/// شاشة لوحة التحكم — ثيم موحد (Phase 5: محتوى بسيط).
/// [showDrawerButton]: عند true تُعرض أيقونة القائمة لفتح Drawer الـ Shell.
class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key, this.showDrawerButton = false});

  final bool showDrawerButton;

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardNotifierProvider.notifier).loadStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(dashboardNotifierProvider);

    if (state is DashboardLoading) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: LoadingView()),
      );
    }

    if (state is DashboardError) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          leading: widget.showDrawerButton
              ? IconButton(
                  icon: Icon(Icons.menu, color: AppColors.textPrimary),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                )
              : null,
          title: Text(l10n.dashboard, style: TextStyles.headlineSmall),
        ),
        body: ErrorState(
          message: state.message,
          onRetry: () => ref.read(dashboardNotifierProvider.notifier).loadStats(),
        ),
      );
    }

    if (state is DashboardLoaded) {
      final stats = state.stats;
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: widget.showDrawerButton
              ? IconButton(
                  icon: Icon(Icons.menu, color: AppColors.textPrimary),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                )
              : null,
          title: Text(
            l10n.dashboard,
            style: TextStyles.headlineSmall.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gaps.lgV,
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  mainAxisSpacing: Insets.md,
                  crossAxisSpacing: Insets.md,
                  childAspectRatio: 1.0,
                  children: [
                    StatCard(
                      title: l10n.pendingOrders,
                      value: '${stats.pendingOrders}',
                      icon: Icons.schedule,
                      color: SemanticColors.warning,
                    ),
                    StatCard(
                      title: l10n.completedOrders,
                      value: '${stats.completedOrders}',
                      icon: Icons.check_circle_outline,
                      color: SemanticColors.success,
                    ),
                    StatCard(
                      title: l10n.totalRevenue,
                      value: Formatters.currency(stats.totalRevenue),
                      icon: Icons.attach_money,
                      color: AppColors.primary,
                    ),
                    StatCard(
                      title: l10n.menuItemsCount,
                      value: '${stats.menuItemsCount}',
                      icon: Icons.restaurant_menu,
                      color: AppColors.primary,
                    ),
                  ],
                ),
                Gaps.xlV,
                OrdersSummaryCard(
                  pendingCount: stats.pendingOrders,
                  completedCount: stats.completedOrders,
                ),
                Gaps.xxlV,
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        leading: widget.showDrawerButton
            ? IconButton(
                icon: Icon(Icons.menu, color: AppColors.textPrimary),
                onPressed: () => Scaffold.of(context).openDrawer(),
              )
            : null,
        title: Text(l10n.dashboard, style: TextStyles.headlineSmall),
      ),
      body: Center(child: EmptyState(message: l10n.noData)),
    );
  }
}
