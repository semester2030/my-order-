import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/validators.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/core/widgets/error_state.dart';
import 'package:vendor_app/core/widgets/loading_view.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/staff/domain/entities/staff_member.dart';
import 'package:vendor_app/modules/staff/presentation/providers/staff_state.dart';

/// شاشة تعديل موظف — ثيم موحد (Phase 13).
class EditStaffScreen extends ConsumerStatefulWidget {
  const EditStaffScreen({super.key, required this.memberId});

  final String memberId;

  @override
  ConsumerState<EditStaffScreen> createState() => _EditStaffScreenState();
}

class _EditStaffScreenState extends ConsumerState<EditStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _roleController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _fillFromMember(StaffMember member) {
    _nameController.text = member.name;
    _roleController.text = member.role ?? '';
    _emailController.text = member.email ?? '';
    _phoneController.text = member.phone ?? '';
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final item = StaffMember(
      id: widget.memberId,
      name: _nameController.text.trim(),
      role: _roleController.text.trim().isEmpty ? null : _roleController.text.trim(),
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      isActive: true,
    );
    final ok = await ref.read(staffNotifierProvider.notifier).updateItem(item);
    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      final state = ref.read(staffNotifierProvider);
      if (state is StaffError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message), backgroundColor: SemanticColors.error),
        );
      }
    }
  }

  bool get _saving {
    final state = ref.watch(staffNotifierProvider);
    return state is StaffSaving;
  }

  @override
  Widget build(BuildContext context) {
    final memberAsync = ref.watch(staffMemberByIdProvider(widget.memberId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'تعديل الموظف',
          style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: memberAsync.when(
        data: (member) {
          if (member == null) {
            return ErrorState(
              message: 'الموظف غير موجود',
              onRetry: () => ref.invalidate(staffMemberByIdProvider(widget.memberId)),
            );
          }
          if (_nameController.text.isEmpty && member.name.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _fillFromMember(member));
          }
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Insets.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Gaps.lgV,
                    AppTextField(
                      controller: _nameController,
                      validator: (v) => Validators.required(v, 'اسم الموظف'),
                      decoration: InputDecoration(
                        labelText: 'اسم الموظف',
                        border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                        filled: true,
                        fillColor: AppColors.surface,
                      ),
                    ),
                    Gaps.mdV,
                    AppTextField(
                      controller: _roleController,
                      decoration: InputDecoration(
                        labelText: 'الدور — اختياري',
                        border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                        filled: true,
                        fillColor: AppColors.surface,
                      ),
                    ),
                    Gaps.mdV,
                    AppTextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'البريد — اختياري',
                        border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                        filled: true,
                        fillColor: AppColors.surface,
                      ),
                    ),
                    Gaps.mdV,
                    AppTextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: 'الجوال — اختياري',
                        border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                        filled: true,
                        fillColor: AppColors.surface,
                      ),
                    ),
                    Gaps.xlV,
                    PrimaryButton(
                      label: _saving ? 'جاري الحفظ...' : 'حفظ',
                      onPressed: _saving ? null : _save,
                    ),
                    Gaps.xxlV,
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: LoadingView()),
        error: (err, _) => ErrorState(
          message: err.toString(),
          onRetry: () => ref.invalidate(staffMemberByIdProvider(widget.memberId)),
        ),
      ),
    );
  }
}
