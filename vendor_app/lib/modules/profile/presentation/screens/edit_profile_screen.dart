import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/validators.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/profile/domain/entities/vendor_profile.dart';
import 'package:vendor_app/modules/profile/presentation/providers/profile_state.dart';

/// شاشة تعديل البروفايل — ثيم موحد (Phase 6).
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _tradeNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();

  String? _profileId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fillFromProfile());
  }

  void _fillFromProfile() {
    final state = ref.read(profileNotifierProvider);
    if (state is ProfileLoaded) {
      _profileId = state.profile.id;
      _nameController.text = state.profile.name;
      _tradeNameController.text = state.profile.tradeName ?? '';
      _emailController.text = state.profile.email ?? '';
      _phoneController.text = state.profile.phoneNumber ?? '';
      _descriptionController.text = state.profile.description ?? '';
      _addressController.text = state.profile.address ?? '';
      _cityController.text = state.profile.city ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _tradeNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate() || _profileId == null) return;
    final current = ref.read(profileNotifierProvider);
    final registrationStatus = current is ProfileLoaded ? current.profile.registrationStatus : null;
    final profile = VendorProfile(
      id: _profileId!,
      name: _nameController.text.trim(),
      tradeName: _tradeNameController.text.trim().isEmpty ? null : _tradeNameController.text.trim(),
      email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      city: _cityController.text.trim().isEmpty ? null : _cityController.text.trim(),
      providerCategory: null,
      isActive: true,
      isAcceptingOrders: true,
      registrationStatus: registrationStatus,
    );
    final ok = await ref.read(profileNotifierProvider.notifier).updateProfile(profile);
    if (!mounted) return;
    if (ok) {
      if (mounted) context.pop();
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
          'تعديل البروفايل',
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
                AppTextField(
                  controller: _nameController,
                  validator: (v) => Validators.required(v, 'الاسم'),
                  decoration: InputDecoration(
                    labelText: 'الاسم',
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _tradeNameController,
                  decoration: InputDecoration(
                    labelText: 'الاسم التجاري',
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v != null && v.trim().isEmpty ? null : Validators.email(v),
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  validator: Validators.phone,
                  decoration: InputDecoration(
                    labelText: 'رقم الهاتف',
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'الوصف',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'العنوان',
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: 'المدينة',
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.xlV,
                PrimaryButton(
                  label: saving ? 'جاري الحفظ...' : 'حفظ',
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
