import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../domain/entities/order_tracking.dart';

class OrderTimeline extends StatelessWidget {
  final OrderTracking tracking;

  const OrderTimeline({
    super.key,
    required this.tracking,
  });

  @override
  Widget build(BuildContext context) {
    final steps = _getTimelineSteps();

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == steps.length - 1;

        return _TimelineStep(
          step: step,
          isCompleted: step.isCompleted,
          isCurrent: step.isCurrent,
          isLast: isLast,
        );
      }).toList(),
    );
  }

  List<_TimelineStepData> _getTimelineSteps() {
    return [
      _TimelineStepData(
        title: 'Order Placed',
        isCompleted: tracking.status != OrderStatus.pending,
        isCurrent: tracking.status == OrderStatus.pending,
      ),
      _TimelineStepData(
        title: 'Order Confirmed',
        isCompleted: [
          OrderStatus.confirmed,
          OrderStatus.preparing,
          OrderStatus.ready,
          OrderStatus.outForDelivery,
          OrderStatus.delivered,
        ].contains(tracking.status),
        isCurrent: tracking.status == OrderStatus.confirmed,
      ),
      _TimelineStepData(
        title: 'Preparing',
        isCompleted: [
          OrderStatus.preparing,
          OrderStatus.ready,
          OrderStatus.outForDelivery,
          OrderStatus.delivered,
        ].contains(tracking.status),
        isCurrent: tracking.status == OrderStatus.preparing,
      ),
      _TimelineStepData(
        title: 'Ready',
        isCompleted: [
          OrderStatus.ready,
          OrderStatus.outForDelivery,
          OrderStatus.delivered,
        ].contains(tracking.status),
        isCurrent: tracking.status == OrderStatus.ready,
      ),
      _TimelineStepData(
        title: 'Out for Delivery',
        isCompleted: [
          OrderStatus.outForDelivery,
          OrderStatus.delivered,
        ].contains(tracking.status),
        isCurrent: tracking.status == OrderStatus.outForDelivery,
      ),
      _TimelineStepData(
        title: 'Delivered',
        isCompleted: tracking.status == OrderStatus.delivered,
        isCurrent: tracking.status == OrderStatus.delivered,
      ),
    ];
  }
}

class _TimelineStepData {
  final String title;
  final bool isCompleted;
  final bool isCurrent;

  _TimelineStepData({
    required this.title,
    required this.isCompleted,
    required this.isCurrent,
  });
}

class _TimelineStep extends StatelessWidget {
  final _TimelineStepData step;
  final bool isCompleted;
  final bool isCurrent;
  final bool isLast;

  const _TimelineStep({
    required this.step,
    required this.isCompleted,
    required this.isCurrent,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline indicator
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? AppColors.success
                    : isCurrent
                        ? AppColors.primary
                        : AppColors.border,
                border: Border.all(
                  color: isCompleted || isCurrent
                      ? AppColors.primary
                      : AppColors.border,
                  width: 2,
                ),
              ),
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: AppColors.textInverse,
                    )
                  : null,
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? AppColors.success : AppColors.border,
              ),
          ],
        ),
        Gaps.smH,
        // Step content
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: Insets.xs),
            child: Text(
              step.title,
              style: TextStyles.bodyMedium.copyWith(
                color: isCompleted || isCurrent
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
                fontWeight: isCurrent ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
