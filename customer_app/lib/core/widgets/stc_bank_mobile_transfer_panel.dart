import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../localization/app_localizations.dart';
import '../theme/design_system.dart';

/// تعليمات التحويل اليدوي عبر STC Bank برقم الجوال (بديل مؤقت عن الدفع الإلكتروني).
class StcBankMobileTransferPanel extends StatelessWidget {
  const StcBankMobileTransferPanel({
    super.key,
    required this.l10n,
    this.vendorName,
    this.vendorMobile,
    this.amountLabel,
  });

  final AppLocalizations l10n;
  final String? vendorName;
  final String? vendorMobile;
  final String? amountLabel;

  Future<void> _copyMobile(BuildContext context, String mobile) async {
    await Clipboard.setData(ClipboardData(text: mobile));
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.stcBankMobileCopied)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mobile = vendorMobile?.trim();
    final hasMobile = mobile != null && mobile.isNotEmpty;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.35),
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.account_balance_outlined, color: AppColors.primary, size: IconSizes.lg),
              Gaps.smH,
              Expanded(
                child: Text(
                  l10n.stcBankTransferTitle,
                  style: TextStyles.titleSmall.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          Gaps.smV,
          Text(
            l10n.stcBankTransferIntro,
            style: TextStyles.bodyMedium.copyWith(height: 1.45),
          ),
          if (amountLabel != null && amountLabel!.isNotEmpty) ...[
            Gaps.mdV,
            Text(l10n.stcBankTransferAmountLabel, style: TextStyles.labelLarge),
            Gaps.xsV,
            Text(
              amountLabel!,
              style: TextStyles.headlineSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          Gaps.mdV,
          Text(l10n.stcBankTransferStepsTitle, style: TextStyles.labelLarge),
          Gaps.smV,
          _StepLine(number: '1', text: l10n.stcBankTransferStep1),
          _StepLine(number: '2', text: l10n.stcBankTransferStep2),
          _StepLine(number: '3', text: l10n.stcBankTransferStep3),
          _StepLine(number: '4', text: l10n.stcBankTransferStep4),
          Gaps.mdV,
          if (vendorName != null && vendorName!.isNotEmpty) ...[
            Text(l10n.stcBankTransferVendorLabel, style: TextStyles.labelMedium),
            Gaps.xsV,
            Text(vendorName!, style: TextStyles.bodyLarge),
            Gaps.smV,
          ],
          Text(l10n.stcBankTransferMobileLabel, style: TextStyles.labelMedium),
          Gaps.xsV,
          if (hasMobile)
            Material(
              color: AppColors.surface,
              borderRadius: AppRadius.mdAll,
              child: InkWell(
                onTap: () => _copyMobile(context, mobile),
                borderRadius: AppRadius.mdAll,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Insets.md,
                    vertical: Insets.sm + 2,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          mobile,
                          style: TextStyles.titleMedium.copyWith(
                            letterSpacing: 0.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Icon(Icons.copy_rounded, size: 20, color: AppColors.primary),
                      Gaps.xsH,
                      Text(
                        l10n.stcBankTransferCopy,
                        style: TextStyles.labelSmall.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            Text(
              l10n.stcBankTransferMobileMissing,
              style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          Gaps.mdV,
          Container(
            padding: const EdgeInsets.all(Insets.sm + 2),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.12),
              borderRadius: AppRadius.mdAll,
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.35)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: AppColors.warning, size: IconSizes.md),
                Gaps.smH,
                Expanded(
                  child: Text(
                    l10n.stcBankTransferBeforeConfirm,
                    style: TextStyles.bodySmall.copyWith(height: 1.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepLine extends StatelessWidget {
  const _StepLine({required this.number, required this.text});

  final String number;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Insets.xs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 22,
            child: Text(
              '$number.',
              style: TextStyles.bodySmall.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(
            child: Text(text, style: TextStyles.bodySmall.copyWith(height: 1.4)),
          ),
        ],
      ),
    );
  }
}
