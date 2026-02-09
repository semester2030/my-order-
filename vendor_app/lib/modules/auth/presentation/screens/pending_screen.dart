import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/auth/presentation/providers/session_state.dart';

/// شاشة "في انتظار الموافقة" — ثيم موحد (design_system).
class PendingScreen extends ConsumerWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionNotifierProvider);
    final message = sessionState is SessionPending ? sessionState.message : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'في انتظار الموافقة',
          style: TextStyles.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.schedule,
                size: IconSizes.xxl,
                color: AppColors.primary,
              ),
              Gaps.xlV,
              Text(
                'طلبك قيد المراجعة',
                style: TextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Gaps.mdV,
              Text(
                message ?? 'جاري مراجعة بياناتك. سنعلمك عند الموافقة.',
                textAlign: TextAlign.center,
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Gaps.xxlV,
              OutlinedButton(
                onPressed: () => context.go(RouteNames.login),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                ),
                child: Text(
                  'العودة لتسجيل الدخول',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
