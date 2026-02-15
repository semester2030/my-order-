// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_tracking.dart';
import '../providers/orders_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(ordersNotifierProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final ordersState = ref.watch(ordersNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.myOrders,
          style: TextStyles.headlineMedium,
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
      body: ordersState.when(
        initial: () => const LoadingView(),
        loading: () => const LoadingView(),
        loaded: (orders) {
          if (orders.isEmpty) {
            return EmptyState(
              icon: Icons.receipt_long_outlined,
              title: l10n.noOrdersYet,
              message: l10n.ordersWillAppear,
              actionText: l10n.browseFeed,
              onAction: () => context.go(RouteNames.categories),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref.read(ordersNotifierProvider.notifier).refreshOrders();
            },
            color: AppColors.primary,
            child: ListView.builder(
              padding: const EdgeInsets.all(Insets.md),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _OrderCard(order: order);
              },
            ),
          );
        },
        error: (message) => ErrorState(
          message: message,
          onRetry: () {
            ref.read(ordersNotifierProvider.notifier).loadOrders();
          },
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final Order order;

  const _OrderCard({required this.order});

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
      case OrderStatus.confirmed:
        return AppColors.warning;
      case OrderStatus.preparing:
      case OrderStatus.ready:
        return AppColors.info;
      case OrderStatus.outForDelivery:
        return AppColors.primary;
      case OrderStatus.delivered:
        return AppColors.success;
      case OrderStatus.cancelled:
        return AppColors.error;
    }
  }

  String _getStatusText(BuildContext context, OrderStatus status) {
    final l = AppLocalizations.of(context);
    switch (status) {
      case OrderStatus.pending:
        return l.orderStatusPending;
      case OrderStatus.confirmed:
        return l.orderStatusConfirmed;
      case OrderStatus.preparing:
        return l.orderStatusPreparing;
      case OrderStatus.ready:
        return l.orderStatusReady;
      case OrderStatus.outForDelivery:
        return l.orderStatusOutForDelivery;
      case OrderStatus.delivered:
        return l.orderStatusDelivered;
      case OrderStatus.cancelled:
        return l.orderStatusCancelled;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Container(
      margin: const EdgeInsets.only(bottom: Insets.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.elevation2,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push('${RouteNames.orderDetails}/${order.id}');
          },
          borderRadius: AppRadius.mdAll,
          child: Padding(
            padding: const EdgeInsets.all(Insets.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.orderNumber,
                            style: TextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Gaps.xsV,
                          Text(
                            DateFormat('MMM dd, yyyy • hh:mm a')
                                .format(order.createdAt),
                            style: TextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Insets.sm,
                        vertical: Insets.xs,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(order.tracking.status)
                            .withValues(alpha: 0.1),
                        borderRadius: AppRadius.fullAll,
                      ),
                      child: Text(
                        _getStatusText(context, order.tracking.status),
                        style: TextStyles.labelSmall.copyWith(
                          color: _getStatusColor(order.tracking.status),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Gaps.mdV,
                // Vendor info
                Row(
                  children: [
                    if (order.vendor.logo != null)
                      ClipRRect(
                        borderRadius: AppRadius.smAll,
                        child: CachedNetworkImage(
                          imageUrl: order.vendor.logo!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              Container(
                            width: 40,
                            height: 40,
                            color: AppColors.surface,
                            child: const Icon(Icons.restaurant),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: AppRadius.smAll,
                        ),
                        child: const Icon(
                          Icons.restaurant,
                          color: AppColors.primary,
                        ),
                      ),
                    Gaps.smH,
                    Expanded(
                      child: Text(
                        order.vendor.name,
                        style: TextStyles.bodyLarge,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                Gaps.mdV,
                // Items count and total
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order.items.length} ${l.itemsCount(order.items.length)}',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${order.total.toStringAsFixed(2)} SAR',
                      style: TextStyles.titleMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
