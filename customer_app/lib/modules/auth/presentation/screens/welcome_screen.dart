// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/branded_logo.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/localization/app_localizations.dart';
import '../providers/guest_mode_notifier.dart';

class WelcomeScreen extends ConsumerWidget {
  const WelcomeScreen({super.key});

  Future<void> _startGuestBrowse(BuildContext context, WidgetRef ref) async {
    await ref.read(guestModeProvider.notifier).enable();
    if (context.mounted) context.go(RouteNames.categories);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Insets.lg,
              vertical: Insets.xl,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BrandedLogo(
                  assetPath: 'assets/images/icons/logo.jpeg',
                  size: 280,
                  cornerRadius: 140,
                  tileColor: Colors.white,
                ),
                Gaps.xlV,
                Text(
                  l.welcomeTo,
                  style: TextStyles.headlineLarge.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.smV,
                Text(
                  l.appName,
                  style: TextStyles.displayMedium.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.mdV,
                Text(
                  l.premiumFoodDelivery,
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.textInverse.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.xxlV,
                PrimaryButton(
                  text: l.register,
                  icon: Icons.person_add_outlined,
                  onPressed: () => context.go(RouteNames.register),
                  width: double.infinity,
                ),
                Gaps.smV,
                OutlinedButton(
                  onPressed: () => context.go(RouteNames.login),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textInverse,
                    side: BorderSide(
                      color: AppColors.textInverse.withValues(alpha: 0.7),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: Insets.md),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.login, size: 20, color: AppColors.textInverse),
                      Gaps.smH,
                      Text(l.login),
                    ],
                  ),
                ),
                Gaps.lgV,
                const Divider(color: Colors.white24),
                Gaps.mdV,
                Text(
                  l.browseAsGuestSubtitle,
                  style: TextStyles.bodySmall.copyWith(
                    color: AppColors.textInverse.withValues(alpha: 0.85),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.mdV,
                OutlinedButton.icon(
                  onPressed: () => _startGuestBrowse(context, ref),
                  icon: const Icon(Icons.explore_outlined, color: AppColors.textInverse),
                  label: Text(l.browseAsGuest),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textInverse,
                    side: const BorderSide(color: Colors.white54),
                    padding: const EdgeInsets.symmetric(
                      vertical: Insets.md,
                      horizontal: Insets.lg,
                    ),
                  ),
                ),
                Gaps.lgV,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
