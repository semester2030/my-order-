// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/branded_logo.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/localization/app_localizations.dart';
import '../providers/auth_notifier.dart';
import '../../utils/navigation_helper.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) _checkAuthAndNavigate();
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    if (_hasNavigated || !mounted) return;
    // لا انتظار ثابت — التحقق فوراً بعد 500ms من initState
    var authState = ref.read(authNotifierProvider);
    int waitCount = 0;
    bool isResolved = authState.when(
      initial: () => false,
      loading: () => false,
      authenticated: (_) => true,
      unauthenticated: () => true,
      error: (_) => true,
    );
    // انتظار حتى 90 ثانية لاستيعاب Render cold start
    while (!isResolved && waitCount < 900) {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted || _hasNavigated) return;
      authState = ref.read(authNotifierProvider);
      isResolved = authState.when(
        initial: () => false,
        loading: () => false,
        authenticated: (_) => true,
        unauthenticated: () => true,
        error: (_) => true,
      );
      waitCount++;
    }

    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;

    final isAuthenticated = authState.when(
      initial: () => false,
      loading: () => false,
      authenticated: (_) => true,
      unauthenticated: () => false,
      error: (_) => false,
    );
    if (isAuthenticated && mounted) {
      await navigateAfterAuth(context, ref);
    } else if (mounted) {
      context.go(RouteNames.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
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
              l.appName,
              style: TextStyles.displayLarge.copyWith(
                color: AppColors.textInverse,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.mdV,
            Text(
              l.splashTagline,
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textInverse.withValues(alpha: 0.9),
              ),
            ),
            Gaps.xxlV,
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textInverse),
            ),
          ],
        ),
      ),
    );
  }
}
