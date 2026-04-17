import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/bootstrap/app_bootstrapper.dart';
import 'package:vendor_app/core/widgets/branded_logo.dart';
import 'package:vendor_app/core/widgets/loading_view.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';

/// Splash screen — ثيم موحد. يشغّل الـ Bootstrap ثم يوجّه حسب الجلسة (Login / Pending / Rejected / Shell).
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 450), () {
      if (mounted) {
        runAppBootstrap(context, ref);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BrandedLogo(
                assetPath: 'assets/images/logo.jpeg',
                size: 260,
                cornerRadius: 130,
              ),
              Gaps.lgV,
              Text(
                l.appTitle,
                style: TextStyles.headlineLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gaps.lgV,
              Text(
                l.splashTagline,
                style: TextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Gaps.xlV,
              const LoadingView(),
            ],
          ),
        ),
      ),
    );
  }
}
