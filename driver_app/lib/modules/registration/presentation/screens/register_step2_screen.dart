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
import '../../data/models/register_step2_dto.dart';
import '../../../shared/enums/license_type.dart';
import '../../../shared/enums/vehicle_type.dart';
import '../widgets/document_upload_widget.dart';
import '../widgets/registration_progress_indicator.dart';

class RegisterStep2Screen extends ConsumerStatefulWidget {
  final String driverId;

  const RegisterStep2Screen({
    super.key,
    required this.driverId,
  });

  @override
  ConsumerState<RegisterStep2Screen> createState() => _RegisterStep2ScreenState();
}

class _RegisterStep2ScreenState extends ConsumerState<RegisterStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();
  
  // Personal Identity
  final _fullNameController = TextEditingController();
  DateTime? _dateOfBirth;
  String? _gender;
  final _nationalityController = TextEditingController();

  // License
  final _licenseNumberController = TextEditingController();
  LicenseType? _licenseType;
  DateTime? _licenseIssueDate;
  DateTime? _licenseExpiryDate;
  final _licenseIssuingAuthorityController = TextEditingController();
  String? _licensePhotoFront;
  String? _licensePhotoBack;

  // Vehicle
  VehicleType? _vehicleType;
  final _vehicleMakeController = TextEditingController();
  final _vehicleModelController = TextEditingController();
  final _vehicleYearController = TextEditingController();
  final _vehicleColorController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _plateRegionController = TextEditingController();
  final _vehicleRegistrationNumberController = TextEditingController();
  DateTime? _vehicleRegistrationExpiry;
  String? _vehiclePhoto;
  String? _vehicleAuthorizationPhoto;

  // Contact
  final _emailController = TextEditingController();
  final _emergencyContactNameController = TextEditingController();
  final _emergencyContactPhoneController = TextEditingController();
  final _addressStreetController = TextEditingController();
  final _addressCityController = TextEditingController();
  final _addressRegionController = TextEditingController();
  final _addressPostalCodeController = TextEditingController();

  // Consents
  bool _termsAccepted = false;
  bool _privacyAccepted = false;
  bool _backgroundCheckConsent = false;
  bool _locationTrackingConsent = false;
  bool _dataProcessingConsent = false;

  bool _isLoading = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _nationalityController.dispose();
    _licenseNumberController.dispose();
    _licenseIssuingAuthorityController.dispose();
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleYearController.dispose();
    _vehicleColorController.dispose();
    _plateNumberController.dispose();
    _plateRegionController.dispose();
    _vehicleRegistrationNumberController.dispose();
    _emailController.dispose();
    _emergencyContactNameController.dispose();
    _emergencyContactPhoneController.dispose();
    _addressStreetController.dispose();
    _addressCityController.dispose();
    _addressRegionController.dispose();
    _addressPostalCodeController.dispose();
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
        if (next is RegistrationStep2Success) {
          context.push(
            RouteNames.registerStep3,
            extra: next.driverId,
          );
        } else if (next is RegistrationError) {
          AppSnackbar.showError(context, next.message);
        }
      },
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Registration - Step 2', style: TextStyles.headlineMedium),
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
              RegistrationProgressIndicator(currentStep: 2, totalSteps: 3),
              Gaps.xlV,

              // Personal Identity Section
              _buildSectionTitle('Personal Identity'),
              Gaps.mdV,
              AppTextField(
                controller: _fullNameController,
                label: 'Full Name',
                validator: (v) => AppValidators.required(v, fieldName: 'Full Name'),
              ),
              Gaps.mdV,
              _buildDatePicker(
                label: 'Date of Birth',
                value: _dateOfBirth,
                onChanged: (date) => setState(() => _dateOfBirth = date),
              ),
              Gaps.mdV,
              _buildGenderSelector(),
              Gaps.mdV,
              AppTextField(
                controller: _nationalityController,
                label: 'Nationality',
                validator: (v) => AppValidators.required(v, fieldName: 'Nationality'),
              ),
              Gaps.xlV,

              // License Section
              _buildSectionTitle('Driver License'),
              Gaps.mdV,
              AppTextField(
                controller: _licenseNumberController,
                label: 'License Number',
                validator: (v) => AppValidators.required(v, fieldName: 'License Number'),
              ),
              Gaps.mdV,
              _buildLicenseTypeSelector(),
              Gaps.mdV,
              _buildDatePicker(
                label: 'License Issue Date',
                value: _licenseIssueDate,
                onChanged: (date) => setState(() => _licenseIssueDate = date),
              ),
              Gaps.mdV,
              _buildDatePicker(
                label: 'License Expiry Date',
                value: _licenseExpiryDate,
                onChanged: (date) => setState(() => _licenseExpiryDate = date),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _licenseIssuingAuthorityController,
                label: 'Issuing Authority',
                validator: (v) => AppValidators.required(v, fieldName: 'Issuing Authority'),
              ),
              Gaps.mdV,
              DocumentUploadWidget(
                label: 'License Photo (Front)',
                onUploaded: (url) => setState(() => _licensePhotoFront = url),
              ),
              Gaps.mdV,
              DocumentUploadWidget(
                label: 'License Photo (Back)',
                onUploaded: (url) => setState(() => _licensePhotoBack = url),
              ),
              Gaps.xlV,

              // Vehicle Section
              _buildSectionTitle('Vehicle Information'),
              Gaps.mdV,
              _buildVehicleTypeSelector(),
              Gaps.mdV,
              AppTextField(
                controller: _vehicleMakeController,
                label: 'Vehicle Make',
                validator: (v) => AppValidators.required(v, fieldName: 'Vehicle Make'),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _vehicleModelController,
                label: 'Vehicle Model',
                validator: (v) => AppValidators.required(v, fieldName: 'Vehicle Model'),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _vehicleYearController,
                label: 'Vehicle Year',
                keyboardType: TextInputType.number,
                validator: (v) => AppValidators.required(v, fieldName: 'Vehicle Year'),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              Gaps.mdV,
              AppTextField(
                controller: _vehicleColorController,
                label: 'Vehicle Color',
                validator: (v) => AppValidators.required(v, fieldName: 'Vehicle Color'),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _plateNumberController,
                label: 'Plate Number',
                validator: (v) => AppValidators.required(v, fieldName: 'Plate Number'),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _plateRegionController,
                label: 'Plate Region',
                validator: (v) => AppValidators.required(v, fieldName: 'Plate Region'),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _vehicleRegistrationNumberController,
                label: 'Registration Number',
                validator: (v) => AppValidators.required(v, fieldName: 'Registration Number'),
              ),
              Gaps.mdV,
              _buildDatePicker(
                label: 'Registration Expiry',
                value: _vehicleRegistrationExpiry,
                onChanged: (date) => setState(() => _vehicleRegistrationExpiry = date),
              ),
              Gaps.mdV,
              DocumentUploadWidget(
                label: 'Vehicle Photo',
                onUploaded: (url) => setState(() => _vehiclePhoto = url),
              ),
              Gaps.xlV,

              // Contact Section
              _buildSectionTitle('Contact Information'),
              Gaps.mdV,
              AppTextField(
                controller: _emailController,
                label: 'Email (Optional)',
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v?.isNotEmpty == true ? AppValidators.email(v) : null,
              ),
              Gaps.mdV,
              AppTextField(
                controller: _emergencyContactNameController,
                label: 'Emergency Contact Name',
                validator: (v) => AppValidators.required(v, fieldName: 'Emergency Contact Name'),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _emergencyContactPhoneController,
                label: 'Emergency Contact Phone',
                keyboardType: TextInputType.phone,
                validator: AppValidators.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              Gaps.xlV,

              // Address Section
              _buildSectionTitle('Address'),
              Gaps.mdV,
              AppTextField(
                controller: _addressStreetController,
                label: 'Street Address',
                validator: (v) => AppValidators.required(v, fieldName: 'Street Address'),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _addressCityController,
                label: 'City',
                validator: (v) => AppValidators.required(v, fieldName: 'City'),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _addressRegionController,
                label: 'Region',
                validator: (v) => AppValidators.required(v, fieldName: 'Region'),
              ),
              Gaps.mdV,
              AppTextField(
                controller: _addressPostalCodeController,
                label: 'Postal Code (Optional)',
                keyboardType: TextInputType.number,
              ),
              Gaps.xlV,

              // Consents Section
              _buildSectionTitle('Legal Consents'),
              Gaps.mdV,
              _buildConsentCheckbox(
                'I accept the Terms and Conditions',
                _termsAccepted,
                (v) => setState(() => _termsAccepted = v),
              ),
              Gaps.smV,
              _buildConsentCheckbox(
                'I accept the Privacy Policy',
                _privacyAccepted,
                (v) => setState(() => _privacyAccepted = v),
              ),
              Gaps.smV,
              _buildConsentCheckbox(
                'I consent to background check',
                _backgroundCheckConsent,
                (v) => setState(() => _backgroundCheckConsent = v),
              ),
              Gaps.smV,
              _buildConsentCheckbox(
                'I consent to location tracking',
                _locationTrackingConsent,
                (v) => setState(() => _locationTrackingConsent = v),
              ),
              Gaps.smV,
              _buildConsentCheckbox(
                'I consent to data processing',
                _dataProcessingConsent,
                (v) => setState(() => _dataProcessingConsent = v),
              ),
              Gaps.xlV,

              // Submit Button
              PrimaryButton(
                onPressed: _isLoading ? null : _submit,
                text: 'Continue to Step 3',
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
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
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

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Gaps.smV,
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Male'),
                value: 'male',
                groupValue: _gender,
                onChanged: (v) => setState(() => _gender = v),
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Female'),
                value: 'female',
                groupValue: _gender,
                onChanged: (v) => setState(() => _gender = v),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLicenseTypeSelector() {
    return DropdownButtonFormField<LicenseType>(
      decoration: const InputDecoration(
        labelText: 'License Type',
      ),
      value: _licenseType,
      items: LicenseType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.displayName),
        );
      }).toList(),
      onChanged: (value) => setState(() => _licenseType = value),
      validator: (v) => v == null ? 'License type is required' : null,
    );
  }

  Widget _buildVehicleTypeSelector() {
    return DropdownButtonFormField<VehicleType>(
      decoration: const InputDecoration(
        labelText: 'Vehicle Type',
      ),
      value: _vehicleType,
      items: VehicleType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.displayName),
        );
      }).toList(),
      onChanged: (value) => setState(() => _vehicleType = value),
      validator: (v) => v == null ? 'Vehicle type is required' : null,
    );
  }

  Widget _buildConsentCheckbox(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return CheckboxListTile(
      title: Text(label, style: TextStyles.bodyMedium),
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_validateRequiredFields()) return;

    setState(() => _isLoading = true);

    try {
      final dto = RegisterStep2Dto(
        fullName: _fullNameController.text.trim(),
        dateOfBirth: DateFormat('yyyy-MM-dd').format(_dateOfBirth!),
        gender: _gender!,
        nationality: _nationalityController.text.trim(),
        licenseNumber: _licenseNumberController.text.trim(),
        licenseType: _licenseType!,
        licenseIssueDate: DateFormat('yyyy-MM-dd').format(_licenseIssueDate!),
        licenseExpiryDate: DateFormat('yyyy-MM-dd').format(_licenseExpiryDate!),
        licenseIssuingAuthority: _licenseIssuingAuthorityController.text.trim(),
        licensePhotoFront: _licensePhotoFront ?? '',
        licensePhotoBack: _licensePhotoBack ?? '',
        vehicleType: _vehicleType!,
        vehicleMake: _vehicleMakeController.text.trim(),
        vehicleModel: _vehicleModelController.text.trim(),
        vehicleYear: _vehicleYearController.text.trim(),
        vehicleColor: _vehicleColorController.text.trim(),
        plateNumber: _plateNumberController.text.trim(),
        plateRegion: _plateRegionController.text.trim(),
        vehicleRegistrationNumber: _vehicleRegistrationNumberController.text.trim(),
        vehicleRegistrationExpiry: DateFormat('yyyy-MM-dd').format(_vehicleRegistrationExpiry!),
        vehiclePhoto: _vehiclePhoto ?? '',
        vehicleAuthorizationPhoto: _vehicleAuthorizationPhoto,
        email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        emergencyContactName: _emergencyContactNameController.text.trim(),
        emergencyContactPhone: _emergencyContactPhoneController.text.trim(),
        address: Address(
          street: _addressStreetController.text.trim(),
          city: _addressCityController.text.trim(),
          region: _addressRegionController.text.trim(),
          postalCode: _addressPostalCodeController.text.trim().isEmpty
              ? null
              : _addressPostalCodeController.text.trim(),
        ),
        termsAndConditionsAccepted: _termsAccepted,
        privacyPolicyAccepted: _privacyAccepted,
        backgroundCheckConsent: _backgroundCheckConsent,
        locationTrackingConsent: _locationTrackingConsent,
        dataProcessingConsent: _dataProcessingConsent,
      );

      await ref
          .read(registrationNotifierProvider.notifier)
          .registerStep2(widget.driverId, dto);
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
    if (_dateOfBirth == null) {
      AppSnackbar.showError(context, 'Date of birth is required');
      return false;
    }
    if (_gender == null) {
      AppSnackbar.showError(context, 'Gender is required');
      return false;
    }
    if (_licenseType == null) {
      AppSnackbar.showError(context, 'License type is required');
      return false;
    }
    if (_licenseIssueDate == null || _licenseExpiryDate == null) {
      AppSnackbar.showError(context, 'License dates are required');
      return false;
    }
    if (_licensePhotoFront == null || _licensePhotoBack == null) {
      AppSnackbar.showError(context, 'License photos are required');
      return false;
    }
    if (_vehicleType == null) {
      AppSnackbar.showError(context, 'Vehicle type is required');
      return false;
    }
    if (_vehicleRegistrationExpiry == null) {
      AppSnackbar.showError(context, 'Vehicle registration expiry is required');
      return false;
    }
    if (_vehiclePhoto == null) {
      AppSnackbar.showError(context, 'Vehicle photo is required');
      return false;
    }
    if (!_termsAccepted || !_privacyAccepted) {
      AppSnackbar.showError(context, 'You must accept terms and privacy policy');
      return false;
    }
    return true;
  }
}
