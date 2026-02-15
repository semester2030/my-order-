// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/localization/app_localizations.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.paymentMethods,
          style: TextStyles.titleLarge,
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 3),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                context.push(RouteNames.addCard);
              },
              icon: Icon(Icons.add_card),
              label: Text(l10n.addPaymentCard),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: Insets.lg,
                  vertical: Insets.md,
                ),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
            ),
            Gaps.xlV,
            Text(
              l10n.savedPaymentMethods,
              style: TextStyles.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Gaps.mdV,
            _PaymentMethodCard(
              icon: Icons.apple,
              title: 'Apple Pay',
              subtitle: l10n.connected,
              onTap: () {
                // TODO: Manage Apple Pay
              },
            ),
            Gaps.smV,
            _PaymentMethodCard(
              icon: Icons.credit_card,
              title: 'Mada',
              subtitle: l10n.noCardsSaved,
              onTap: () {
                context.push(RouteNames.addCard);
              },
            ),
            Gaps.smV,
            _PaymentMethodCard(
              icon: Icons.account_balance_wallet,
              title: 'STC Pay',
              subtitle: l10n.notConnected,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.comingSoon),
                    backgroundColor: AppColors.info,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _PaymentMethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: Container(
        padding: const EdgeInsets.all(Insets.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppRadius.mdAll,
          boxShadow: AppShadows.elevation1,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: IconSizes.lg,
            ),
            Gaps.mdH,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.titleMedium,
                  ),
                  Gaps.xsV,
                  Text(
                    subtitle,
                    style: TextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}
