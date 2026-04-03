import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/utils/result.dart' hide Failure;
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/validators.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';

/// حذف الحساب — متطلبات Apple؛ ثيم موحد مع باقي الملف الشخصي.
class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  var _submitting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    final result = await ref
        .read(sessionNotifierProvider.notifier)
        .deleteAccount(_passwordController.text);
    if (!mounted) return;
    setState(() => _submitting = false);
    result.when(
      success: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).deleteAccountSuccess),
            backgroundColor: SemanticColors.success,
          ),
        );
        context.go(RouteNames.login);
      },
      failure: (f) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(f.message),
            backgroundColor: SemanticColors.error,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          l10n.deleteAccountTitle,
          style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
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
                Gaps.lgV,
                Container(
                  padding: const EdgeInsets.all(Insets.md),
                  decoration: BoxDecoration(
                    color: SemanticColors.error.withValues(alpha: 0.08),
                    borderRadius: AppRadius.mdAll,
                    border: Border.all(
                      color: SemanticColors.error.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    l10n.deleteAccountWarning,
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary,
                      height: 1.45,
                    ),
                  ),
                ),
                Gaps.xlV,
                AppTextField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.password,
                  decoration: InputDecoration(
                    labelText: l10n.deleteAccountPasswordLabel,
                    hintText: '••••••••',
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.xlV,
                PrimaryButton(
                  label: _submitting ? l10n.loading : l10n.deleteAccountSubmit,
                  onPressed: _submitting ? null : _submit,
                ),
                Gaps.xxlV,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
