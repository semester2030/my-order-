import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/di/providers.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_state.dart';
import '../../../driver_profile/presentation/providers/driver_profile_notifier.dart';

class PinVerificationScreen extends ConsumerStatefulWidget {
  final String phone;

  const PinVerificationScreen({
    super.key,
    required this.phone,
  });

  @override
  ConsumerState<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends ConsumerState<PinVerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  bool _obscurePin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _verifyPin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authNotifierProvider.notifier).verifyPin(
            widget.phone,
            _pinController.text,
          );
      // Navigation is handled by ref.listen
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      AppSnackbar.showError(context, 'PIN verification failed: ${e.toString()}');
    }
  }

  Future<void> _forgotPin() async {
    // Navigate back to phone input to start OTP flow
    if (mounted) {
      // Use pop first to go back, if that fails, use push
      if (context.canPop()) {
        context.pop();
      } else {
        context.push(RouteNames.phoneInput);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state changes for navigation
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        // Check if driver exists before navigating
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return;
          
          try {
            final repository = ref.read(driverProfileRepositoryProvider);
            final driverExists = await repository.checkDriverExists();
            
            if (!mounted) return;
            
            setState(() => _isLoading = false);
            
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
              setState(() => _isLoading = false);
              context.go(RouteNames.welcome);
            }
          }
        });
      } else if (next is AuthError) {
        if (mounted) {
          setState(() => _isLoading = false);
          AppSnackbar.showError(context, next.message);
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Insets.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gaps.xxlV,
                Text(
                  'Enter PIN',
                  style: TextStyles.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                Gaps.mdV,
                Text(
                  'Enter your 4-digit PIN to continue',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.xlV,
                // PIN Input
                AppTextField(
                  controller: _pinController,
                  obscureText: _obscurePin,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  labelText: 'PIN',
                  hintText: 'Enter 4-digit PIN',
                  prefixIcon: const Icon(Icons.pin, color: AppColors.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePin ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() => _obscurePin = !_obscurePin);
                    },
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your PIN';
                    }
                    if (value.length != 4) {
                      return 'PIN must be 4 digits';
                    }
                    return null;
                  },
                ),
                Gaps.lgV,
                PrimaryButton(
                  onPressed: _isLoading ? null : _verifyPin,
                  text: 'Verify',
                  isLoading: _isLoading,
                ),
                Gaps.mdV,
                TextButton(
                  onPressed: _isLoading ? null : _forgotPin,
                  child: Text(
                    'Forgot PIN? Use OTP instead',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
