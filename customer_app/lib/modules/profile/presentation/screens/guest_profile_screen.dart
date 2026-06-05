import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/guest_mode_notifier.dart';

/// بروفايل مبسّط للزائر — بدون استدعاء API.
class GuestProfileScreen extends ConsumerWidget {
  const GuestProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Insets.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(Insets.lg),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.45),
              borderRadius: AppRadius.lgAll,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.explore_outlined, color: AppColors.primary, size: 32),
                Gaps.mdV,
                Text(l.guestProfileTitle, style: TextStyles.titleLarge),
                Gaps.smV,
                Text(
                  l.guestProfileSubtitle,
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
          Gaps.xlV,
          PrimaryButton(
            text: l.login,
            icon: Icons.login,
            onPressed: () => context.push(RouteNames.login),
          ),
          Gaps.smV,
          OutlinedButton(
            onPressed: () => context.push(RouteNames.register),
            child: Text(l.register),
          ),
          Gaps.xlV,
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l.privacyPolicy),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(RouteNames.privacyPolicy),
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(l.termsConditions),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(RouteNames.terms),
          ),
          Gaps.lgV,
          TextButton(
            onPressed: () async {
              await ref.read(guestModeProvider.notifier).disable();
              if (context.mounted) context.go(RouteNames.welcome);
            },
            child: Text(l.guestExitBrowse),
          ),
        ],
      ),
    );
  }
}
