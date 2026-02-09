// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../providers/auth_notifier.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/storage/storage_keys.dart';
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
    // Start navigation check after a short delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _checkAuthAndNavigate();
      }
    });
  }

  Future<void> _checkAuthAndNavigate() async {
    if (_hasNavigated || !mounted) return;

    // 1) Show splash for at least 2 seconds so user always sees it
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted || _hasNavigated) return;

    // 2) Wait for auth state to be resolved (not loading/initial) so we don't race
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

    // 3) If authenticated → go to main app (categories or address); then exit (don't run welcome/pin logic)
    final isAuthenticated = authState.when(
      initial: () => false,
      loading: () => false,
      authenticated: (_) => true,
      unauthenticated: () => false,
      error: (_) => false,
    );
    if (isAuthenticated && mounted) {
      await navigateAfterAuth(context, ref);
      return;
    }

    // 4) Not authenticated: check PIN / welcome
    final secureStorage = ref.read(secureStorageProvider);
    final pinHash = await secureStorage.getPinHash();
    final localStorage = ref.read(localStorageProvider);
    final userPhone = await localStorage.getString(StorageKeys.userPhone);

    // For test customer (0500756706), auto-set PIN if not already set
    const testCustomerPhone = '0500756706';
    const testCustomerPin = '1234';
    
    if (userPhone == testCustomerPhone && (pinHash == null || pinHash.isEmpty)) {
      // Auto-set PIN for test customer
      final pinBytes = utf8.encode(testCustomerPin);
      final testPinHash = sha256.convert(pinBytes).toString();
      await secureStorage.savePinHash(testPinHash);
      // Save phone if not already saved
      if (userPhone == null) {
        await localStorage.saveString(StorageKeys.userPhone, testCustomerPhone);
      }
      // Navigate to PIN verification with test phone
      if (mounted) {
        context.go(
          RouteNames.pinVerification,
          extra: testCustomerPhone,
        );
      }
      return;
    }

    if (pinHash != null && pinHash.isNotEmpty && userPhone != null) {
      // PIN is set, go directly to PIN verification
      if (mounted) {
        context.go(
          RouteNames.pinVerification,
          extra: userPhone,
        );
      }
    } else {
      // No PIN set, go to welcome screen (first time login)
      if (mounted) {
        context.go(RouteNames.welcome);
      }
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
            // Logo placeholder
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.textInverse,
                borderRadius: AppRadius.fullAll,
              ),
              child: const Icon(
                Icons.restaurant,
                size: 60,
                color: AppColors.primary,
              ),
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
