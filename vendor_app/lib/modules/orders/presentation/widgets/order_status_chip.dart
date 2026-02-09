import 'package:flutter/material.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/shared/enums/order_status.dart';

/// شارة حالة الطلب — ثيم موحد (Phase 9).
class OrderStatusChip extends StatelessWidget {
  const OrderStatusChip({
    super.key,
    required this.status,
  });

  final OrderStatus status;

  Color get _color {
    switch (status) {
      case OrderStatus.pending:
        return SemanticColors.warning;
      case OrderStatus.accepted:
      case OrderStatus.preparing:
        return AppColors.primary;
      case OrderStatus.ready:
        return SemanticColors.info;
      case OrderStatus.delivered:
        return SemanticColors.success;
      case OrderStatus.rejected:
      case OrderStatus.cancelled:
        return SemanticColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: AppRadius.smAll,
        border: Border.all(color: _color.withValues(alpha: 0.5)),
      ),
      child: Text(
        status.labelAr,
        style: TextStyles.labelSmall.copyWith(
          color: _color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
