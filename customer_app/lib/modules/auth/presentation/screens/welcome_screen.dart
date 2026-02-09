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
            padding: EdgeInsets.symmetric(
              horizontal: Insets.lg,
              vertical: Insets.xl,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.textInverse,
                    borderRadius: AppRadius.fullAll,
                  ),
                  child: const Icon(
                    Icons.restaurant,
                    size: 70,
                    color: AppColors.primary,
                  ),
                ),
                Gaps.xlV,
                
                // Title
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
                
                // Subtitle
                Text(
                  'توصيل طعام مميز',
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.textInverse.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.xsV,
                
                Text(
                  'Premium Food Delivery',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textInverse.withValues(alpha: 0.8),
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.xlV,
                
                // Features
                _buildFeature(
                  icon: Icons.video_library,
                  title: 'مقاطع فيديو عالية الجودة',
                  subtitle: 'شاهد طعامك قبل الطلب',
                ),
                Gaps.mdV,
                
                _buildFeature(
                  icon: Icons.local_shipping,
                  title: 'توصيل سريع',
                  subtitle: 'وصول طلبك في أسرع وقت',
                ),
                Gaps.mdV,
                
                _buildFeature(
                  icon: Icons.star,
                  title: 'مطاعم مميزة',
                  subtitle: 'أفضل المطاعم في مدينتك',
                ),
                Gaps.xlV,
                // تسجيل الدخول للمستخدمين الحاليين (بريد/جوال + رمز سري فقط)
                TextButton(
                  onPressed: () => context.go(RouteNames.loginIdentifier),
                  child: Text(
                    'لديك حساب؟ تسجيل الدخول',
                    style: TextStyles.bodyLarge.copyWith(
                      color: AppColors.textInverse.withValues(alpha: 0.95),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Gaps.mdV,
                // تسجيل بالبريد أو رقم الجوال (مستخدمون جدد)
                Text(
                  'سجّل دخولك بـ',
                  style: TextStyles.titleMedium.copyWith(
                    color: AppColors.textInverse.withValues(alpha: 0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.mdV,
                PrimaryButton(
                  text: 'البريد الإلكتروني',
                  icon: Icons.email_outlined,
                  onPressed: () {
                    context.go(RouteNames.emailInput);
                  },
                  width: double.infinity,
                ),
                Gaps.smV,
                OutlinedButton(
                  onPressed: () {
                    context.go(RouteNames.phoneInput);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textInverse,
                    side: BorderSide(color: AppColors.textInverse.withValues(alpha: 0.7)),
                    padding: EdgeInsets.symmetric(vertical: Insets.md),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone_android, size: 20, color: AppColors.textInverse),
                      Gaps.smH,
                      Text('رقم الجوال'),
                    ],
                  ),
                ),
                Gaps.lgV, // Extra space at bottom
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.textInverse.withValues(alpha: 0.2),
            borderRadius: AppRadius.mdAll,
          ),
          child: Icon(
            icon,
            color: AppColors.textInverse,
            size: 24,
          ),
        ),
        Gaps.mdH,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyles.bodyLarge.copyWith(
                  color: AppColors.textInverse,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.xsV,
              Text(
                subtitle,
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textInverse.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
