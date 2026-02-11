// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.xl),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.textInverse,
                    borderRadius: AppRadius.fullAll,
                  ),
                  child: const Icon(Icons.restaurant, size: 70, color: AppColors.primary),
                ),
                Gaps.xlV,
                Text(
                  'مرحباً بك في',
                  style: TextStyles.headlineLarge.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.smV,
                Text(
                  'My Order',
                  style: TextStyles.displayMedium.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.mdV,
                Text(
                  'توصيل طعام مميز',
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.textInverse.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.xxlV,
                PrimaryButton(
                  text: 'إنشاء حساب',
                  icon: Icons.person_add_outlined,
                  onPressed: () => context.go(RouteNames.register),
                  width: double.infinity,
                ),
                Gaps.smV,
                OutlinedButton(
                  onPressed: () => context.go(RouteNames.login),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textInverse,
                    side: BorderSide(color: AppColors.textInverse.withValues(alpha: 0.7)),
                    padding: const EdgeInsets.symmetric(vertical: Insets.md),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.login, size: 20, color: AppColors.textInverse),
                      Gaps.smH,
                      const Text('تسجيل الدخول'),
                    ],
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
