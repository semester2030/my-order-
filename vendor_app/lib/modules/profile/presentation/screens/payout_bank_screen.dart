import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/validators.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/profile/domain/entities/vendor_profile.dart';
import 'package:vendor_app/modules/profile/presentation/providers/profile_state.dart';

/// بيانات التحويل البنكي لمقدّم الخدمة — PUT `/vendors/profile` (حقول بنك فقط).
class PayoutBankScreen extends ConsumerStatefulWidget {
  const PayoutBankScreen({super.key});

  @override
  ConsumerState<PayoutBankScreen> createState() => _PayoutBankScreenState();
}

class _PayoutBankScreenState extends ConsumerState<PayoutBankScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bankName = TextEditingController();
  final _bankAccount = TextEditingController();
  final _iban = TextEditingController();
  final _holder = TextEditingController();
  final _swift = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = ref.read(profileNotifierProvider);
      if (state is ProfileLoaded) {
        _fill(state.profile);
      } else {
        ref.read(profileNotifierProvider.notifier).loadProfile();
      }
    });
  }

  void _fill(VendorProfile p) {
    _bankName.text = p.bankName ?? '';
    _bankAccount.text = p.bankAccountNumber ?? '';
    _iban.text = p.iban ?? '';
    _holder.text = p.accountHolderName ?? '';
    _swift.text = p.swiftCode ?? '';
  }

  @override
  void dispose() {
    _bankName.dispose();
    _bankAccount.dispose();
    _iban.dispose();
    _holder.dispose();
    _swift.dispose();
    super.dispose();
  }

  VendorProfile _mergedProfile(VendorProfile o) {
    final ibanRaw = _iban.text.trim().replaceAll(RegExp(r'\s'), '');
    return VendorProfile(
      id: o.id,
      name: o.name,
      tradeName: o.tradeName,
      email: o.email,
      phoneNumber: o.phoneNumber,
      description: o.description,
      address: o.address,
      city: o.city,
      providerCategory: o.providerCategory,
      popularCookingAddOns: o.popularCookingAddOns,
      isActive: o.isActive,
      isAcceptingOrders: o.isAcceptingOrders,
      registrationStatus: o.registrationStatus,
      rejectionReason: o.rejectionReason,
      bankName: _bankName.text.trim().isEmpty ? null : _bankName.text.trim(),
      bankAccountNumber:
          _bankAccount.text.trim().isEmpty ? null : _bankAccount.text.trim(),
      iban: ibanRaw.isEmpty ? null : ibanRaw.toUpperCase(),
      accountHolderName: _holder.text.trim().isEmpty ? null : _holder.text.trim(),
      swiftCode: _swift.text.trim().isEmpty ? null : _swift.text.trim(),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final current = ref.read(profileNotifierProvider);
    if (current is! ProfileLoaded) return;
    final ok = await ref.read(profileNotifierProvider.notifier).updateProfile(
          _mergedProfile(current.profile),
          bankingFieldsOnly: true,
        );
    if (!mounted) return;
    if (ok) {
      context.pop();
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
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(profileNotifierProvider);
    final saving = state is ProfileSaving;

    ref.listen<ProfileState>(profileNotifierProvider, (prev, next) {
      if (next is ProfileLoaded && prev is! ProfileLoaded) {
        _fill(next.profile);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          l10n.payoutBankTitle,
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
                Gaps.mdV,
                Text(
                  l10n.payoutBankSubtitle,
                  style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                Gaps.lgV,
                AppTextField(
                  controller: _bankName,
                  decoration: InputDecoration(
                    labelText: l10n.labelBankName,
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _bankAccount,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.labelBankAccountNumber,
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _iban,
                  validator: Validators.saIbanOptional,
                  decoration: InputDecoration(
                    labelText: l10n.labelIban,
                    hintText: 'SA…',
                    helperText: l10n.ibanHint,
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _holder,
                  decoration: InputDecoration(
                    labelText: l10n.labelAccountHolderName,
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _swift,
                  decoration: InputDecoration(
                    labelText: l10n.labelSwiftCode,
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.xlV,
                PrimaryButton(
                  label: saving ? l10n.loading : l10n.savePayoutBank,
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
