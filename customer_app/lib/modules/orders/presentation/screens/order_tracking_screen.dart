import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/order_tracking.dart';
import '../../../../core/routing/route_names.dart';
import '../providers/order_details_notifier.dart';
import '../widgets/order_timeline.dart';
import '../widgets/driver_contact_bar.dart';
import '../widgets/tracking_map_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

class OrderTrackingScreen extends ConsumerStatefulWidget {
  final String orderId;

  const OrderTrackingScreen({
    super.key,
    required this.orderId,
  });

  @override
  ConsumerState<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
  Timer? _refreshTimer;

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final orderId = widget.orderId;
    final orderState = ref.watch(orderDetailsNotifierProvider(orderId));

    ref.listen(orderDetailsNotifierProvider(orderId), (prev, next) {
      next.when(
        initial: () {
          _refreshTimer?.cancel();
          _refreshTimer = null;
        },
        loading: () {},
        loaded: (order) {
          if (order.tracking.status == OrderStatus.outForDelivery) {
            _refreshTimer ??= Timer.periodic(const Duration(seconds: 20), (_) {
              ref.read(orderDetailsNotifierProvider(orderId).notifier).refresh();
            });
          } else {
            _refreshTimer?.cancel();
            _refreshTimer = null;
          }
        },
        error: (_) {
          _refreshTimer?.cancel();
          _refreshTimer = null;
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Order Tracking',
          style: TextStyles.headlineMedium,
        ),
      ),
      body: orderState.when(
        initial: () => const LoadingView(),
        loading: () => const LoadingView(),
        loaded: (order) {
          return RefreshIndicator(
            onRefresh: () => ref.read(orderDetailsNotifierProvider(orderId).notifier).refresh(),
            color: AppColors.primary,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(Insets.md),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Order info card
                _OrderInfoCard(order: order),
                Gaps.lgV,
                // Order items
                _OrderItemsCard(order: order),
                Gaps.lgV,
                // Delivery address
                _DeliveryAddressCard(order: order),
                Gaps.lgV,
                // Order summary
                _OrderSummaryCard(order: order),
                Gaps.lgV,
                // Tracking map
                if (order.tracking.driverLatitude != null &&
                    order.tracking.driverLongitude != null)
                  TrackingMapView(
                    driverLatitude: order.tracking.driverLatitude,
                    driverLongitude: order.tracking.driverLongitude,
                    destinationLatitude: order.address.latitude,
                    destinationLongitude: order.address.longitude,
                  ),
                Gaps.lgV,
                // Driver contact
                if (order.tracking.driverId != null)
                  DriverContactBar(
                    driverId: order.tracking.driverId,
                    driverPhone: order.tracking.driverPhone,
                    driverName: order.tracking.driverName,
                  ),
                Gaps.lgV,
                // Timeline
                Text(
                  'Order Status',
                  style: TextStyles.headlineSmall,
                ),
                if (order.tracking.status == OrderStatus.outForDelivery) ...[
                  Gaps.xsV,
                  Text(
                    'Status updates automatically. Pull down to refresh now.',
                    style: TextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
                Gaps.mdV,
                OrderTimeline(tracking: order.tracking),
                Gaps.lgV,
                // Estimated delivery
                if (order.tracking.estimatedDeliveryTime != null)
                  Container(
                    padding: const EdgeInsets.all(Insets.md),
                    decoration: BoxDecoration(
                      color: AppColors.infoContainer,
                      borderRadius: AppRadius.mdAll,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          color: AppColors.info,
                        ),
                        Gaps.smH,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Estimated Delivery',
                                style: TextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Gaps.xsV,
                              Text(
                                DateFormat('MMM dd, yyyy • hh:mm a').format(
                                  order.tracking.estimatedDeliveryTime!,
                                ),
                                style: TextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                // Delivered: confirm receipt + rate (full UX)
                if (order.tracking.status == OrderStatus.delivered) ...[
                  Gaps.lgV,
                  Container(
                    padding: const EdgeInsets.all(Insets.lg),
                    decoration: BoxDecoration(
                      color: SemanticColors.successContainer,
                      borderRadius: AppRadius.mdAll,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColors.success, size: 32),
                            Gaps.smH,
                            Expanded(
                              child: Text(
                                'Order delivered',
                                style: TextStyles.titleLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (order.tracking.deliveredAt != null) ...[
                          Gaps.xsV,
                          Text(
                            DateFormat('MMM dd, yyyy • hh:mm a').format(
                              order.tracking.deliveredAt!,
                            ),
                            style: TextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                        Gaps.lgV,
                        Text(
                          'Confirm you received your order and rate the experience.',
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Gaps.mdV,
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () => context.push(
                              '${RouteNames.rating}/${order.id}',
                            ),
                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('I received my order – Rate now'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            ),
          );
        },
        error: (message) => ErrorState(
          message: message,
          onRetry: () {
            ref.read(orderDetailsNotifierProvider(orderId).notifier).refresh();
          },
        ),
      ),
    );
  }
}

class _OrderInfoCard extends StatelessWidget {
  final Order order;

  const _OrderInfoCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.elevation2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.orderNumber,
                style: TextStyles.headlineSmall,
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
          Gaps.smV,
          Row(
            children: [
              if (order.vendor.logo != null)
                ClipRRect(
                  borderRadius: AppRadius.smAll,
                  child: CachedNetworkImage(
                    imageUrl: order.vendor.logo!,
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.restaurant),
                  ),
                )
              else
                const Icon(Icons.restaurant, size: 32),
              Gaps.smH,
              Expanded(
                child: Text(
                  order.vendor.name,
                  style: TextStyles.bodyMedium,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrderItemsCard extends StatelessWidget {
  final Order order;

  const _OrderItemsCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.elevation2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items (${order.items.length})',
            style: TextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Gaps.mdV,
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: Insets.sm),
                child: Row(
                  children: [
                    if (item.menuItem.image != null)
                      ClipRRect(
                        borderRadius: AppRadius.smAll,
                        child: CachedNetworkImage(
                          imageUrl: item.menuItem.image!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => Container(
                            width: 50,
                            height: 50,
                            color: AppColors.surface,
                            child: const Icon(Icons.restaurant),
                          ),
                        ),
                      )
                    else
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: AppRadius.smAll,
                        ),
                        child: const Icon(Icons.restaurant),
                      ),
                    Gaps.smH,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.menuItem.name,
                            style: TextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Gaps.xsV,
                          Text(
                            'Quantity: ${item.quantity}',
                            style: TextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${item.price.toStringAsFixed(2)} SAR',
                      style: TextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _DeliveryAddressCard extends StatelessWidget {
  final Order order;

  const _DeliveryAddressCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.elevation2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: AppColors.primary,
                size: IconSizes.md,
              ),
              Gaps.smH,
              Text(
                'Delivery Address',
                style: TextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Gaps.mdV,
          Text(
            order.address.label,
            style: TextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.xsV,
          Text(
            order.address.streetAddress,
            style: TextStyles.bodyMedium,
          ),
          if (order.address.building != null) ...[
            Gaps.xsV,
            Text(
              'Building: ${order.address.building}',
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (order.address.floor != null) ...[
            Gaps.xsV,
            Text(
              'Floor: ${order.address.floor}',
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (order.address.apartment != null) ...[
            Gaps.xsV,
            Text(
              'Apartment: ${order.address.apartment}',
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          Gaps.xsV,
          Text(
            '${order.address.district != null ? '${order.address.district}, ' : ''}${order.address.city}',
            style: TextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final Order order;

  const _OrderSummaryCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.elevation2,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Gaps.mdV,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Subtotal',
                style: TextStyles.bodyMedium,
              ),
              Text(
                '${order.subtotal.toStringAsFixed(2)} SAR',
                style: TextStyles.bodyMedium,
              ),
            ],
          ),
          Gaps.smV,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Delivery Fee',
                style: TextStyles.bodyMedium,
              ),
              Text(
                '${order.deliveryFee.toStringAsFixed(2)} SAR',
                style: TextStyles.bodyMedium,
              ),
            ],
          ),
          Gaps.mdV,
          const Divider(),
          Gaps.mdV,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${order.total.toStringAsFixed(2)} SAR',
                style: TextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
