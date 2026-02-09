import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_notifier.dart';

class PhoneScreen extends ConsumerStatefulWidget {
  const PhoneScreen({super.key});

  @override
  ConsumerState<PhoneScreen> createState() => _PhoneScreenState();
}

class _PhoneScreenState extends ConsumerState<PhoneScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _requestOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(authNotifierProvider.notifier).requestOtp(
            _phoneController.text.trim(),
          );

      if (!mounted) return;

      context.push(
        RouteNames.otpVerification,
        extra: _phoneController.text.trim(),
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
                  'Welcome',
                  style: TextStyles.displayMedium,
                ),
                Gaps.smV,
                Text(
                  'Enter your phone number to continue',
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Gaps.xxlV,
                AppTextField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  hint: '05XXXXXXXX',
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  validator: AppValidators.phone,
                  prefixIcon: const Icon(
                    Icons.phone,
                    color: AppColors.primary,
                  ),
                ),
                Gaps.xlV,
                PrimaryButton(
                  onPressed: _isLoading ? null : _requestOtp,
                  isLoading: _isLoading,
                  text: 'متابعة',
                ),
                Gaps.mdV,
                TextButton.icon(
                  onPressed: () => context.go(RouteNames.emailInput),
                  icon: const Icon(Icons.email_outlined, size: 18),
                  label: const Text('تسجيل بالبريد الإلكتروني بدلاً من ذلك'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textSecondary,
                  ),
                ),
                Gaps.lgV,
                Text(
                  'بالمتابعة أنت توافق على الشروط وسياسة الخصوصية',
                  style: TextStyles.caption,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
