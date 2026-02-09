import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/di/providers.dart';
import '../providers/auth_notifier.dart';
import '../providers/auth_state.dart';
import '../widgets/otp_input.dart';
import '../../../driver_profile/presentation/providers/driver_profile_notifier.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String phone;

  const OtpScreen({
    super.key,
    required this.phone,
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get dev OTP if available (ref is available in didChangeDependencies)
    if (_devOtp == null) {
      _devOtp = ref.read(authNotifierProvider.notifier).getLastOtp();
    }
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
    if (_otpCode.length != 6) {
      // Show error if OTP is not complete
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit code'),
          backgroundColor: SemanticColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authNotifierProvider.notifier).verifyOtp(
            widget.phone,
            _otpCode,
          );
      // Note: Navigation is handled by ref.listen in build method
      // Loading state will be reset by ref.listen
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Verification failed: ${e.toString()}'),
          backgroundColor: SemanticColors.error,
        ),
      );
    }
  }

  Future<void> _resendOtp() async {
    if (_resendCountdown > 0) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authNotifierProvider.notifier).requestOtp(widget.phone);
      _devOtp = ref.read(authNotifierProvider.notifier).getLastOtp();
      setState(() {
        _resendCountdown = 60;
        _otpCode = '';
      });
      _startResendCountdown();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: SemanticColors.error,
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
    // Listen to auth state changes for navigation
    // ref.listen is safe to call in build - it only registers once
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      if (next is AuthAuthenticated) {
        // Handle navigation after successful authentication
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          if (!mounted) return;
          
          // Check if PIN is set
          final pinHash = await ref
              .read(secureStorageProvider)
              .getPinHash();

          if (pinHash == null || pinHash.isEmpty) {
            if (mounted) context.go(RouteNames.pinSetup);
          } else {
            // PIN is set, check if driver exists before navigating
            try {
              final repository = ref.read(driverProfileRepositoryProvider);
              final driverExists = await repository.checkDriverExists();
              
              if (!mounted) return;
              
              if (driverExists) {
                // Driver exists, go to main shell
                if (mounted) context.go(RouteNames.mainShell);
              } else {
                // Driver doesn't exist, go to welcome screen
                if (mounted) context.go(RouteNames.welcome);
              }
            } catch (e) {
              // If check fails, go to welcome screen
              if (mounted) context.go(RouteNames.welcome);
            }
          }
          
          if (mounted) {
            setState(() => _isLoading = false);
          }
        });
      } else if (next is AuthError) {
        if (mounted) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.message),
              backgroundColor: SemanticColors.error,
            ),
          );
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
                'Enter verification code',
                style: TextStyles.headlineLarge,
                textAlign: TextAlign.center,
              ),
              Gaps.mdV,
              Text(
                'We sent a code to ${widget.phone}',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              if (_devOtp != null) ...[
                Gaps.mdV,
              Container(
                padding: const EdgeInsets.all(Insets.md),
                decoration: const BoxDecoration(
                  color: SemanticColors.infoContainer,
                  borderRadius: AppRadius.mdAll,
                ),
                  child: Text(
                    'Dev OTP: $_devOtp',
                    style: TextStyles.bodyMedium.copyWith(
                      color: SemanticColors.info,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
              Gaps.xlV,
              OtpInput(
                onChanged: (code) {
                  setState(() => _otpCode = code);
                },
              ),
              Gaps.xlV,
              PrimaryButton(
                onPressed: _otpCode.length == 6 && !_isLoading ? _verifyOtp : null,
                text: 'Verify',
                isLoading: _isLoading,
              ),
              Gaps.lgV,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Didn\'t receive the code? ',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  TextButton(
                    onPressed: _resendCountdown > 0 || _isLoading ? null : _resendOtp,
                    child: Text(
                      _resendCountdown > 0
                          ? 'Resend in ${_resendCountdown}s'
                          : 'Resend',
                      style: TextStyles.bodyMedium.copyWith(
                        color: _resendCountdown > 0 || _isLoading
                            ? AppColors.textTertiary
                            : AppColors.primary,
                        fontWeight: FontWeight.w600,
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
