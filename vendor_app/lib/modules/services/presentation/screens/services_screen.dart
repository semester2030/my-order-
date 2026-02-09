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
import 'package:vendor_app/modules/services/presentation/providers/services_state.dart';
import 'package:vendor_app/modules/services/presentation/widgets/service_item_tile.dart';

/// شاشة قائمة الخدمات — ثيم موحد (Phase 11).
/// [showDrawerButton]: عند true تُعرض أيقونة القائمة لفتح Drawer الـ Shell.
class ServicesScreen extends ConsumerStatefulWidget {
  const ServicesScreen({super.key, this.showDrawerButton = false});

  final bool showDrawerButton;

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(servicesNotifierProvider.notifier).loadServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(servicesNotifierProvider);

    if (state is ServicesLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: const Center(child: LoadingView()),
      );
    }

    if (state is ServicesError) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: ErrorState(
          message: state.message,
          onRetry: () => ref.read(servicesNotifierProvider.notifier).loadServices(),
        ),
      );
    }

    if (state is ServicesLoaded) {
      final result = state.result;
      if (result.data.isEmpty) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(context),
          body: RefreshIndicator(
            onRefresh: () => ref.read(servicesNotifierProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: Insets.lg),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const EmptyState(message: 'لا توجد خدمات'),
                      Gaps.lgV,
                      TextButton.icon(
                        onPressed: () => context.push(RouteNames.servicesAdd),
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة خدمة'),
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
          onRefresh: () => ref.read(servicesNotifierProvider.notifier).refresh(),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
            itemCount: result.data.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.divider),
            itemBuilder: (context, index) {
              return ServiceItemTile(item: result.data[index]);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(RouteNames.servicesAdd),
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
        AppLocalizations.of(context).myServices,
        style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
