// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/order.dart';
import '../providers/order_details_notifier.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../../../feed/domain/entities/feed_item.dart';
import '../../../addresses/domain/entities/address.dart';

class OrderConfirmationScreen extends ConsumerWidget {
  final String orderId;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderState = ref.watch(orderDetailsNotifierProvider(orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      body: orderState.when(
        initial: () => const LoadingView(),
        loading: () => const LoadingView(),
        loaded: (order) => _buildConfirmationContent(context, order),
        error: (message) => ErrorState(
          message: message,
          onRetry: () {
            ref.read(orderDetailsNotifierProvider(orderId).notifier).loadOrderDetails();
          },
        ),
      ),
    );
  }

  Widget _buildConfirmationContent(BuildContext context, Order order) {
    final l = AppLocalizations.of(context);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gaps.xxlV,
                // Success icon
                Center(
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: SemanticColors.success.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 80,
                      color: SemanticColors.success,
                    ),
                  ),
                ),
                Gaps.xlV,
                // Title
                Text(
                  l.orderConfirmed,
                  style: TextStyles.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                Gaps.mdV,
                Text(
                  l.orderPlacedSuccess,
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.xlV,
                // Order number card
                Container(
                  padding: const EdgeInsets.all(Insets.xl),
                  decoration: BoxDecoration(
                    color: AppColors.warmSurface,
                    borderRadius: AppRadius.lgAll,
                    boxShadow: AppShadows.elevation2,
                  ),
                  child: Column(
                    children: [
                      Text(
                        l.orderNumberLabel,
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Gaps.smV,
                      Text(
                        order.orderNumber,
                        style: TextStyles.headlineMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.lgV,
                // Vendor info
                _VendorInfoCard(vendor: order.vendor),
                Gaps.lgV,
                // Order summary
                _OrderSummaryCard(order: order, l: l),
                Gaps.lgV,
                // Delivery info
                _DeliveryInfoCard(
                  address: order.address,
                  estimatedDeliveryTime: order.tracking.estimatedDeliveryTime,
                  l: l,
                ),
              ],
            ),
          ),
        ),
        // Action buttons
        Container(
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            boxShadow: AppShadows.elevation4,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PrimaryButton(
                  onPressed: () {
                    context.pushReplacement(
                      '${RouteNames.orderDetails}/${order.id}',
                    );
                  },
                  text: l.trackOrder,
                  width: double.infinity,
                ),
                Gaps.mdV,
                TextButton(
                  onPressed: () {
                    context.go(RouteNames.categories);
                  },
                  child: Text(
                    l.backToFeed,
                    style: TextStyles.button.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _VendorInfoCard extends StatelessWidget {
  final Vendor vendor;

  const _VendorInfoCard({
    required this.vendor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.elevation1,
      ),
      child: Row(
        children: [
          if (vendor.logo != null)
            ClipRRect(
              borderRadius: AppRadius.smAll,
              child: CachedNetworkImage(
                imageUrl: vendor.logo!,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) => Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: AppRadius.smAll,
                  ),
                  child: Icon(
                    Icons.restaurant,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: AppRadius.smAll,
              ),
              child: Icon(
                Icons.restaurant,
                color: AppColors.primary,
              ),
            ),
          Gaps.mdH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vendor.name,
                  style: TextStyles.titleMedium,
                ),
                Gaps.xsV,
                Row(
                  children: [
                    Icon(
                      Icons.star,
                      size: 16,
                      color: AppColors.accent,
                    ),
                    Gaps.xsH,
                    Text(
                      vendor.rating.toStringAsFixed(1),
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderSummaryCard extends StatelessWidget {
  final Order order;
  final AppLocalizations l;

  const _OrderSummaryCard({
    required this.order,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.elevation1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l.orderSummary,
            style: TextStyles.titleMedium,
          ),
          Gaps.mdV,
          const Divider(color: AppColors.warmDivider),
          Gaps.mdV,
          // Items
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: Insets.sm),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity}x ${item.menuItem.name}',
                      style: TextStyles.bodyMedium,
                    ),
                  ),
                  Text(
                    '${(item.price * item.quantity).toStringAsFixed(2)} SAR',
                    style: TextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Gaps.mdV,
          const Divider(color: AppColors.warmDivider),
          Gaps.mdV,
          // Totals
          _SummaryRow(
            label: l.subtotal,
            value: '${order.subtotal.toStringAsFixed(2)} SAR',
          ),
          Gaps.smV,
          _SummaryRow(
            label: l.deliveryFee,
            value: '${order.deliveryFee.toStringAsFixed(2)} SAR',
          ),
          Gaps.mdV,
          const Divider(color: AppColors.warmDivider),
          Gaps.mdV,
          _SummaryRow(
            label: l.total,
            value: '${order.total.toStringAsFixed(2)} SAR',
            style: TextStyles.titleMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? style;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: (style ?? TextStyles.bodyMedium).copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: style ?? TextStyles.bodyMedium,
        ),
      ],
    );
  }
}

class _DeliveryInfoCard extends StatelessWidget {
  final Address address;
  final DateTime? estimatedDeliveryTime;
  final AppLocalizations l;

  const _DeliveryInfoCard({
    required this.address,
    this.estimatedDeliveryTime,
    required this.l,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.elevation1,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                l.deliveryAddress,
                style: TextStyles.titleMedium,
              ),
            ],
          ),
          Gaps.mdV,
          Text(
            address.streetAddress,
            style: TextStyles.bodyMedium,
          ),
          if (address.building != null) ...[
            Gaps.xsV,
            Text(
              '${l.buildingLabel} ${address.building}',
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          if (address.apartment != null) ...[
            Gaps.xsV,
            Text(
              '${l.apartmentLabel} ${address.apartment}',
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          Gaps.xsV,
          Text(
            '${address.city}${address.district != null ? ', ${address.district}' : ''}',
            style: TextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          if (estimatedDeliveryTime != null) ...[
            Gaps.mdV,
            const Divider(color: AppColors.warmDivider),
            Gaps.mdV,
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: AppColors.primary,
                  size: IconSizes.md,
                ),
                Gaps.smH,
                Text(
                  l.estimatedDelivery,
                  style: TextStyles.bodyMedium,
                ),
                const Spacer(),
                Text(
                  DateFormat('HH:mm').format(estimatedDeliveryTime!),
                  style: TextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
