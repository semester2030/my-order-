import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../providers/registration_notifier.dart';
import '../providers/registration_state.dart';
import '../../data/models/register_step3_dto.dart';
import '../widgets/document_upload_widget.dart';
import '../widgets/registration_progress_indicator.dart';

class RegisterStep3Screen extends ConsumerStatefulWidget {
  final String driverId;

  const RegisterStep3Screen({
    super.key,
    required this.driverId,
  });

  @override
  ConsumerState<RegisterStep3Screen> createState() => _RegisterStep3ScreenState();
}

class _RegisterStep3ScreenState extends ConsumerState<RegisterStep3Screen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  // Insurance
  final _insuranceCompanyController = TextEditingController();
  final _insurancePolicyNumberController = TextEditingController();
  DateTime? _insuranceStartDate;
  DateTime? _insuranceExpiryDate;
  final _insuranceCoverageTypeController = TextEditingController();
  String? _insurancePhoto;

  // Banking
  final _bankNameController = TextEditingController();
  final _accountNumberController = TextEditingController();
  final _accountHolderNameController = TextEditingController();
  final _ibanController = TextEditingController();
  final _swiftCodeController = TextEditingController();

  // Optional: Health
  bool? _hasMedicalConditions;
  final List<String> _medicalConditions = [];
  String? _bloodType;
  final List<String> _allergies = [];

  // Optional: Additional
  String? _profilePhoto;
  final List<String> _languages = [];
  final _experienceYearsController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _insuranceCompanyController.dispose();
    _insurancePolicyNumberController.dispose();
    _insuranceCoverageTypeController.dispose();
    _bankNameController.dispose();
    _accountNumberController.dispose();
    _accountHolderNameController.dispose();
    _ibanController.dispose();
    _swiftCodeController.dispose();
    _experienceYearsController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registrationState = ref.watch(registrationNotifierProvider);

    // Listen to registration success
    ref.listen<RegistrationState>(
      registrationNotifierProvider,
      (previous, next) {
        if (next is RegistrationStep3Success) {
          context.go(RouteNames.trackApplication);
        } else if (next is RegistrationError) {
          AppSnackbar.showError(context, next.message);
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Registration - Step 3', style: TextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.all(Insets.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Indicator
              RegistrationProgressIndicator(currentStep: 3, totalSteps: 3),
              Gaps.xlV,

              // Insurance Section
              _buildSectionTitle('Insurance Information'),
              Gaps.mdV,
              AppTextField(
                controller: _insuranceCompanyController,
                label: 'Insurance Company',
                validator: (v) => AppValidators.required(v, fieldName: 'Insurance Company'),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _insurancePolicyNumberController,
                label: 'Policy Number',
                validator: (v) => AppValidators.required(v, fieldName: 'Policy Number'),
              ),
              Gaps.mdV,
              _buildDatePicker(
                label: 'Insurance Start Date',
                value: _insuranceStartDate,
                onChanged: (date) => setState(() => _insuranceStartDate = date),
              ),
              Gaps.mdV,
              _buildDatePicker(
                label: 'Insurance Expiry Date',
                value: _insuranceExpiryDate,
                onChanged: (date) => setState(() => _insuranceExpiryDate = date),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _insuranceCoverageTypeController,
                label: 'Coverage Type',
                validator: (v) => AppValidators.required(v, fieldName: 'Coverage Type'),
              ),
              Gaps.mdV,
              DocumentUploadWidget(
                label: 'Insurance Document',
                onUploaded: (url) => setState(() => _insurancePhoto = url),
              ),
              Gaps.xlV,

              // Banking Section
              _buildSectionTitle('Banking Information'),
              Gaps.mdV,
              AppTextField(
                controller: _bankNameController,
                label: 'Bank Name',
                validator: (v) => AppValidators.required(v, fieldName: 'Bank Name'),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _accountNumberController,
                label: 'Account Number',
                validator: (v) => AppValidators.required(v, fieldName: 'Account Number'),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _accountHolderNameController,
                label: 'Account Holder Name',
                validator: (v) => AppValidators.required(v, fieldName: 'Account Holder Name'),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _ibanController,
                label: 'IBAN (Optional)',
              ),
              Gaps.mdV,
              AppTextField(
                controller: _swiftCodeController,
                label: 'SWIFT Code (Optional)',
              ),
              Gaps.xlV,

              // Optional: Profile Photo
              _buildSectionTitle('Additional Information (Optional)'),
              Gaps.mdV,
              DocumentUploadWidget(
                label: 'Profile Photo',
                onUploaded: (url) => setState(() => _profilePhoto = url),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _experienceYearsController,
                label: 'Experience Years (Optional)',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              Gaps.xlV,

              // Submit Button
              PrimaryButton(
                onPressed: _isLoading ? null : _submit,
                text: 'Complete Registration',
                isLoading: _isLoading,
              ),
              Gaps.xlV,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyles.titleLarge,
    );
  }

  Widget _buildDatePicker({
    required String label,
    required DateTime? value,
    required ValueChanged<DateTime> onChanged,
  }) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          onChanged(date);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          value != null ? DateFormat('yyyy-MM-dd').format(value) : 'Select date',
          style: TextStyles.bodyLarge.copyWith(
            color: value != null ? AppColors.textPrimary : AppColors.textTertiary,
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_validateRequiredFields()) return;

    setState(() => _isLoading = true);

    try {
      final dto = RegisterStep3Dto(
        insuranceCompany: _insuranceCompanyController.text.trim(),
        insurancePolicyNumber: _insurancePolicyNumberController.text.trim(),
        insuranceStartDate: DateFormat('yyyy-MM-dd').format(_insuranceStartDate!),
        insuranceExpiryDate: DateFormat('yyyy-MM-dd').format(_insuranceExpiryDate!),
        insuranceCoverageType: _insuranceCoverageTypeController.text.trim(),
        insurancePhoto: _insurancePhoto ?? '',
        bankName: _bankNameController.text.trim(),
        accountNumber: _accountNumberController.text.trim(),
        accountHolderName: _accountHolderNameController.text.trim(),
        iban: _ibanController.text.trim().isEmpty ? null : _ibanController.text.trim(),
        swiftCode: _swiftCodeController.text.trim().isEmpty
            ? null
            : _swiftCodeController.text.trim(),
        hasMedicalConditions: _hasMedicalConditions,
        medicalConditions: _medicalConditions.isEmpty ? null : _medicalConditions,
        bloodType: _bloodType,
        allergies: _allergies.isEmpty ? null : _allergies,
        profilePhoto: _profilePhoto,
        languages: _languages.isEmpty ? null : _languages,
        experienceYears: _experienceYearsController.text.trim().isEmpty
            ? null
            : int.tryParse(_experienceYearsController.text.trim()),
      );

      await ref
          .read(registrationNotifierProvider.notifier)
          .registerStep3(widget.driverId, dto);
    } catch (e) {
      if (mounted) {
        AppSnackbar.showError(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _validateRequiredFields() {
    if (_insuranceStartDate == null || _insuranceExpiryDate == null) {
      AppSnackbar.showError(context, 'Insurance dates are required');
      return false;
    }
    if (_insurancePhoto == null) {
      AppSnackbar.showError(context, 'Insurance document is required');
      return false;
    }
    return true;
  }
}
