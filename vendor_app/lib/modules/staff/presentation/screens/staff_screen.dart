import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/widgets/empty_state.dart';
import 'package:vendor_app/core/widgets/error_state.dart';
import 'package:vendor_app/core/widgets/loading_view.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/modules/staff/presentation/providers/staff_state.dart';
import 'package:vendor_app/modules/staff/presentation/widgets/staff_tile.dart';

/// شاشة قائمة الموظفين — ثيم موحد (Phase 13).
class StaffScreen extends ConsumerStatefulWidget {
  const StaffScreen({super.key, this.showDrawerButton = false});

  final bool showDrawerButton;

  @override
  ConsumerState<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends ConsumerState<StaffScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(staffNotifierProvider.notifier).loadStaff();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staffNotifierProvider);

    if (state is StaffLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: const Center(child: LoadingView()),
      );
    }

    if (state is StaffError) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: ErrorState(
          message: state.message,
          onRetry: () => ref.read(staffNotifierProvider.notifier).loadStaff(),
        ),
      );
    }

    if (state is StaffLoaded) {
      final result = state.result;
      if (result.data.isEmpty) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(context),
          body: RefreshIndicator(
            onRefresh: () => ref.read(staffNotifierProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: Insets.lg),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const EmptyState(message: 'لا يوجد موظفون'),
                      Gaps.lgV,
                      TextButton.icon(
                        onPressed: () => context.push(RouteNames.staffAdd),
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة موظف'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }

      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: RefreshIndicator(
          onRefresh: () => ref.read(staffNotifierProvider.notifier).refresh(),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
            itemCount: result.data.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.divider),
            itemBuilder: (context, index) => StaffTile(item: result.data[index]),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(RouteNames.staffAdd),
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

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: widget.showDrawerButton
          ? IconButton(
              icon: Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: () => Scaffold.of(context).openDrawer(),
            )
          : null,
      title: Text(
        AppLocalizations.of(context).staff,
        style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
