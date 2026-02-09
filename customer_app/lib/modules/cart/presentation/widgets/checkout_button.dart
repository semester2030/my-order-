import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/primary_button.dart';

class CheckoutButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final double total;

  const CheckoutButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Gaps.xsV,
                    Text(
                      '${total.toStringAsFixed(2)} SAR',
                      style: TextStyles.headlineMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: Insets.lg),
                    child: PrimaryButton(
                      onPressed: onPressed,
                      isLoading: isLoading,
                      text: 'Checkout',
                      width: double.infinity,
                    ),
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
