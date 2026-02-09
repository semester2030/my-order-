import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/utils/validators.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/modules/auth/presentation/providers/auth_state.dart';
import 'package:vendor_app/modules/auth/presentation/providers/session_state.dart';

/// Login screen — ثيم موحد (design_system).
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref.read(authNotifierProvider.notifier).login(
          _emailController.text.trim(),
          _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (next is AuthAuthenticated) {
        ref.read(sessionNotifierProvider.notifier).checkSession();
      }
    });
    ref.listen<SessionState>(sessionNotifierProvider, (prev, next) {
      if (prev is SessionLoading && context.mounted) {
        if (next is SessionAuthenticated) {
          context.go(RouteNames.shell);
        } else if (next is SessionPending) {
          context.go(RouteNames.pending);
        } else if (next is SessionRejected) {
          context.go(RouteNames.rejected);
        }
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).login,
          style: TextStyles.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gaps.xlV,
                Text(
                  AppLocalizations.of(context).welcomeBack,
                  style: TextStyles.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Gaps.smV,
                Text(
                  AppLocalizations.of(context).enterEmailPassword,
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Gaps.xlV,
                AppTextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).emailLabel,
                    hintText: 'vendor@example.com',
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.mdAll,
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.password,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).passwordLabel,
                    hintText: '••••••••',
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.mdAll,
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                if (authState is AuthError) ...[
                  Gaps.mdV,
                  Text(
                    AppLocalizations.of(context).messageForAuthError(
                      authState.type?.name,
                      fallbackMessage: authState.message,
                    ),
                    style: TextStyles.bodySmall.copyWith(
                      color: SemanticColors.error,
                    ),
                  ),
                ],
                Gaps.xlV,
                PrimaryButton(
                  label: authState is AuthLoading ? AppLocalizations.of(context).loginChecking : AppLocalizations.of(context).login,
                  onPressed: authState is AuthLoading ? null : _submit,
                ),
                Gaps.lgV,
                TextButton(
                  onPressed: () => context.go(RouteNames.register),
                  child: Text(
                    AppLocalizations.of(context).createAccount,
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Gaps.mdV,
                TextButton(
                  onPressed: () {
                    ref.read(sessionNotifierProvider.notifier).setAuthenticated();
                    context.go(RouteNames.shell);
                  },
                  child: Text(
                    'دخول تجريبي (بدون API)',
                    style: TextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
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
