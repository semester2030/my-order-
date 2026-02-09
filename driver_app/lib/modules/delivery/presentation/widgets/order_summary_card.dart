import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../jobs/data/models/active_job_dto.dart';

class OrderSummaryCard extends StatelessWidget {
  final OrderDetails order;

  const OrderSummaryCard({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: TextStyles.titleLarge,
            ),
            Gaps.mdV,
            _buildRow('Order Number', order.orderNumber),
            _buildRow('Vendor', order.vendor.name),
            _buildRow('Total', '${order.total.toStringAsFixed(2)} SAR'),
            Gaps.mdV,
            Text(
              'Items',
              style: TextStyles.titleMedium,
            ),
            Gaps.smV,
            ...order.items.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: Insets.xs),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${item.quantity}x ${item.name}',
                        style: TextStyles.bodyMedium,
                      ),
                      Text(
                        '${(item.price * item.quantity).toStringAsFixed(2)} SAR',
                        style: TextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: TextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
