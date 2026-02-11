// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
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
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted || _hasNavigated) return;

    var authState = ref.read(authNotifierProvider);
    int waitCount = 0;
    bool isResolved = authState.when(
      initial: () => false,
      loading: () => false,
      authenticated: (_) => true,
      unauthenticated: () => true,
      error: (_) => true,
    );
    while (!isResolved && waitCount < 50) {
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
    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Center(
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
              child: const Icon(Icons.restaurant, size: 60, color: AppColors.primary),
            ),
            Gaps.xlV,
            Text(
              'My Order',
              style: TextStyles.displayLarge.copyWith(
                color: AppColors.textInverse,
                fontWeight: FontWeight.bold,
              ),
            ),
            Gaps.mdV,
            Text(
              'Premium Food Delivery',
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
