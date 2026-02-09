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
                  child: Icon(
                    Icons.delivery_dining,
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
                  'Driver App',
                  style: TextStyles.displayMedium.copyWith(
                    color: AppColors.textInverse,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.mdV,
                
                // Subtitle
                Text(
                  'تطبيق السائقين',
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
                  icon: Icons.local_shipping,
                  title: 'توصيل سريع',
                  subtitle: 'وصل الطلبات في أسرع وقت',
                ),
                Gaps.mdV,
                
                _buildFeature(
                  icon: Icons.attach_money,
                  title: 'أرباح جيدة',
                  subtitle: 'اكسب من كل توصيلة',
                ),
                Gaps.mdV,
                
                _buildFeature(
                  icon: Icons.schedule,
                  title: 'مرونة في الوقت',
                  subtitle: 'اعمل في الوقت الذي يناسبك',
                ),
                Gaps.xlV,
                
                // Login Button (for existing users)
                PrimaryButton(
                  text: 'تسجيل الدخول',
                  icon: Icons.login,
                  onPressed: () {
                    context.push(RouteNames.phoneInput);
                  },
                  width: double.infinity,
                ),
                Gaps.mdV,
                
                // Join Us Button (for new users)
                OutlinedButton(
                  onPressed: () {
                    context.push(RouteNames.registerStep1);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.textInverse,
                    side: BorderSide(color: AppColors.textInverse, width: 2),
                    padding: EdgeInsets.symmetric(
                      horizontal: Insets.xl,
                      vertical: Insets.md,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mdAll,
                    ),
                    minimumSize: Size(double.infinity, 56),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add, color: AppColors.textInverse),
                      Gaps.mdH,
                      Text(
                        'انضم إلينا',
                        style: TextStyles.bodyLarge.copyWith(
                          color: AppColors.textInverse,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
