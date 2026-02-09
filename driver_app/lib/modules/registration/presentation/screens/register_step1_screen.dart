import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/utils/validators.dart';
import '../providers/registration_notifier.dart';
import '../providers/registration_state.dart';
import '../../data/models/register_step1_dto.dart';

class RegisterStep1Screen extends ConsumerStatefulWidget {
  const RegisterStep1Screen({super.key});

  @override
  ConsumerState<RegisterStep1Screen> createState() => _RegisterStep1ScreenState();
}

class _RegisterStep1ScreenState extends ConsumerState<RegisterStep1Screen> {
  final _formKey = GlobalKey<FormState>();
  final _nationalIdController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nationalIdController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // Listen to registration success
    ref.listen<RegistrationState>(
      registrationNotifierProvider,
      (previous, next) {
        if (next is RegistrationStep1Success) {
          context.push(
            RouteNames.registerStep2,
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
        title: Text('Registration - Step 1', style: TextStyles.headlineMedium),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.lg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Basic Information',
                style: TextStyles.headlineLarge,
              ),
              Gaps.smV,
              Text(
                'Enter your national ID and phone number to start registration',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Gaps.xlV,

              // National ID
              AppTextField(
                controller: _nationalIdController,
                label: 'National ID',
                hint: '1234567890',
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'National ID is required';
                  }
                  if (value.length != 10) {
                    return 'National ID must be 10 digits';
                  }
                  return null;
                },
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              Gaps.lgV,

              // Phone Number
              AppTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: '0501234567',
                keyboardType: TextInputType.phone,
                validator: AppValidators.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              Gaps.xlV,

              // Submit Button
              PrimaryButton(
                onPressed: _isLoading ? null : _submit,
                text: 'Continue',
                isLoading: _isLoading,
              ),
              Gaps.lgV,
              
              // Login Link
              Center(
                child: TextButton(
                  onPressed: _isLoading ? null : () {
                    context.go(RouteNames.phoneInput);
                  },
                  child: RichText(
                    text: TextSpan(
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        const TextSpan(text: 'Already have an account? '),
                        TextSpan(
                          text: 'Login',
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final dto = RegisterStep1Dto(
        nationalId: _nationalIdController.text.trim(),
        phoneNumber: _phoneController.text.trim(),
      );

      await ref.read(registrationNotifierProvider.notifier).registerStep1(dto);
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
}
