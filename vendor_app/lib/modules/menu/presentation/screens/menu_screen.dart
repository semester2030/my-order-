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
import 'package:vendor_app/modules/menu/domain/entities/menu_item.dart';
import 'package:vendor_app/modules/menu/presentation/providers/menu_state.dart';
import 'package:vendor_app/modules/menu/presentation/widgets/menu_item_tile.dart';

/// شاشة قائمة الوجبات — ثيم موحد (Phase 10).
/// [showDrawerButton]: عند true تُعرض أيقونة القائمة لفتح Drawer الـ Shell.
class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key, this.showDrawerButton = false});

  final bool showDrawerButton;

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  String? _togglingId;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(menuNotifierProvider.notifier).loadMenu();
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = ref.read(menuNotifierProvider);
    if (state is! MenuLoaded || !state.result.hasNextPage) {
      return;
    }
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      ref.read(menuNotifierProvider.notifier).loadMore();
    }
  }

  Future<void> _onToggleAvailability(MenuItem item, bool isAvailable) async {
    setState(() => _togglingId = item.id);
    final ok = await ref.read(menuNotifierProvider.notifier).toggleAvailability(item.id, isAvailable);
    if (mounted) setState(() => _togglingId = null);
    if (ok) ref.read(menuNotifierProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(menuNotifierProvider);

    if (state is MenuLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: const Center(child: LoadingView()),
      );
    }

    if (state is MenuError) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: ErrorState(
          message: state.message,
          onRetry: () => ref.read(menuNotifierProvider.notifier).loadMenu(),
        ),
      );
    }

    if (state is MenuLoaded) {
      final result = state.result;
      if (result.data.isEmpty) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(context),
          body: RefreshIndicator(
            onRefresh: () => ref.read(menuNotifierProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: Insets.lg),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      EmptyState(message: AppLocalizations.of(context).noMeals),
                      Gaps.lgV,
                      TextButton.icon(
                        onPressed: () => context.push(RouteNames.menuAdd),
                        icon: const Icon(Icons.add),
                        label: Text(AppLocalizations.of(context).addMeal),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }

      // عرض وجبتين فقط في الشاشة مع مربع فيديو كبير
      final displayList = result.data.take(2).toList();
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: RefreshIndicator(
          onRefresh: () => ref.read(menuNotifierProvider.notifier).refresh(),
          child: ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
            itemCount: displayList.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.divider),
            itemBuilder: (context, index) {
              final item = displayList[index];
              return MenuItemTile(
                item: item,
                onToggleAvailability: (v) => _onToggleAvailability(item, v),
                isToggling: _togglingId == item.id,
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.push(RouteNames.menuAdd),
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
        AppLocalizations.of(context).menu,
        style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
