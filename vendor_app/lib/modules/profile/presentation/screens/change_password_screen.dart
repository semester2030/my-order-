import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/validators.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/profile/presentation/providers/profile_state.dart';

/// شاشة تغيير كلمة المرور — ثيم موحد (Phase 6).
class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  String? _confirmValidator(String? value) {
    if (value == null || value.isEmpty) return 'تأكيد كلمة المرور مطلوب';
    if (value != _newController.text) return 'كلمة المرور الجديدة وتأكيدها غير متطابقتين';
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(profileNotifierProvider.notifier).changePassword(
          _currentController.text,
          _newController.text,
        );
    if (!mounted) return;
    if (ok) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('تم تغيير كلمة المرور بنجاح'),
            backgroundColor: SemanticColors.success,
          ),
        );
        context.pop();
      }
    } else {
      final state = ref.read(profileNotifierProvider);
      if (state is ProfileSaveError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: SemanticColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileNotifierProvider);
    final saving = state is ProfileSaving;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'تغيير كلمة المرور',
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
                Text(
                  'أدخل كلمة المرور الحالية والجديدة',
                  style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                Gaps.xlV,
                AppTextField(
                  controller: _currentController,
                  obscureText: true,
                  validator: Validators.password,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الحالية',
                    hintText: '••••••••',
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _newController,
                  obscureText: true,
                  validator: Validators.password,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور الجديدة',
                    hintText: '••••••••',
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _confirmController,
                  obscureText: true,
                  validator: _confirmValidator,
                  decoration: InputDecoration(
                    labelText: 'تأكيد كلمة المرور الجديدة',
                    hintText: '••••••••',
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.xlV,
                PrimaryButton(
                  label: saving ? 'جاري التغيير...' : 'تغيير كلمة المرور',
                  onPressed: saving ? null : _save,
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
