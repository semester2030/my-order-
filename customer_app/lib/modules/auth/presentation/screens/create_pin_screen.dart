import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../widgets/pin_pad.dart';
import '../providers/auth_notifier.dart';
import '../../utils/navigation_helper.dart';

class CreatePinScreen extends ConsumerStatefulWidget {
  const CreatePinScreen({super.key});

  @override
  ConsumerState<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends ConsumerState<CreatePinScreen> {
  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  bool _isLoading = false;

  void _onDigitPressed(String digit) {
    if (_isLoading) return;

    setState(() {
      if (!_isConfirming) {
        if (_pin.length < 4) {
          _pin += digit;
        }
      } else {
        if (_confirmPin.length < 4) {
          _confirmPin += digit;
        }
      }
    });

    // Auto submit when PIN is complete
    if (!_isConfirming && _pin.length == 4) {
      Future.delayed(const Duration(milliseconds: 300), () {
        setState(() => _isConfirming = true);
      });
    } else if (_isConfirming && _confirmPin.length == 4) {
      _setPin();
    }
  }

  void _onDeletePressed() {
    if (_isLoading) return;

    setState(() {
      if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        } else {
          _isConfirming = false;
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }
    });
  }

  Future<void> _setPin() async {
    if (_pin != _confirmPin) {
      setState(() {
        _pin = '';
        _confirmPin = '';
        _isConfirming = false;
      });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('PINs do not match. Please try again.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authNotifierProvider.notifier).setPin(_pin);

      if (!mounted) return;

      // Check address before navigating to feed
      await navigateAfterAuth(context, ref);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPin = _isConfirming ? _confirmPin : _pin;

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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Insets.lg),
                child: Column(
                  children: [
                    Gaps.xxlV,
                    Text(
                      _isConfirming ? 'Confirm PIN' : 'Create PIN',
                      style: TextStyles.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    Gaps.smV,
                    Text(
                      _isConfirming
                          ? 'Re-enter your PIN to confirm'
                          : 'Enter a 4-digit PIN for security',
                      style: TextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Gaps.xxlV,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
                        (index) => Container(
                          width: 16,
                          height: 16,
                          margin: const EdgeInsets.symmetric(
                            horizontal: Insets.sm,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index < currentPin.length
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                      ),
                    ),
                    if (_isLoading) ...[
                      Gaps.lgV,
                      const CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(Insets.lg),
              child: PinPad(
                onDigitPressed: _onDigitPressed,
                onDeletePressed: _onDeletePressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
