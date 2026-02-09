import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../jobs/presentation/providers/jobs_notifier.dart';
import '../../../jobs/presentation/providers/jobs_state.dart';

class DeliveredScreen extends ConsumerStatefulWidget {
  /// Passed when driver just marked delivered from Active Delivery (so we don't call API again).
  final Map<String, dynamic>? deliveredSummary;

  const DeliveredScreen({super.key, this.deliveredSummary});

  @override
  ConsumerState<DeliveredScreen> createState() => _DeliveredScreenState();
}

class _DeliveredScreenState extends ConsumerState<DeliveredScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.deliveredSummary == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(activeJobNotifierProvider.notifier).getActiveJob();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final summary = widget.deliveredSummary;
    if (summary != null) {
      return _buildDeliveredBody(
        orderNumber: summary['orderNumber'] as String? ?? '',
        driverEarnings: (summary['driverEarnings'] as num?)?.toDouble() ?? 0,
        deliveryFee: (summary['deliveryFee'] as num?)?.toDouble() ?? 0,
        vendorName: summary['vendorName'] as String? ?? '',
        total: (summary['total'] as num?)?.toDouble() ?? 0,
        itemsCount: (summary['itemsCount'] as int?) ?? 0,
      );
    }

    final activeJobState = ref.watch(activeJobNotifierProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Delivered', style: TextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: switch (activeJobState) {
        ActiveJobEmpty() => _buildCompletedNoJob(),
        ActiveJobLoaded(:final job) => _buildDeliveredBody(
            orderNumber: job.orderNumber,
            driverEarnings: job.driverEarnings,
            deliveryFee: job.deliveryFee,
            vendorName: job.order.vendor.name,
            total: job.order.total,
            itemsCount: job.order.items.length,
          ),
        _ => const Center(child: CircularProgressIndicator()),
      },
    );
  }

  Widget _buildDeliveredBody({
    required String orderNumber,
    required double driverEarnings,
    required double deliveryFee,
    required String vendorName,
    required double total,
    required int itemsCount,
  }) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Delivered', style: TextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.lgAll,
              ),
              child: Padding(
                padding: const EdgeInsets.all(Insets.xl),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 100,
                      color: SemanticColors.success,
                    ),
                    Gaps.lgV,
                    Text(
                      'Order Delivered!',
                      style: TextStyles.headlineLarge.copyWith(
                        color: SemanticColors.success,
                      ),
                    ),
                    Gaps.smV,
                    Text(
                      'Order #$orderNumber',
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Gaps.lgV,
                    Container(
                      padding: const EdgeInsets.all(Insets.md),
                      decoration: BoxDecoration(
                        color: SemanticColors.successContainer,
                        borderRadius: AppRadius.mdAll,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.attach_money,
                            color: SemanticColors.success,
                          ),
                          Gaps.smH,
                          Text(
                            'Earned: ${driverEarnings.toStringAsFixed(2)} SAR',
                            style: TextStyles.titleMedium.copyWith(
                              color: SemanticColors.success,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gaps.xlV,
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.lgAll,
              ),
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
                    _buildDetailRow('Vendor', vendorName),
                    _buildDetailRow('Items', '$itemsCount items'),
                    _buildDetailRow('Total', '${total.toStringAsFixed(2)} SAR'),
                    _buildDetailRow('Delivery Fee', '${deliveryFee.toStringAsFixed(2)} SAR'),
                  ],
                ),
              ),
            ),
            Gaps.xlV,
            PrimaryButton(
              onPressed: () => context.go(RouteNames.jobs),
              text: 'Back to Jobs',
              icon: Icons.work_outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedNoJob() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle,
              size: 80,
              color: SemanticColors.success,
            ),
            Gaps.lgV,
            Text(
              'Delivery completed',
              style: TextStyles.headlineMedium,
            ),
            Gaps.smV,
            Text(
              'You can accept new jobs now.',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Gaps.xlV,
            PrimaryButton(
              onPressed: () => context.go(RouteNames.jobs),
              text: 'Back to Jobs',
              icon: Icons.work_outline,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
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
