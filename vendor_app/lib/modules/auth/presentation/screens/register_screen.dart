import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/validators.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/modules/auth/domain/entities/register_vendor_request.dart';
import 'package:vendor_app/modules/auth/presentation/providers/auth_state.dart';

/// Register screen — ثيم موحد (design_system).
class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

/// أنواع مقدم الخدمة حسب الباك اند — نفس الويب.
const List<({String value, String labelAr})> _providerCategories = [
  (value: 'popular_cooking', labelAr: 'طبخ شعبي'),
  (value: 'home_cooking', labelAr: 'مطبخ منزلي'),
  (value: 'private_events', labelAr: 'مناسبات خاصة'),
  (value: 'grilling', labelAr: 'شوي'),
];

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedProviderCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  /// رسالة تعارض البريد كمقدّم خدمة من الباك اند (409).
  bool _isDuplicateVendorEmailMessage(String? msg) {
    if (msg == null || msg.isEmpty) return false;
    final m = msg.toLowerCase();
    return m.contains('مسجّل مسبقاً') ||
        m.contains('مسجل مسبقا') ||
        m.contains('كمقدّم خدمة') ||
        m.contains('كمقدم خدمة') ||
        m.contains('already registered');
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final request = RegisterVendorRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      phoneNumber: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      providerCategory: _selectedProviderCategory,
    );
    ref.read(authNotifierProvider.notifier).register(request);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    ref.listen<AuthState>(authNotifierProvider, (prev, next) {
      if (prev is AuthLoading && next is AuthUnauthenticated && context.mounted) {
        final l10n = AppLocalizations.of(context);
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            icon: Icon(
              Icons.mark_email_read_outlined,
              color: AppColors.primary,
              size: 40,
            ),
            title: Text(l10n.registerSuccessTitle),
            content: SingleChildScrollView(
              child: Text(
                l10n.registerSuccessBody,
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                  height: 1.45,
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.go(RouteNames.login);
                },
                child: Text(l10n.registerSuccessGoLogin),
              ),
            ],
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'إنشاء حساب',
          style: TextStyles.headlineSmall,
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
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(80),
                    child: Image.asset(
                      'assets/images/logo.jpeg',
                      width: 180,
                      height: 180,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(
                        Icons.restaurant,
                        size: 180,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                Gaps.lgV,
                Text(
                  'تسجيل مقدم خدمة جديد',
                  style: TextStyles.headlineMedium.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                Gaps.smV,
                Text(
                  'الاسم، البريد، وكلمة المرور مطلوبة',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Gaps.xlV,
                AppTextField(
                  controller: _nameController,
                  validator: (v) => Validators.required(v, 'اسم مقدم الخدمة'),
                  decoration: InputDecoration(
                    labelText: 'اسم مقدم الخدمة',
                    hintText: 'مطبخ أم محمد',
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.mdAll,
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.email,
                  decoration: InputDecoration(
                    labelText: 'البريد الإلكتروني',
                    hintText: 'vendor@example.com',
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.mdAll,
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: Validators.password,
                  decoration: InputDecoration(
                    labelText: 'كلمة المرور',
                    hintText: '8+ أحرف، حرف كبير وصغير ورقم',
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.mdAll,
                    ),
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
                    labelText: 'رقم الجوال (اختياري)',
                    hintText: '05xxxxxxxx',
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.mdAll,
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                DropdownButtonFormField<String?>(
                  value: _selectedProviderCategory,
                  decoration: InputDecoration(
                    labelText: 'نوع الخدمة',
                    hintText: 'اختر نوع الخدمة',
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.mdAll,
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('— اختر نوع الخدمة —'),
                    ),
                    ..._providerCategories.map(
                      (e) => DropdownMenuItem<String?>(
                        value: e.value,
                        child: Text(e.labelAr),
                      ),
                    ),
                  ],
                  onChanged: (v) => setState(() => _selectedProviderCategory = v),
                ),
                if (authState is AuthError) ...[
                  Gaps.mdV,
                  Text(
                    AppLocalizations.of(context).messageForAuthError(
                      authState.type?.name,
                      fallbackMessage: authState.message,
                    ),
                    style: TextStyles.bodySmall.copyWith(
                      color: SemanticColors.error,
                    ),
                  ),
                  if (_isDuplicateVendorEmailMessage(authState.message)) ...[
                    Gaps.smV,
                    Text(
                      'للمتابعة: سجّل الدخول بنفس البريد وكلمة المرور — لا حاجة لإنشاء حساب جديد.',
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.go(RouteNames.login),
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
                Gaps.xlV,
                PrimaryButton(
                  label: authState is AuthLoading ? 'جاري التسجيل...' : 'تسجيل',
                  onPressed: authState is AuthLoading ? null : _submit,
                ),
                Gaps.lgV,
                TextButton(
                  onPressed: () => context.go(RouteNames.login),
                  child: Text(
                    'لديك حساب؟ تسجيل الدخول',
                    style: TextStyles.bodyMedium.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
