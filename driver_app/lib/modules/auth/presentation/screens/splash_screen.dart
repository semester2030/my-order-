import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/storage/storage_keys.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_state.dart';
import '../../../driver_profile/presentation/providers/driver_profile_notifier.dart';

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

    // Wait for auth check to complete
    await Future.delayed(const Duration(seconds: 2)); // Show splash for 2 seconds

    if (!mounted || _hasNavigated) return;

    _hasNavigated = true;

    // Check authentication status
    final authState = ref.read(authNotifierProvider);
    
    if (authState is AuthAuthenticated) {
      // User is authenticated, check if driver exists
      try {
        final repository = ref.read(driverProfileRepositoryProvider);
        final driverExists = await repository.checkDriverExists();
        
        if (!mounted) return;
        
        if (driverExists) {
          // Driver exists, go to main shell
          context.go(RouteNames.mainShell);
        } else {
          // Driver doesn't exist, go to welcome screen
          context.go(RouteNames.welcome);
        }
      } catch (e) {
        // If check fails, go to welcome screen
        if (mounted) {
          context.go(RouteNames.welcome);
        }
      }
      return;
    }

    // Check if PIN is set (user has logged in before)
    final secureStorage = ref.read(secureStorageProvider);
    final pinHash = await secureStorage.getPinHash();
    final localStorage = ref.read(localStorageProvider);
    final userPhone = await localStorage.getString(StorageKeys.userPhone);

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
    // Check navigation after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasNavigated) {
        _checkAuthAndNavigate();
      }
    });

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
              child: Icon(
                Icons.delivery_dining,
                size: 60,
                color: AppColors.primary,
              ),
            ),
            Gaps.xlV,
            Text(
              'Driver App',
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
