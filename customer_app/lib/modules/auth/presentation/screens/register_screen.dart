// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../providers/auth_notifier.dart';
import '../../utils/navigation_helper.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref.read(authNotifierProvider.notifier).register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
          );
      if (!mounted) return;
      final state = ref.read(authNotifierProvider);
      state.when(
        initial: () {},
        loading: () {},
        authenticated: (_) => navigateAfterAuth(context, ref),
        unauthenticated: () {},
        error: (_) {},
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString()), backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          onPressed: () => context.go(RouteNames.welcome),
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
                Text('إنشاء حساب', style: TextStyles.displayMedium),
                Gaps.smV,
                Text(
                  'الاسم، البريد الإلكتروني، والرمز السري',
                  style: TextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                ),
                Gaps.xxlV,
                AppTextField(
                  controller: _nameController,
                  label: 'الاسم',
                  hint: 'أدخل اسمك',
                  validator: (v) => AppValidators.minLength(v, 2, fieldName: 'الاسم'),
                  prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                ),
                Gaps.lgV,
                AppTextField(
                  controller: _emailController,
                  label: 'البريد الإلكتروني',
                  hint: 'example@email.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: AppValidators.email,
                  prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                ),
                Gaps.lgV,
                AppTextField(
                  controller: _passwordController,
                  label: 'الرمز السري',
                  hint: '6 أحرف على الأقل',
                  obscureText: _obscurePassword,
                  validator: (v) => AppValidators.minLength(v, 6, fieldName: 'الرمز السري'),
                  prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
                Gaps.xxlV,
                PrimaryButton(
                  onPressed: _isLoading ? null : _register,
                  isLoading: _isLoading,
                  text: 'تسجيل',
                ),
                Gaps.lgV,
                TextButton(
                  onPressed: () => context.go(RouteNames.login),
                  child: Text(
                    'لديك حساب؟ تسجيل الدخول',
                    style: TextStyles.bodyMedium.copyWith(color: AppColors.primary),
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
