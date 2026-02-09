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
import '../../../../core/di/providers.dart';
import '../../../driver_profile/presentation/providers/driver_profile_notifier.dart';

class PinSetupScreen extends ConsumerStatefulWidget {
  const PinSetupScreen({super.key});

  @override
  ConsumerState<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends ConsumerState<PinSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  bool _obscurePin = true;
  bool _obscureConfirmPin = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _submitPin() async {
    if (!_formKey.currentState!.validate()) return;

    if (_pinController.text != _confirmPinController.text) {
      AppSnackbar.showError(context, 'PIN codes do not match');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final secureStorage = ref.read(secureStorageProvider);
      // Hash the PIN before storing
      final pinBytes = utf8.encode(_pinController.text);
      final pinHash = sha256.convert(pinBytes).toString();
      await secureStorage.savePinHash(pinHash);

      if (!mounted) return;

      AppSnackbar.showSuccess(context, 'PIN set successfully');
      
      // Check if driver exists before navigating
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
    } catch (e) {
      if (!mounted) return;
      AppSnackbar.showError(context, 'Failed to set PIN: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Set PIN', style: TextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Insets.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gaps.xlV,
                // Icon
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: AppColors.primary,
                ),
                Gaps.lgV,
                // Title
                Text(
                  'Create PIN',
                  style: TextStyles.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                Gaps.smV,
                Text(
                  'Set a 4-digit PIN to secure your account',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                Gaps.xlV,

                // PIN Input
                TextFormField(
                  controller: _pinController,
                  obscureText: _obscurePin,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: InputDecoration(
                    labelText: 'PIN',
                    hintText: 'Enter 4-digit PIN',
                    prefixIcon: Icon(Icons.pin, color: AppColors.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePin ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => _obscurePin = !_obscurePin);
                      },
                    ),
                    counterText: '',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a PIN';
                    }
                    if (value.length != 4) {
                      return 'PIN must be 4 digits';
                    }
                    return null;
                  },
                ),
                Gaps.lgV,

                // Confirm PIN Input
                TextFormField(
                  controller: _confirmPinController,
                  obscureText: _obscureConfirmPin,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Confirm PIN',
                    hintText: 'Re-enter 4-digit PIN',
                    prefixIcon: Icon(Icons.pin_outlined, color: AppColors.primary),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPin
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() => _obscureConfirmPin = !_obscureConfirmPin);
                      },
                    ),
                    counterText: '',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your PIN';
                    }
                    if (value.length != 4) {
                      return 'PIN must be 4 digits';
                    }
                    if (value != _pinController.text) {
                      return 'PIN codes do not match';
                    }
                    return null;
                  },
                ),
                Gaps.xlV,

                // Submit Button
                PrimaryButton(
                  onPressed: _isLoading ? null : _submitPin,
                  text: 'Set PIN',
                  icon: Icons.check,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
