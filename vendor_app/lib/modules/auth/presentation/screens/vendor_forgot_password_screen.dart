import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/utils/result.dart';
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/validators.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';

/// استعادة كلمة مرور مقدّم الخدمة: طلب رمز بالبريد ثم تعيين كلمة مرور جديدة.
class VendorForgotPasswordScreen extends ConsumerStatefulWidget {
  const VendorForgotPasswordScreen({super.key});

  @override
  ConsumerState<VendorForgotPasswordScreen> createState() =>
      _VendorForgotPasswordScreenState();
}

class _VendorForgotPasswordScreenState
    extends ConsumerState<VendorForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formEmail = GlobalKey<FormState>();
  final _formReset = GlobalKey<FormState>();

  int _step = 0;
  bool _loading = false;
  String? _error;
  String? _info;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _requestCode() async {
    if (!(_formEmail.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = null;
      _info = null;
    });
    final repo = ref.read(authRepoProvider);
    final result =
        await repo.requestVendorPasswordReset(_emailController.text.trim());
    if (!mounted) return;
    result.when(
      success: (data) {
        setState(() {
          _loading = false;
          _info = data.message;
          _step = 1;
        });
        if (data.devOtp != null && data.devOtp!.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            showDialog<void>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('وضع التطوير'),
                content: Text(
                  'رمز الاختبار المعروض من الخادم: ${data.devOtp}\n'
                  '(لا يظهر في الإنتاج)',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    child: const Text('حسناً'),
                  ),
                ],
              ),
            );
          });
        }
      },
      failure: (f) {
        setState(() {
          _loading = false;
          _error = f.message;
        });
      },
    );
  }

  Future<void> _confirmReset() async {
    if (!(_formReset.currentState?.validate() ?? false)) return;
    final p = _passwordController.text;
    if (p != _confirmController.text) {
      setState(() => _error = 'تأكيد كلمة المرور غير متطابق');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    final repo = ref.read(authRepoProvider);
    final result = await repo.confirmVendorPasswordReset(
      email: _emailController.text.trim(),
      code: _codeController.text.trim(),
      newPassword: p,
    );
    if (!mounted) return;
    result.when(
      success: (_) {
        setState(() => _loading = false);
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => AlertDialog(
            title: const Text('تم التحديث'),
            content: const Text(
              'يمكنك الآن تسجيل الدخول بكلمة المرور الجديدة.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  context.go(RouteNames.login);
                },
                child: const Text('تسجيل الدخول'),
              ),
            ],
          ),
        );
      },
      failure: (f) {
        setState(() {
          _loading = false;
          _error = f.message;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          _step == 0 ? 'نسيت كلمة المرور' : 'تعيين كلمة مرور جديدة',
          style: TextStyles.headlineSmall,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
          child: _step == 0 ? _buildStepRequest() : _buildStepConfirm(),
        ),
      ),
    );
  }

  Widget _buildStepRequest() {
    return Form(
      key: _formEmail,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gaps.lgV,
          Text(
            'أدخل البريد المسجّل كمقدّم خدمة. سيصلك رمز مكوّن من 6 أرقام (صالح 15 دقيقة).',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          Gaps.xlV,
          AppTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.email,
            decoration: InputDecoration(
              labelText: 'البريد الإلكتروني',
              border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
              filled: true,
              fillColor: AppColors.surface,
            ),
          ),
          if (_error != null) ...[
            Gaps.mdV,
            Text(
              _error!,
              style: TextStyles.bodySmall.copyWith(color: SemanticColors.error),
            ),
          ],
          Gaps.xlV,
          PrimaryButton(
            label: _loading ? 'جاري الإرسال...' : 'إرسال الرمز',
            onPressed: _loading ? null : _requestCode,
          ),
          Gaps.lgV,
          TextButton(
            onPressed: () => context.go(RouteNames.login),
            child: Text(
              'العودة لتسجيل الدخول',
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepConfirm() {
    return Form(
      key: _formReset,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Gaps.mdV,
          if (_info != null)
            Text(
              _info!,
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
          Gaps.lgV,
          AppTextField(
            controller: _codeController,
            keyboardType: TextInputType.number,
            validator: (v) {
              if (v == null || v.length != 6 || int.tryParse(v) == null) {
                return 'أدخل الرمز المكوّن من 6 أرقام';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'الرمز من البريد',
              border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
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
              labelText: 'كلمة المرور الجديدة',
              border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
              filled: true,
              fillColor: AppColors.surface,
            ),
          ),
          Gaps.mdV,
          AppTextField(
            controller: _confirmController,
            obscureText: true,
            validator: Validators.password,
            decoration: InputDecoration(
              labelText: 'تأكيد كلمة المرور',
              border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
              filled: true,
              fillColor: AppColors.surface,
            ),
          ),
          if (_error != null) ...[
            Gaps.mdV,
            Text(
              _error!,
              style: TextStyles.bodySmall.copyWith(color: SemanticColors.error),
            ),
          ],
          Gaps.xlV,
          PrimaryButton(
            label: _loading ? 'جاري الحفظ...' : 'حفظ كلمة المرور',
            onPressed: _loading ? null : _confirmReset,
          ),
          Gaps.mdV,
          TextButton(
            onPressed: _loading
                ? null
                : () => setState(() {
                      _step = 0;
                      _error = null;
                    }),
            child: Text(
              'طلب رمز جديد',
              style: TextStyles.bodySmall.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
