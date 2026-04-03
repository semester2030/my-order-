import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../auth/presentation/providers/auth_notifier.dart';

/// شاشة حذف الحساب — متطلبات Apple + ثيم موحد مع الإعدادات.
class DeleteAccountScreen extends ConsumerStatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  ConsumerState<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends ConsumerState<DeleteAccountScreen> {
  final _passwordController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final pwd = _passwordController.text.trim();
    if (pwd.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).passwordMinHint),
          backgroundColor: SemanticColors.error,
        ),
      );
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref.read(authNotifierProvider.notifier).deleteAccount(pwd);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).deleteAccountSuccess),
          backgroundColor: SemanticColors.success,
        ),
      );
      context.go(RouteNames.welcome);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceFirst('Exception: ', '')),
          backgroundColor: SemanticColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.deleteAccountTitle, style: TextStyles.titleLarge),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(Insets.md),
              decoration: BoxDecoration(
                color: SemanticColors.error.withValues(alpha: 0.08),
                borderRadius: AppRadius.mdAll,
                border: Border.all(color: SemanticColors.error.withValues(alpha: 0.35)),
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
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.deleteAccountConfirmHint,
                border: const OutlineInputBorder(borderRadius: AppRadius.mdAll),
                filled: true,
                fillColor: AppColors.surfaceElevated,
              ),
            ),
            Gaps.xlV,
            PrimaryButton(
              text: l10n.deleteAccountSubmit,
              isLoading: _submitting,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
