import 'package:flutter/material.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/shared/enums/order_status.dart';

/// شريط إجراءات الطلب — قبول، رفض، تحديث حالة (Phase 9).
class OrderActionsBar extends StatelessWidget {
  const OrderActionsBar({
    super.key,
    required this.orderId,
    required this.status,
    required this.onAccept,
    required this.onReject,
    required this.onUpdateStatus,
    this.isLoading = false,
  });

  final String orderId;
  final OrderStatus status;
  final VoidCallback onAccept;
  final VoidCallback onReject;
  final void Function(OrderStatus) onUpdateStatus;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final canAcceptReject = status == OrderStatus.pending;

    return Container(
      padding: EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: const [AppShadows.sm],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (canAcceptReject) ...[
            PrimaryButton(
              label: isLoading ? 'جاري التنفيذ...' : 'قبول الطلب',
              onPressed: isLoading ? null : onAccept,
            ),
            Gaps.mdV,
            OutlinedButton(
              onPressed: isLoading ? null : onReject,
              style: OutlinedButton.styleFrom(
                foregroundColor: SemanticColors.error,
                side: BorderSide(color: SemanticColors.error),
              ),
              child: Text(
                'رفض الطلب',
                style: TextStyles.labelLarge.copyWith(
                  color: SemanticColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
          if (!canAcceptReject &&
              status != OrderStatus.rejected &&
              status != OrderStatus.cancelled &&
              status != OrderStatus.delivered) ...[
            Gaps.mdV,
            Text(
              'تحديث الحالة',
              style: TextStyles.labelMedium.copyWith(color: AppColors.textSecondary),
            ),
            Gaps.smV,
            Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.sm,
              children: [
                if (status != OrderStatus.preparing)
                  _StatusChip(
                    label: OrderStatus.preparing.labelAr,
                    onTap: () => onUpdateStatus(OrderStatus.preparing),
                    isLoading: isLoading,
                  ),
                if (status != OrderStatus.ready)
                  _StatusChip(
                    label: OrderStatus.ready.labelAr,
                    onTap: () => onUpdateStatus(OrderStatus.ready),
                    isLoading: isLoading,
                  ),
                if (status != OrderStatus.delivered)
                  _StatusChip(
                    label: OrderStatus.delivered.labelAr,
                    onTap: () => onUpdateStatus(OrderStatus.delivered),
                    isLoading: isLoading,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: isLoading ? null : onTap,
      backgroundColor: AppColors.primaryContainer,
      side: BorderSide(color: AppColors.primary),
    );
  }
}
