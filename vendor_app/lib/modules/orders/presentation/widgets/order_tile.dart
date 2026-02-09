import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/modules/orders/domain/entities/order.dart';
import 'package:vendor_app/modules/orders/presentation/widgets/order_status_chip.dart';

/// عنصر قائمة طلب — ثيم موحد (Phase 9).
class OrderTile extends StatelessWidget {
  const OrderTile({
    super.key,
    required this.order,
    this.onTap,
  });

  final Order order;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: InkWell(
        onTap: onTap ?? () => context.push(RouteNames.orderDetail(order.id)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customerName,
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gaps.xsV,
                    Text(
                      Formatters.currency(order.totalAmount),
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Gaps.xsV,
                    Text(
                      '${Formatters.date(order.createdAt)} ${Formatters.time(order.createdAt)}',
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              OrderStatusChip(status: order.status),
            ],
          ),
        ),
      ),
    );
  }
}
