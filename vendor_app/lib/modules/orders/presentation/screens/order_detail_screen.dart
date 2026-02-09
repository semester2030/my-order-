import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/shared/enums/order_status.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/core/widgets/error_state.dart';
import 'package:vendor_app/core/widgets/loading_view.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/orders/domain/entities/order.dart';
import 'package:vendor_app/modules/orders/presentation/providers/order_detail_state.dart';
import 'package:vendor_app/modules/orders/presentation/widgets/order_actions_bar.dart';
import 'package:vendor_app/modules/orders/presentation/widgets/order_status_chip.dart';

/// شاشة تفاصيل الطلب — ثيم موحد (Phase 9).
class OrderDetailScreen extends ConsumerStatefulWidget {
  const OrderDetailScreen({super.key, required this.orderId});

  final String orderId;

  @override
  ConsumerState<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends ConsumerState<OrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(orderDetailNotifierProvider.notifier).loadOrder(widget.orderId);
    });
  }

  Future<void> _accept() async {
    final ok = await ref.read(orderDetailNotifierProvider.notifier).acceptOrder(widget.orderId);
    if (!mounted) return;
    if (ok) {
      ref.invalidate(ordersNotifierProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('تم قبول الطلب'), backgroundColor: SemanticColors.success),
      );
    } else {
      _showError();
    }
  }

  Future<void> _reject() async {
    final reason = await _showRejectReasonDialog();
    if (!mounted) return;
    if (reason == null) return;
    final ok = await ref.read(orderDetailNotifierProvider.notifier).rejectOrder(widget.orderId, reason: reason);
    if (!mounted) return;
    if (ok) {
      ref.invalidate(ordersNotifierProvider);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: const Text('تم رفض الطلب'), backgroundColor: SemanticColors.warning),
      );
    } else {
      _showError();
    }
  }

  Future<String?> _showRejectReasonDialog() async {
    final controller = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('سبب الرفض'),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'أدخل سبب الرفض (5 أحرف على الأقل)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (v) {
              if (v == null || v.trim().length < 5) return 'السبب 5 أحرف على الأقل';
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop<String?>(null),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.of(ctx).pop<String?>(controller.text.trim());
              }
            },
            child: const Text('رفض الطلب'),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  void _showError() {
    final state = ref.read(orderDetailNotifierProvider);
    if (state is OrderDetailError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: SemanticColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(orderDetailNotifierProvider);

    if (state is OrderDetailLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          title: Text(
            'تفاصيل الطلب',
            style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
          ),
        ),
        body: const Center(child: LoadingView()),
      );
    }

    if (state is OrderDetailError) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          title: Text(
            'تفاصيل الطلب',
            style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
          ),
        ),
        body: ErrorState(
          message: state.message,
          onRetry: () => ref.read(orderDetailNotifierProvider.notifier).loadOrder(widget.orderId),
        ),
      );
    }

    if (state is OrderDetailLoaded || state is OrderDetailSaving) {
      final order = state is OrderDetailLoaded
          ? state.order
          : (state as OrderDetailSaving).order;
      final saving = state is OrderDetailSaving;
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          title: Text(
            'تفاصيل الطلب',
            style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: Insets.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Gaps.lgV,
                    _buildInfoCard(order),
                    Gaps.lgV,
                    _buildItemsSection(order),
                    Gaps.xlV,
                  ],
                ),
              ),
            ),
            OrderActionsBar(
              orderId: order.id,
              status: order.status,
              isLoading: saving,
              onAccept: _accept,
              onReject: _reject,
              onUpdateStatus: (OrderStatus newStatus) async {
                final messenger = ScaffoldMessenger.of(context);
                final ok = await ref
                    .read(orderDetailNotifierProvider.notifier)
                    .updateOrderStatus(widget.orderId, newStatus);
                if (!mounted) return;
                if (ok) {
                  messenger.showSnackBar(
                    SnackBar(
                      content: Text('تم تحديث الحالة إلى ${newStatus.labelAr}'),
                      backgroundColor: SemanticColors.success,
                    ),
                  );
                } else {
                  _showError();
                }
              },
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'تفاصيل الطلب',
          style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: const Center(child: LoadingView()),
    );
  }

  Widget _buildInfoCard(Order order) {
    return Container(
      padding: EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        boxShadow: const [AppShadows.sm],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.customerName,
                style: TextStyles.headlineSmall.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              OrderStatusChip(status: order.status),
            ],
          ),
          Gaps.mdV,
          if (order.customerPhone != null)
            Text(
              order.customerPhone!,
              style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
            ),
          Gaps.xsV,
          Text(
            '${Formatters.date(order.createdAt)} ${Formatters.time(order.createdAt)}',
            style: TextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
          ),
          Gaps.mdV,
          Text(
            Formatters.currency(order.totalAmount),
            style: TextStyles.titleMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (order.notes != null && order.notes!.isNotEmpty) ...[
            Gaps.mdV,
            Text(
              'ملاحظات: ${order.notes}',
              style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildItemsSection(Order order) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'العناصر',
          style: TextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Gaps.mdV,
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: AppRadius.lgAll,
            boxShadow: const [AppShadows.sm],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: order.items.length,
            separatorBuilder: (_, __) => Divider(height: 1, color: AppColors.divider),
            itemBuilder: (context, index) {
              final item = order.items[index];
              return Padding(
                padding: EdgeInsets.all(Insets.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${item.quantity} × ${Formatters.currency(item.unitPrice)}',
                            style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      Formatters.currency(item.subtotal),
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
