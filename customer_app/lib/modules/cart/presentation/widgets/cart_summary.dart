// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/cart.dart';

class CartSummary extends StatelessWidget {
  final Cart cart;

  const CartSummary({
    super.key,
    required this.cart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.warmSurface,
        borderRadius: AppRadius.topLG,
        boxShadow: AppShadows.elevation3,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Vendor info
          if (cart.vendor != null) ...[
            Row(
              children: [
                if (cart.vendor!.logo != null)
                  ClipRRect(
                    borderRadius: AppRadius.smAll,
                    child: Image.network(
                      cart.vendor!.logo!,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.restaurant),
                    ),
                  )
                else
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer,
                      borderRadius: AppRadius.smAll,
                    ),
                    child: const Icon(
                      Icons.restaurant,
                      color: AppColors.primary,
                    ),
                  ),
                Gaps.smH,
                Expanded(
                  child: Text(
                    cart.vendor!.name,
                    style: TextStyles.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Gaps.lgV,
            const Divider(color: AppColors.warmDivider),
            Gaps.lgV,
          ],
          // Summary
          _SummaryRow(
            label: AppLocalizations.of(context).subtotal,
            value: '${cart.subtotal.toStringAsFixed(2)} SAR',
            style: TextStyles.bodyMedium,
          ),
          Gaps.smV,
          _SummaryRow(
            label: AppLocalizations.of(context).deliveryFee,
            value: '${cart.deliveryFee.toStringAsFixed(2)} SAR',
            style: TextStyles.bodyMedium,
          ),
          Gaps.mdV,
          const Divider(color: AppColors.warmDivider),
          Gaps.mdV,
          _SummaryRow(
            label: AppLocalizations.of(context).total,
            value: '${cart.total.toStringAsFixed(2)} SAR',
            style: TextStyles.headlineMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle style;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: style.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: style,
        ),
      ],
    );
  }
}
