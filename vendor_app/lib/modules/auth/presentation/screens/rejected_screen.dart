import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/auth/presentation/providers/session_state.dart';

/// شاشة "تم رفض الطلب" — ثيم موحد (design_system).
class RejectedScreen extends ConsumerWidget {
  const RejectedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessionState = ref.watch(sessionNotifierProvider);
    final reason = sessionState is SessionRejected ? sessionState.reason : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'تم رفض الطلب',
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
                Icons.cancel_outlined,
                size: IconSizes.xxl,
                color: SemanticColors.error,
              ),
              Gaps.xlV,
              Text(
                'عذراً، لم تتم الموافقة على طلبك',
                textAlign: TextAlign.center,
                style: TextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              Gaps.mdV,
              Text(
                reason ?? 'يمكنك التواصل مع الدعم للمزيد من التفاصيل.',
                textAlign: TextAlign.center,
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Gaps.xxlV,
              ElevatedButton(
                onPressed: () => context.go(RouteNames.login),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                ),
                child: Text(
                  'العودة لتسجيل الدخول',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textOnPrimary,
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
