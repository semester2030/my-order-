// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../utils/navigation_helper.dart';

class SecurityMethodScreen extends ConsumerStatefulWidget {
  const SecurityMethodScreen({super.key});

  @override
  ConsumerState<SecurityMethodScreen> createState() =>
      _SecurityMethodScreenState();
}

class _SecurityMethodScreenState extends ConsumerState<SecurityMethodScreen> {
  final LocalAuthentication _localAuth = LocalAuthentication();
  bool _isBiometricAvailable = false;
  bool _isChecking = true;

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  Future<void> _checkBiometricAvailability() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      setState(() {
        _isBiometricAvailable = isAvailable && isDeviceSupported;
        _isChecking = false;
      });
    } catch (e) {
      setState(() {
        _isBiometricAvailable = false;
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Choose Security Method',
          style: TextStyles.titleLarge,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Gaps.xxlV,
            // Icon
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.security,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
            ),
            Gaps.xlV,
            // Title
            Text(
              'How would you like to secure your account?',
              style: TextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Gaps.mdV,
            Text(
              'Choose your preferred security method',
              style: TextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Gaps.xlV,
            // PIN option
            _SecurityMethodCard(
              icon: Icons.lock_outline,
              title: 'PIN',
              description: 'Use a 4-digit PIN to secure your account',
              onTap: () {
                context.push(RouteNames.pinSetup);
              },
            ),
            Gaps.lgV,
            // Biometric option
            if (_isBiometricAvailable)
              _SecurityMethodCard(
                icon: Icons.fingerprint,
                title: 'Biometric',
                description: 'Use fingerprint or face recognition',
                onTap: () {
                  _handleBiometricSetup();
                },
              )
            else
              Container(
                padding: const EdgeInsets.all(Insets.lg),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: AppRadius.mdAll,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.fingerprint,
                      color: AppColors.textTertiary,
                      size: IconSizes.lg,
                    ),
                    Gaps.mdH,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Biometric',
                            style: TextStyles.titleMedium.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                          Gaps.xsV,
                          Text(
                            'Not available on this device',
                            style: TextStyles.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Gaps.xlV,
            // Skip option
            TextButton(
              onPressed: () async {
                // Check address before navigating to feed
                await navigateAfterAuth(context, ref);
              },
              child: Text(
                'Skip for now',
                style: TextStyles.button.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleBiometricSetup() async {
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to enable biometric security',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );

      if (isAuthenticated && mounted) {
        // TODO: Save biometric preference
        // Check address before navigating to feed
        await navigateAfterAuth(context, ref);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Biometric authentication failed: ${e.toString()}'),
            backgroundColor: SemanticColors.error,
          ),
        );
      }
    }
  }
}

class _SecurityMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _SecurityMethodCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: Container(
        padding: const EdgeInsets.all(Insets.lg),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppRadius.mdAll,
          border: Border.all(
            color: AppColors.border,
          ),
          boxShadow: AppShadows.elevation1,
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: AppRadius.mdAll,
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: IconSizes.lg,
              ),
            ),
            Gaps.mdH,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.titleMedium,
                  ),
                  Gaps.xsV,
                  Text(
                    description,
                    style: TextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
              size: IconSizes.md,
            ),
          ],
        ),
      ),
    );
  }
}
