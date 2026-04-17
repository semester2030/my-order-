import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/validators.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/branded_logo.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/core/location/register_location_helper.dart';
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
  (value: 'popular_cooking', labelAr: 'طبخ الذبائح'),
  (value: 'home_cooking', labelAr: 'مطبخ منزلي'),
  (value: 'private_events', labelAr: 'المناسبات والحفلات'),
  (value: 'grilling', labelAr: 'الشواء الخارجي'),
];

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _selectedProviderCategory;
  bool _locationBusy = false;
  /// إظهار حقول الإحداثيات فقط عند الطلب (بدل عرضها دائماً).
  bool _showManualCoords = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
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

  Future<void> _useCurrentLocation() async {
    final l10n = AppLocalizations.of(context);
    if (_locationBusy) return;
    setState(() => _locationBusy = true);
    final out = await RegisterLocationHelper.obtainCurrent();
    if (!mounted) return;
    setState(() => _locationBusy = false);

    if (out.err != null) {
      final msg = switch (out.err!) {
        RegisterLocationPickError.serviceDisabled => l10n.registerLocationServiceDisabled,
        RegisterLocationPickError.permissionDenied => l10n.registerLocationPermissionDenied,
        RegisterLocationPickError.permissionDeniedForever =>
          l10n.registerLocationPermissionForever,
        RegisterLocationPickError.positionUnavailable => l10n.registerLocationPositionUnavailable,
      };
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: SemanticColors.error,
        ),
      );
      return;
    }

    final d = out.data!;
    setState(() {
      _latitudeController.text = d.latitude.toStringAsFixed(6);
      _longitudeController.text = d.longitude.toStringAsFixed(6);
      final addr = d.suggestedAddress?.trim();
      if (addr != null && addr.length >= 3) {
        _addressController.text = addr;
      }
      final city = d.suggestedCity?.trim();
      if (city != null && city.length >= 2) {
        _cityController.text = city;
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final lat = double.tryParse(
      _latitudeController.text.trim().replaceAll(',', '.'),
    );
    final lng = double.tryParse(
      _longitudeController.text.trim().replaceAll(',', '.'),
    );
    final l10n = AppLocalizations.of(context);
    if (lat == null || lng == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.registerNeedLocationOrManual),
          backgroundColor: SemanticColors.error,
        ),
      );
      setState(() => _showManualCoords = true);
      return;
    }
    if (lat.abs() < 1e-9 && lng.abs() < 1e-9) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.registerCoordinatesZero),
          backgroundColor: SemanticColors.error,
        ),
      );
      setState(() => _showManualCoords = true);
      return;
    }
    final request = RegisterVendorRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      latitude: lat,
      longitude: lng,
      phoneNumber: _phoneController.text.trim().isEmpty
          ? null
          : _phoneController.text.trim(),
      providerCategory: _selectedProviderCategory,
    );
    ref.read(authNotifierProvider.notifier).register(request);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
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
          l10n.createAccount,
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
                  child: BrandedLogo(
                    assetPath: 'assets/images/logo.jpeg',
                    size: 220,
                    cornerRadius: 100,
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
                  l10n.registerSubtitleWithLocation,
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
                Gaps.lgV,
                Text(
                  l10n.registerServiceLocationTitle,
                  style: TextStyles.titleMedium.copyWith(color: AppColors.textPrimary),
                ),
                Gaps.smV,
                Text(
                  l10n.registerCoordinatesHint,
                  style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                Gaps.mdV,
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: (_locationBusy || authState is AuthLoading) ? null : _useCurrentLocation,
                  icon: _locationBusy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.my_location_outlined),
                  label: Text(
                    _locationBusy ? l10n.registerFetchingLocation : l10n.registerUseMyLocation,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _addressController,
                  validator: (v) => Validators.minLength(v, 3, l10n.registerStreetAddressLabel),
                  decoration: InputDecoration(
                    labelText: l10n.registerStreetAddressLabel,
                    hintText: l10n.registerStreetAddressHint,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.mdAll,
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _cityController,
                  validator: (v) => Validators.minLength(v, 2, l10n.registerCityLabel),
                  decoration: InputDecoration(
                    labelText: l10n.registerCityLabel,
                    hintText: l10n.registerCityHint,
                    border: OutlineInputBorder(
                      borderRadius: AppRadius.mdAll,
                    ),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.smV,
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: TextButton(
                    onPressed: () => setState(() => _showManualCoords = !_showManualCoords),
                    child: Text(
                      _showManualCoords
                          ? l10n.registerHideManualCoordinates
                          : l10n.registerManualCoordinates,
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                if (_showManualCoords) ...[
                  Text(
                    l10n.registerMapsPasteHint,
                    style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  Gaps.smV,
                  AppTextField(
                    controller: _latitudeController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    validator: Validators.latitude,
                    decoration: InputDecoration(
                      labelText: l10n.registerLatitudeLabel,
                      hintText: '24.7136',
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.mdAll,
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                  ),
                  Gaps.mdV,
                  AppTextField(
                    controller: _longitudeController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                    validator: Validators.longitude,
                    decoration: InputDecoration(
                      labelText: l10n.registerLongitudeLabel,
                      hintText: '46.6753',
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.mdAll,
                      ),
                      filled: true,
                      fillColor: AppColors.surface,
                    ),
                  ),
                  Gaps.mdV,
                ],
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
