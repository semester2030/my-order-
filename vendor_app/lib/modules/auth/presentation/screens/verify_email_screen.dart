import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/result.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
/// تأكيد بريد مقدّم الخدمة عبر OTP (بعد الاعتماد).
class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  final _codeController = TextEditingController();
  bool _loadingStatus = true;
  bool _sending = false;
  bool _verifying = false;
  bool _alreadyVerified = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkStatus());
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _checkStatus() async {
    final res = await ref.read(authRepoProvider).getVendorOnboardingStatus();
    if (!mounted) return;
    switch (res) {
      case Failure(:final error):
        setState(() {
          _loadingStatus = false;
          _alreadyVerified = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: SemanticColors.error),
        );
      case Success(:final value):
        if (value.emailVerified) {
          setState(() {
            _loadingStatus = false;
            _alreadyVerified = true;
          });
          final l10n = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.verifyEmailAlreadyDone), backgroundColor: SemanticColors.success),
          );
        } else {
          setState(() {
            _loadingStatus = false;
            _alreadyVerified = false;
          });
        }
    }
  }

  Future<void> _requestOtp() async {
    setState(() => _sending = true);
    final res = await ref.read(authRepoProvider).requestVendorEmailVerificationOtp();
    if (!mounted) return;
    setState(() => _sending = false);
    final l10n = AppLocalizations.of(context);
    switch (res) {
      case Failure(:final error):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: SemanticColors.error),
        );
      case Success(:final value):
        final o = value;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(o.message.isNotEmpty ? o.message : l10n.verifyEmailSendOtp),
            backgroundColor: o.sent ? SemanticColors.success : SemanticColors.warning,
          ),
        );
        final code = o.code;
        if (code != null && code.isNotEmpty) {
          await showDialog<void>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(l10n.verifyEmailDevCodeTitle),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.verifyEmailDevCodeHint, style: TextStyles.bodySmall),
                  Gaps.mdV,
                  SelectableText(code, style: TextStyles.titleLarge),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: code));
                    Navigator.of(ctx).pop();
                  },
                  child: Text(l10n.copy),
                ),
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
                ),
              ],
            ),
          );
        }
    }
  }

  Future<void> _verify() async {
    final code = _codeController.text.trim();
    if (code.length < 4) return;
    setState(() => _verifying = true);
    final res = await ref.read(authRepoProvider).verifyVendorEmailWithOtp(code);
    if (!mounted) return;
    setState(() => _verifying = false);
    final l10n = AppLocalizations.of(context);
    switch (res) {
      case Failure(:final error):
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message), backgroundColor: SemanticColors.error),
        );
      case Success():
        await ref.read(profileNotifierProvider.notifier).loadProfile();
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.verifyEmailSuccess), backgroundColor: SemanticColors.success),
        );
        context.pop();
    }
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
        title: Text(l10n.verifyEmail, style: TextStyles.headlineSmall),
      ),
      body: _loadingStatus
          ? const Center(child: CircularProgressIndicator())
          : _alreadyVerified
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(Insets.lg),
                    child: Text(
                      l10n.verifyEmailAlreadyDone,
                      textAlign: TextAlign.center,
                      style: TextStyles.bodyLarge,
                    ),
                  ),
                )
              : SingleChildScrollView(
                  padding: EdgeInsets.all(Insets.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.verifyEmailDescription,
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                      Gaps.xlV,
                      PrimaryButton(
                        label: _sending ? '...' : l10n.verifyEmailSendOtp,
                        onPressed: _sending ? null : _requestOtp,
                      ),
                      Gaps.lgV,
                      AppTextField(
                        controller: _codeController,
                        decoration: InputDecoration(
                          labelText: l10n.verifyEmailOtpLabel,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      Gaps.mdV,
                      PrimaryButton(
                        label: _verifying ? '...' : l10n.verifyEmailConfirm,
                        onPressed: _verifying ? null : _verify,
                      ),
                    ],
                  ),
                ),
    );
  }
}
