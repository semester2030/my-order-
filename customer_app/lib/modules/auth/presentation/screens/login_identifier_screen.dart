// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/validators.dart';

/// شاشة تسجيل الدخول للمستخدمين الحاليين: إدخال البريد أو الجوال ثم الرمز السري (4 أرقام) فقط بدون OTP.
class LoginIdentifierScreen extends ConsumerStatefulWidget {
  const LoginIdentifierScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _LoginIdentifierScreenState();
}

class _LoginIdentifierScreenState extends ConsumerState<LoginIdentifierScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();

  @override
  void dispose() {
    _identifierController.dispose();
    super.dispose();
  }

  void _continueToPin() {
    if (!_formKey.currentState!.validate()) return;

    final identifier = _identifierController.text.trim();
    if (!mounted) return;

    context.push(
      RouteNames.pinVerification,
      extra: identifier,
    );
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
                  'تسجيل الدخول',
                  style: TextStyles.displayMedium,
                ),
                Gaps.smV,
                Text(
                  'أدخل بريدك الإلكتروني أو رقم جوالك ثم الرمز السري (4 أرقام)',
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Gaps.xxlV,
                AppTextField(
                  controller: _identifierController,
                  label: 'البريد الإلكتروني أو رقم الجوال',
                  hint: 'example@email.com أو 05xxxxxxxx',
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.emailOrPhone,
                  prefixIcon: const Icon(
                    Icons.person_outline,
                    color: AppColors.primary,
                  ),
                ),
                Gaps.xlV,
                PrimaryButton(
                  onPressed: _continueToPin,
                  text: 'متابعة إلى الرمز السري',
                ),
                Gaps.mdV,
                TextButton(
                  onPressed: () => context.go(RouteNames.welcome),
                  child: Text(
                    'إنشاء حساب جديد',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                Gaps.lgV,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
