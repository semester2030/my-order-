import 'package:flutter/material.dart';
import 'package:vendor_app/core/theme/design_system.dart';

/// بطاقة ملخص الطلبات — ثيم موحد.
class OrdersSummaryCard extends StatelessWidget {
  const OrdersSummaryCard({
    super.key,
    required this.pendingCount,
    required this.completedCount,
  });

  final int pendingCount;
  final int completedCount;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgAll,
        side: BorderSide(color: AppColors.border, width: 1),
      ),
      child: Padding(
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ملخص الطلبات',
              style: TextStyles.headlineSmall.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            Gaps.mdV,
            Row(
              children: [
                Expanded(
                  child: _StatRow(
                    label: 'قيد الانتظار',
                    value: '$pendingCount',
                    color: SemanticColors.warning,
                  ),
                ),
                Gaps.mdH,
                Expanded(
                  child: _StatRow(
                    label: 'مكتملة',
                    value: '$completedCount',
                    color: SemanticColors.success,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Gaps.xsV,
        Text(
          value,
          style: TextStyles.titleMedium.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
