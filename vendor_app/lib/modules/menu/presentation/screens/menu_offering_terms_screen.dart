import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/result.dart';
import 'package:vendor_app/core/widgets/loading_view.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/modules/menu/domain/entities/menu_offering_terms_status.dart';

/// شاشة قالب الشروط العامة لعرض الوجبات — النصوص التفصيلية تُستبدل لاحقاً.
class MenuOfferingTermsScreen extends ConsumerStatefulWidget {
  const MenuOfferingTermsScreen({super.key});

  @override
  ConsumerState<MenuOfferingTermsScreen> createState() =>
      _MenuOfferingTermsScreenState();
}

class _MenuOfferingTermsScreenState
    extends ConsumerState<MenuOfferingTermsScreen> {
  MenuOfferingTermsStatus? _status;
  String? _loadError;
  bool _readChecked = false;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final res = await ref.read(menuRepoProvider).getMenuOfferingTermsStatus();
    if (!mounted) return;
    res.when(
      success: (s) {
        setState(() {
          _status = s;
          _loadError = null;
          if (s.isCurrent) {
            _readChecked = true;
          }
        });
        if (s.isCurrent) {
          context.pop(true);
        }
      },
      failure: (f) {
        setState(() {
          _loadError = f.message;
          _status = null;
        });
      },
    );
  }

  Future<void> _submit() async {
    final status = _status;
    if (status == null || !_readChecked || _submitting) return;
    setState(() => _submitting = true);
    final res = await ref
        .read(menuRepoProvider)
        .acceptMenuOfferingTerms(status.requiredVersion);
    if (!mounted) return;
    setState(() => _submitting = false);
    res.when(
      success: (_) => context.pop(true),
      failure: (f) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(f.message),
            backgroundColor: SemanticColors.error,
          ),
        );
      },
    );
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
            l10n.menuOfferingTermsTitle,
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
                TextButton(
                  onPressed: _load,
                  child: Text(l10n.retry),
                ),
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

    if (_status == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          title: Text(
            l10n.menuOfferingTermsTitle,
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

    final status = _status!;

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
          l10n.menuOfferingTermsTitle,
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
                      l10n.menuOfferingTermsSubtitle,
                      style: TextStyles.bodyLarge.copyWith(
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
                    Gaps.lgV,
                    _bullet(context, l10n.menuOfferingTermsBullet1),
                    _bullet(context, l10n.menuOfferingTermsBullet2),
                    _bullet(context, l10n.menuOfferingTermsBullet3),
                    _bullet(context, l10n.menuOfferingTermsBullet4),
                    _bullet(context, l10n.menuOfferingTermsBullet5),
                    Gaps.lgV,
                    Text(
                      '${l10n.menuOfferingTermsVersionLabel}: ${status.requiredVersion}',
                      style: TextStyles.labelMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontFamily: 'monospace',
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
                  CheckboxListTile(
                    value: _readChecked,
                    onChanged: _submitting
                        ? null
                        : (v) => setState(() => _readChecked = v ?? false),
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      l10n.menuOfferingTermsReadCheckbox,
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
                ],
              ),
            ),
          ],
        ),
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
