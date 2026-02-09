// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../widgets/pin_pad.dart';
import '../providers/auth_notifier.dart';
import '../../utils/navigation_helper.dart';

class EnterPinScreen extends ConsumerStatefulWidget {
  /// Phone or email (login identifier for PIN verification).
  final String identifier;

  const EnterPinScreen({
    super.key,
    required this.identifier,
  });

  @override
  ConsumerState<EnterPinScreen> createState() => _EnterPinScreenState();
}

class _EnterPinScreenState extends ConsumerState<EnterPinScreen> {
  String _pin = '';
  bool _isLoading = false;
  int _failedAttempts = 0;

  void _onDigitPressed(String digit) {
    if (_isLoading) return;

    setState(() {
      if (_pin.length < 4) {
        _pin += digit;
      }
    });

    // Auto submit when PIN is complete
    if (_pin.length == 4) {
      _verifyPin();
    }
  }

  void _onDeletePressed() {
    if (_isLoading) return;

    setState(() {
      if (_pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      }
    });
  }

  Future<void> _verifyPin() async {
    setState(() => _isLoading = true);

    try {
      await ref.read(authNotifierProvider.notifier).verifyPin(
            widget.identifier,
            _pin,
          );

      if (!mounted) return;

      final authState = ref.read(authNotifierProvider);
      authState.when(
        initial: () {},
        loading: () {},
        authenticated: (_) async {
          // Check address before navigating to feed
          if (mounted) await navigateAfterAuth(context, ref);
        },
        unauthenticated: () {},
        error: (_) {},
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _pin = '';
        _failedAttempts++;
      });

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
                    // User avatar or icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    Gaps.lgV,
                    Text(
                      'أدخل الرمز السري',
                      style: TextStyles.displaySmall,
                      textAlign: TextAlign.center,
                    ),
                    Gaps.smV,
                    Text(
                      widget.identifier,
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
                            color: index < _pin.length
                                ? AppColors.primary
                                : AppColors.border,
                          ),
                        ),
                      ),
                    ),
                    if (_failedAttempts > 0) ...[
                      Gaps.mdV,
                      Text(
                        'الرمز غير صحيح. جرّب مرة أخرى.',
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.error,
                        ),
                      ),
                    ],
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
              child: Column(
                children: [
                  PinPad(
                    onDigitPressed: _onDigitPressed,
                    onDeletePressed: _onDeletePressed,
                  ),
                  Gaps.mdV,
                  TextButton(
                    onPressed: _isLoading ? null : () {
                      if (mounted) {
                        context.go(RouteNames.welcome);
                      }
                    },
                    child: Text(
                      'نسيت الرمز؟ سجّل دخولك برمز OTP',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
