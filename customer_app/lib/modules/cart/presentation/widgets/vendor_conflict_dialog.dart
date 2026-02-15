// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/secondary_button.dart';

class VendorConflictDialog extends StatelessWidget {
  final VoidCallback? onClearAndAdd;

  const VendorConflictDialog({
    super.key,
    this.onClearAndAdd,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgAll,
      ),
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              size: 64,
              color: AppColors.warning,
            ),
            Gaps.lgV,
            Text(
              l.differentVendor,
              style: TextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Gaps.smV,
            Text(
              l.cartDifferentVendorMessage,
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            Gaps.xlV,
            Row(
              children: [
                Expanded(
                  child: SecondaryButton(
                    onPressed: () => Navigator.of(context).pop(),
                    text: l.cancel,
                  ),
                ),
                Gaps.mdH,
                Expanded(
                  child: PrimaryButton(
                    onPressed: () {
                      onClearAndAdd?.call();
                    },
                    text: l.clearAndAdd,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
