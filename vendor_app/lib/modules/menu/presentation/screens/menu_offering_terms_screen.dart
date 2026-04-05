import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/result.dart';
import 'package:vendor_app/core/widgets/loading_view.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/modules/auth/domain/entities/vendor_onboarding_status.dart';
import 'package:vendor_app/modules/menu/domain/entities/menu_offering_terms_status.dart';

/// شاشة موحّدة: لوائح المنصّة ([legalAcceptedAt] عبر API) + شروط عرض الوجبات +
/// قسم مؤجّل لشروط كل فئة خدمة.
class MenuOfferingTermsScreen extends ConsumerStatefulWidget {
  const MenuOfferingTermsScreen({super.key});

  @override
  ConsumerState<MenuOfferingTermsScreen> createState() =>
      _MenuOfferingTermsScreenState();
}

class _MenuOfferingTermsScreenState
    extends ConsumerState<MenuOfferingTermsScreen> {
  MenuOfferingTermsStatus? _menuStatus;
  VendorOnboardingStatus? _onboarding;
  String? _loadError;
  bool _readChecked = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final menuRes = await ref.read(menuRepoProvider).getMenuOfferingTermsStatus();
    if (!mounted) return;
    final authRes = await ref.read(authRepoProvider).getVendorOnboardingStatus();
    if (!mounted) return;

    switch (menuRes) {
      case Failure(:final error):
        setState(() {
          _loadError = error.message;
          _menuStatus = null;
          _onboarding = null;
        });
        return;
      case Success(:final value):
        final ms = value;
        switch (authRes) {
          case Failure(:final error):
            setState(() {
              _loadError = error.message;
              _menuStatus = null;
              _onboarding = null;
            });
            return;
          case Success(:final value):
            final ob = value;
            if (!ob.legalAccepted &&
                ob.requiredLegalDocumentVersion.trim().isEmpty) {
              setState(() {
                _loadError = 'إصدار لوائح المنصّة غير متاح من الخادم.';
                _menuStatus = null;
                _onboarding = null;
              });
              return;
            }
            setState(() {
              _menuStatus = ms;
              _onboarding = ob;
              _loadError = null;
              if (ms.isCurrent && ob.legalAccepted) {
                _readChecked = true;
              }
            });
            if (ms.isCurrent && ob.legalAccepted) {
              if (mounted) context.pop(true);
            }
        }
    }
  }

  Future<void> _submit() async {
    final ms = _menuStatus;
    final ob = _onboarding;
    if (ms == null || ob == null || !_readChecked || _submitting) return;

    final needLegal = !ob.legalAccepted;
    final needMenu = !ms.isCurrent;
    if (!needLegal && !needMenu) {
      if (mounted) context.pop(true);
      return;
    }

    setState(() => _submitting = true);

    if (needLegal) {
      final v = ob.requiredLegalDocumentVersion.trim();
      if (v.isEmpty) {
        setState(() => _submitting = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('إصدار لوائح المنصّة غير صالح.'),
              backgroundColor: SemanticColors.error,
            ),
          );
        }
        return;
      }
      final legalRes =
          await ref.read(authRepoProvider).acceptVendorLegalDocument(v);
      if (!mounted) return;
      switch (legalRes) {
        case Failure(:final error):
          setState(() => _submitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: SemanticColors.error,
            ),
          );
          return;
        case Success():
          break;
      }
    }

    if (needMenu) {
      final menuRes = await ref
          .read(menuRepoProvider)
          .acceptMenuOfferingTerms(ms.requiredVersion);
      if (!mounted) return;
      switch (menuRes) {
        case Failure(:final error):
          setState(() => _submitting = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: SemanticColors.error,
            ),
          );
          return;
        case Success():
          break;
      }
    }

    setState(() => _submitting = false);
    if (mounted) context.pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    if (_loadError != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          title: Text(
            l10n.vendorCombinedTermsTitle,
            style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(Insets.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _loadError!,
                  textAlign: TextAlign.center,
                  style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                ),
                Gaps.mdV,
                TextButton(onPressed: _load, child: Text(l10n.retry)),
                TextButton(
                  onPressed: () => context.pop(false),
                  child: Text(l10n.cancel),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_menuStatus == null || _onboarding == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          title: Text(
            l10n.vendorCombinedTermsTitle,
            style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const LoadingView(),
              Gaps.smV,
              Text(
                l10n.menuOfferingTermsLoading,
                style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    final ms = _menuStatus!;
    final ob = _onboarding!;
    final needLegal = !ob.legalAccepted;
    final needMenu = !ms.isCurrent;
    final needsAnyAccept = needLegal || needMenu;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(false),
        ),
        title: Text(
          l10n.vendorCombinedTermsTitle,
          style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.vendorPlatformTermsSectionTitle,
                      style: TextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Gaps.smV,
                    if (needLegal) ...[
                      Text(
                        l10n.vendorPlatformTermsIntro,
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.45,
                        ),
                      ),
                      Gaps.mdV,
                      _clause(
                        context,
                        l10n.vendorPlatformTermsFeesTitle,
                        l10n.vendorPlatformTermsFeesBody,
                      ),
                      _clause(
                        context,
                        l10n.vendorPlatformTermsPayoutTitle,
                        l10n.vendorPlatformTermsPayoutBody,
                      ),
                      _clause(
                        context,
                        l10n.vendorPlatformTermsComplianceTitle,
                        l10n.vendorPlatformTermsComplianceBody,
                      ),
                      Gaps.smV,
                      Text(
                        '${l10n.vendorCombinedTermsLegalVersionLabel}: ${ob.requiredLegalDocumentVersion}',
                        style: TextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ] else
                      _acceptedBanner(context, l10n.vendorLegalAlreadyAccepted),
                    Gaps.xlV,
                    Text(
                      l10n.vendorCombinedTermsMenuSectionTitle,
                      style: TextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Gaps.smV,
                    if (needMenu) ...[
                      Text(
                        l10n.menuOfferingTermsSubtitle,
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Gaps.mdV,
                      Container(
                        padding: EdgeInsets.all(Insets.md),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceVariant.withValues(alpha: 0.5),
                          borderRadius: AppRadius.mdAll,
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Text(
                          l10n.menuOfferingTermsNotice,
                          style: TextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.45,
                          ),
                        ),
                      ),
                      Gaps.mdV,
                      _bullet(context, l10n.menuOfferingTermsBullet1),
                      _bullet(context, l10n.menuOfferingTermsBullet2),
                      _bullet(context, l10n.menuOfferingTermsBullet3),
                      _bullet(context, l10n.menuOfferingTermsBullet4),
                      _bullet(context, l10n.menuOfferingTermsBullet5),
                      Gaps.smV,
                      Text(
                        '${l10n.menuOfferingTermsVersionLabel}: ${ms.requiredVersion}',
                        style: TextStyles.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ] else
                      _acceptedBanner(context, l10n.vendorMenuTermsAlreadyAccepted),
                    Gaps.xlV,
                    Text(
                      l10n.vendorCategoryTermsSectionTitle,
                      style: TextStyles.titleMedium.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Gaps.smV,
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(Insets.lg),
                      decoration: BoxDecoration(
                        borderRadius: AppRadius.mdAll,
                        border: Border.all(color: AppColors.divider),
                        color: AppColors.surfaceVariant.withValues(alpha: 0.35),
                      ),
                      child: Text(
                        l10n.vendorCategoryTermsPlaceholder,
                        textAlign: TextAlign.center,
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                    Gaps.xxlV,
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (needsAnyAccept) ...[
                    CheckboxListTile(
                      value: _readChecked,
                      onChanged: _submitting
                          ? null
                          : (v) => setState(() => _readChecked = v ?? false),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: Text(
                        l10n.vendorCombinedTermsReadCheckbox,
                        style: TextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                      ),
                    ),
                    Gaps.smV,
                    PrimaryButton(
                      label: _submitting
                          ? l10n.menuOfferingTermsSubmitting
                          : l10n.menuOfferingTermsAgreeButton,
                      onPressed: (!_readChecked || _submitting) ? null : _submit,
                    ),
                  ] else
                    PrimaryButton(
                      label: l10n.menuOfferingTermsAgreeButton,
                      onPressed: () => context.pop(true),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _clause(BuildContext context, String title, String body) {
    return Padding(
      padding: EdgeInsets.only(bottom: Insets.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: TextStyles.titleSmall.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.xsV,
          Text(
            body,
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _acceptedBanner(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: SemanticColors.success.withValues(alpha: 0.12),
        borderRadius: AppRadius.mdAll,
        border: Border.all(color: SemanticColors.success.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: SemanticColors.success, size: 22),
          Gaps.smH,
          Expanded(
            child: Text(
              text,
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _bullet(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: Insets.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.only(
              top: 6,
              start: Insets.sm,
              end: Insets.xs,
            ),
            child: Icon(Icons.circle, size: 8, color: AppColors.primary),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
