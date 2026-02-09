import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/widgets/empty_state.dart';
import 'package:vendor_app/core/widgets/error_state.dart';
import 'package:vendor_app/core/widgets/loading_view.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/side_orders/domain/entities/side_order_item.dart';
import 'package:vendor_app/modules/side_orders/presentation/providers/side_orders_state.dart';
import 'package:vendor_app/modules/side_orders/presentation/widgets/add_side_order_form.dart';
import 'package:vendor_app/modules/side_orders/presentation/widgets/side_order_tile.dart';

/// شاشة الطلبات الجانبية — Phase 12 (لمقدمي الطبخ الشعبي فقط).
class SideOrdersScreen extends ConsumerStatefulWidget {
  const SideOrdersScreen({super.key});

  @override
  ConsumerState<SideOrdersScreen> createState() => _SideOrdersScreenState();
}

class _SideOrdersScreenState extends ConsumerState<SideOrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(sideOrdersNotifierProvider.notifier).load();
    });
  }

  void _openAddForm() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.topLG),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: Insets.lg,
          right: Insets.lg,
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: AddSideOrderForm(
          onSaved: (SideOrderItem item) async {
            final ok = await ref.read(sideOrdersNotifierProvider.notifier).addItem(item);
            if (!ctx.mounted) return;
            if (ok) Navigator.of(ctx).pop();
          },
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sideOrdersNotifierProvider);

    if (state is SideOrdersLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: const Center(child: LoadingView()),
      );
    }

    if (state is SideOrdersError) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: ErrorState(
          message: state.message,
          onRetry: () => ref.read(sideOrdersNotifierProvider.notifier).load(),
        ),
      );
    }

    if (state is SideOrdersLoaded) {
      final items = state.items;
      if (items.isEmpty) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(context),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const EmptyState(message: 'لا توجد إضافات للطلبات الجانبية'),
                Gaps.lgV,
                TextButton.icon(
                  onPressed: _openAddForm,
                  icon: const Icon(Icons.add),
                  label: const Text('إضافة صنف'),
                ),
              ],
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: RefreshIndicator(
                onRefresh: () => ref.read(sideOrdersNotifierProvider.notifier).load(),
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.divider),
                  itemBuilder: (context, index) => SideOrderTile(
                    item: items[index],
                    onTap: () => _openEditForm(items[index]),
                    onRemove: () => ref.read(sideOrdersNotifierProvider.notifier).removeItem(items[index].id),
                  ),
                ),
              ),
        floatingActionButton: FloatingActionButton(
                onPressed: _openAddForm,
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add, color: AppColors.textOnPrimary),
              ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(context),
      body: const Center(child: LoadingView()),
    );
  }

  void _openEditForm(SideOrderItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.topLG),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: Insets.lg,
          right: Insets.lg,
          bottom: MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: AddSideOrderForm(
          initialItem: item,
          onSaved: (SideOrderItem updated) async {
            final ok = await ref.read(sideOrdersNotifierProvider.notifier).updateItem(updated);
            if (!ctx.mounted) return;
            if (ok) Navigator.of(ctx).pop();
          },
          onCancel: () => Navigator.of(context).pop(),
        ),
      ),
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
        AppLocalizations.of(context).sideOrdersTitle,
        style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
