import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/widgets/branded_logo.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';

/// معاينة احترافية لميزات تطبيق المزوّد — بدون تسجيل (متطلب App Store).
class ExploreAppScreen extends StatelessWidget {
  const ExploreAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(l.exploreApp, style: TextStyles.titleLarge),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: BrandedLogo(
                  assetPath: 'assets/images/logo.jpeg',
                  size: 120,
                  cornerRadius: 60,
                ),
              ),
              Gaps.mdV,
              Text(
                l.vendorExploreTitle,
                style: TextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.smV,
              Text(
                l.vendorExploreSubtitle,
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.xlV,
              _FeatureCard(
                icon: Icons.receipt_long_outlined,
                title: l.exploreFeatureOrdersTitle,
                description: l.exploreFeatureOrdersDesc,
              ),
              Gaps.mdV,
              _FeatureCard(
                icon: Icons.videocam_outlined,
                title: l.exploreFeatureVideosTitle,
                description: l.exploreFeatureVideosDesc,
              ),
              Gaps.mdV,
              _FeatureCard(
                icon: Icons.restaurant_menu_outlined,
                title: l.exploreFeatureMenuTitle,
                description: l.exploreFeatureMenuDesc,
              ),
              Gaps.mdV,
              _FeatureCard(
                icon: Icons.event_available_outlined,
                title: l.exploreFeatureBookingsTitle,
                description: l.exploreFeatureBookingsDesc,
              ),
              Gaps.mdV,
              _FeatureCard(
                icon: Icons.insights_outlined,
                title: l.exploreFeatureAnalyticsTitle,
                description: l.exploreFeatureAnalyticsDesc,
              ),
              Gaps.xxlV,
              Text(
                l.exploreReadyToJoin,
                style: TextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.mdV,
              PrimaryButton(
                label: l.register,
                onPressed: () => context.go(RouteNames.register),
              ),
              Gaps.smV,
              OutlinedButton(
                onPressed: () => context.go(RouteNames.login),
                child: Text(l.login),
              ),
              Gaps.mdV,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () => context.push(RouteNames.privacyPolicy),
                    child: Text(l.privacyPolicy),
                  ),
                  Text('•', style: TextStyles.bodySmall),
                  TextButton(
                    onPressed: () => context.push(RouteNames.terms),
                    child: Text(l.termsConditions),
                  ),
                ],
              ),
              Gaps.lgV,
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.warmDivider.withValues(alpha: 0.7)),
        boxShadow: const [AppShadows.sm],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer.withValues(alpha: 0.55),
              borderRadius: AppRadius.mdAll,
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          Gaps.mdH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.titleSmall),
                Gaps.xsV,
                Text(
                  description,
                  style: TextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
