import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/widgets/empty_state.dart';
import 'package:vendor_app/core/widgets/error_state.dart';
import 'package:vendor_app/core/widgets/loading_view.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/orders/presentation/providers/orders_state.dart';
import 'package:vendor_app/modules/orders/presentation/widgets/order_tile.dart';

/// شاشة قائمة الطلبات — ثيم موحد (Phase 9).
/// [showDrawerButton]: عند true تُعرض أيقونة القائمة لفتح Drawer الـ Shell.
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key, this.showDrawerButton = false});

  final bool showDrawerButton;

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersNotifierProvider.notifier).loadOrders();
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
    final state = ref.read(ordersNotifierProvider);
    if (state is! OrdersLoaded || !state.result.hasNextPage) {
      return;
    }
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent - 200) {
      ref.read(ordersNotifierProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(ordersNotifierProvider);

    if (state is OrdersLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: const Center(child: LoadingView()),
      );
    }

    if (state is OrdersError) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(context),
        body: ErrorState(
          message: state.message,
          onRetry: () => ref.read(ordersNotifierProvider.notifier).loadOrders(),
        ),
      );
    }

    if (state is OrdersLoaded) {
      final result = state.result;
      if (result.data.isEmpty) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: _buildAppBar(context),
          body: RefreshIndicator(
            onRefresh: () => ref.read(ordersNotifierProvider.notifier).refresh(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: Insets.lg),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                  child: EmptyState(message: AppLocalizations.of(context).noOrders),
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
          onRefresh: () => ref.read(ordersNotifierProvider.notifier).refresh(),
          child: ListView.separated(
            controller: _scrollController,
            padding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
            itemCount: result.data.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.divider),
            itemBuilder: (context, index) {
              final order = result.data[index];
              return OrderTile(order: order);
            },
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
      leading: widget.showDrawerButton
          ? IconButton(
              icon: Icon(Icons.menu, color: AppColors.textPrimary),
              onPressed: () => Scaffold.of(context).openDrawer(),
            )
          : null,
      title: Text(
        AppLocalizations.of(context).orders,
        style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
      ),
    );
  }
}
