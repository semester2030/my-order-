// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/di/providers.dart';
import '../widgets/otp_input_v2.dart' as otp_widget;
import '../providers/auth_notifier.dart';
import '../../utils/navigation_helper.dart';

class OtpScreen extends ConsumerStatefulWidget {
  /// Phone number or email (login identifier).
  final String identifier;

  const OtpScreen({
    super.key,
    required this.identifier,
  });

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  String _otpCode = '';
  bool _isLoading = false;
  int _resendCountdown = 60;
  String? _devOtp; // Store OTP for development mode

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  void _startResendCountdown() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _resendCountdown > 0) {
        setState(() => _resendCountdown--);
        _startResendCountdown();
      }
    });
  }

  Future<void> _verifyOtp() async {
    if (_otpCode.length != 6) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authNotifierProvider.notifier).verifyOtp(
            widget.identifier,
            _otpCode,
          );

      if (!mounted) return;

      final authState = ref.read(authNotifierProvider);
      authState.when(
        initial: () {},
        loading: () {},
        authenticated: (_) async {
          // Check if PIN is set
          final pinHash = await ref
              .read(secureStorageProvider)
              .getPinHash();

          if (pinHash == null || pinHash.isEmpty) {
            if (mounted) context.go(RouteNames.pinSetup);
          } else {
            // Check address before navigating to feed
            if (mounted) await navigateAfterAuth(context, ref);
          }
        },
        unauthenticated: () {},
        error: (_) {},
      );
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

  Future<void> _resendOtp() async {
    if (_resendCountdown > 0) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authNotifierProvider.notifier).requestOtp(widget.identifier);
      // Get OTP from notifier if available (development mode)
      final otp = ref.read(authNotifierProvider.notifier).getLastOtp();
      if (otp != null && mounted) {
        setState(() => _devOtp = otp);
      }
      setState(() => _resendCountdown = 60);
      _startResendCountdown();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('OTP sent successfully'),
          backgroundColor: AppColors.success,
        ),
      );
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
    // Load OTP in development mode after first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_devOtp == null) {
        final otp = ref.read(authNotifierProvider.notifier).getLastOtp();
        if (otp != null && mounted) {
          setState(() => _devOtp = otp);
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Gaps.xxlV,
              Text(
                'أدخل رمز التحقق',
                style: TextStyles.displaySmall,
                textAlign: TextAlign.center,
              ),
              Gaps.smV,
              Text(
                'أرسلنا رمزاً مكوّناً من 6 أرقام إلى\n${widget.identifier}',
                style: TextStyles.bodyLarge.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              Gaps.xxlV,
              // Show OTP only in debug mode (never in production)
              if (kDebugMode && _devOtp != null) ...[
                Container(
                  padding: EdgeInsets.all(Insets.md),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: AppRadius.mdAll,
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Development Mode',
                        style: TextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.smV,
                      Text(
                        'Your OTP: $_devOtp',
                        style: TextStyles.headlineMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Gaps.xsV,
                      Text(
                        'Note: SMS service is not configured yet',
                        style: TextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Gaps.lgV,
              ],
              otp_widget.OtpInputV2(
                onCompleted: (code) {
                  setState(() => _otpCode = code);
                  _verifyOtp();
                },
                onChanged: (value) {
                  setState(() => _otpCode = value);
                },
              ),
              Gaps.xlV,
              PrimaryButton(
                onPressed: _otpCode.length == 6 && !_isLoading
                    ? _verifyOtp
                    : null,
                isLoading: _isLoading,
                text: 'تحقق',
              ),
              Gaps.lgV,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'لم يصلك الرمز؟ ',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: _resendCountdown == 0 ? _resendOtp : null,
                    child: Text(
                      _resendCountdown > 0
                          ? 'إعادة الإرسال خلال ${_resendCountdown}ث'
                          : 'إعادة الإرسال',
                      style: TextStyles.bodyMedium.copyWith(
                        color: _resendCountdown == 0
                            ? AppColors.primary
                            : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
