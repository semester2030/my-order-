// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/error_state.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/payment.dart';
import '../providers/payment_notifier.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String orderId;
  final double amount;

  const PaymentScreen({
    super.key,
    required this.orderId,
    required this.amount,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentMethod? _selectedMethod;

  @override
  Widget build(BuildContext context) {
    final paymentState = ref.watch(paymentNotifierProvider(widget.orderId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Payment',
          style: TextStyles.titleLarge,
        ),
        backgroundColor: AppColors.surfaceElevated,
        elevation: 0,
      ),
      body: paymentState.when(
        initial: () => _buildPaymentMethods(),
        initiating: () => const LoadingView(),
        initiated: (payment) => _buildPaymentConfirmation(payment),
        confirming: () => const LoadingView(),
        confirmed: (payment) => _buildPaymentSuccess(payment),
        error: (message) => ErrorState(
          message: message,
          onRetry: () {
            ref.read(paymentNotifierProvider(widget.orderId).notifier).reset();
          },
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Amount display
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
                        'Total Amount',
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Gaps.mdV,
                      Text(
                        '${widget.amount.toStringAsFixed(2)} SAR',
                        style: TextStyles.headlineLarge.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.xlV,
                // Payment methods
                Text(
                  'Select Payment Method',
                  style: TextStyles.titleMedium,
                ),
                Gaps.lgV,
                _PaymentMethodTile(
                  method: PaymentMethod.applePay,
                  title: 'Apple Pay',
                  icon: Icons.apple,
                  isSelected: _selectedMethod == PaymentMethod.applePay,
                  onTap: () {
                    setState(() {
                      _selectedMethod = PaymentMethod.applePay;
                    });
                  },
                ),
                Gaps.mdV,
                _PaymentMethodTile(
                  method: PaymentMethod.mada,
                  title: 'Mada',
                  icon: Icons.credit_card,
                  isSelected: _selectedMethod == PaymentMethod.mada,
                  onTap: () {
                    setState(() {
                      _selectedMethod = PaymentMethod.mada;
                    });
                  },
                ),
                Gaps.mdV,
                _PaymentMethodTile(
                  method: PaymentMethod.stcPay,
                  title: 'STC Pay',
                  icon: Icons.account_balance_wallet,
                  isSelected: _selectedMethod == PaymentMethod.stcPay,
                  onTap: () {
                    setState(() {
                      _selectedMethod = PaymentMethod.stcPay;
                    });
                  },
                ),
                Gaps.mdV,
                _PaymentMethodTile(
                  method: PaymentMethod.cash,
                  title: 'Cash on Delivery',
                  icon: Icons.money,
                  isSelected: _selectedMethod == PaymentMethod.cash,
                  onTap: () {
                    setState(() {
                      _selectedMethod = PaymentMethod.cash;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        // Continue button
        Container(
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            boxShadow: AppShadows.elevation4,
          ),
          child: SafeArea(
            top: false,
            child: PrimaryButton(
              onPressed: _selectedMethod != null ? _handleInitiatePayment : null,
              text: 'Continue',
              width: double.infinity,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentConfirmation(Payment payment) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Payment info
                Container(
                  padding: const EdgeInsets.all(Insets.xl),
                  decoration: BoxDecoration(
                    color: AppColors.warmSurface,
                    borderRadius: AppRadius.lgAll,
                    boxShadow: AppShadows.elevation2,
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.payment,
                        size: 64,
                        color: AppColors.primary,
                      ),
                      Gaps.lgV,
                      Text(
                        'Payment Initiated',
                        style: TextStyles.titleLarge,
                      ),
                      Gaps.mdV,
                      Text(
                        '${payment.amount.toStringAsFixed(2)} SAR',
                        style: TextStyles.headlineMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.smV,
                      Text(
                        _getPaymentMethodName(payment.method),
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Gaps.xlV,
                // Instructions
                Text(
                  'Please complete the payment using your selected method.',
                  style: TextStyles.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                Gaps.lgV,
                // Transaction ID (if available)
                if (payment.transactionId != null) ...[
                  Container(
                    padding: const EdgeInsets.all(Insets.md),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceElevated,
                      borderRadius: AppRadius.mdAll,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.receipt,
                          size: IconSizes.md,
                          color: AppColors.textSecondary,
                        ),
                        Gaps.smH,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Transaction ID',
                                style: TextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Gaps.xsV,
                              Text(
                                payment.transactionId!,
                                style: TextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        // Confirm button
        Container(
          padding: const EdgeInsets.all(Insets.lg),
          decoration: BoxDecoration(
            color: AppColors.surfaceElevated,
            boxShadow: AppShadows.elevation4,
          ),
          child: SafeArea(
            top: false,
            child: PrimaryButton(
              onPressed: () => _handleConfirmPayment(payment),
              text: 'Confirm Payment',
              width: double.infinity,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentSuccess(Payment payment) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
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
            Gaps.xlV,
            Text(
              'Payment Successful!',
              style: TextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Gaps.mdV,
            Text(
              'Your payment of ${payment.amount.toStringAsFixed(2)} SAR has been processed successfully.',
              style: TextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Gaps.xlV,
            PrimaryButton(
              onPressed: () {
                // Navigate to order confirmation
                context.pushReplacement(
                  '${RouteNames.orderConfirmation}/${widget.orderId}',
                );
              },
              text: 'View Order',
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }

  void _handleInitiatePayment() {
    if (_selectedMethod == null) return;

    // For cash payment, go directly to order confirmation
    if (_selectedMethod == PaymentMethod.cash) {
      context.pushReplacement(
        '${RouteNames.orderConfirmation}/${widget.orderId}',
      );
      return;
    }

    // For other payment methods, initiate payment flow
    final methodValue = _selectedMethod!.value;
    ref.read(paymentNotifierProvider(widget.orderId).notifier).initiatePayment(methodValue);
  }

  void _handleConfirmPayment(Payment payment) {
    // In a real app, this would get the transaction ID from the payment gateway
    // For now, we'll use a mock transaction ID
    final transactionId = payment.transactionId ?? 'txn_${DateTime.now().millisecondsSinceEpoch}';
    
    ref.read(paymentNotifierProvider(widget.orderId).notifier).confirmPayment(
      payment.id,
      transactionId,
    );
  }

  String _getPaymentMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.applePay:
        return 'Apple Pay';
      case PaymentMethod.mada:
        return 'Mada';
      case PaymentMethod.stcPay:
        return 'STC Pay';
      case PaymentMethod.cash:
        return 'Cash on Delivery';
    }
  }
}

class _PaymentMethodTile extends StatelessWidget {
  final PaymentMethod method;
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodTile({
    required this.method,
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: Container(
        padding: const EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : AppColors.surfaceElevated,
          borderRadius: AppRadius.mdAll,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.warmDivider,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected ? AppShadows.elevation2 : null,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.primaryContainer,
                borderRadius: AppRadius.smAll,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.textOnPrimary
                    : AppColors.primary,
                size: IconSizes.lg,
              ),
            ),
            Gaps.mdH,
            Expanded(
              child: Text(
                title,
                style: TextStyles.titleMedium.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                ),
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.primary,
                size: IconSizes.md,
              ),
          ],
        ),
      ),
    );
  }
}
