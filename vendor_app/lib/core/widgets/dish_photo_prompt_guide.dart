import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../content/dish_photo_prompts.dart';
import '../localization/app_localizations.dart';
import '../theme/design_system.dart';

/// دليل برومت التصوير الاحترافي — يظهر عند رفع صورة الوجبة.
class DishPhotoPromptGuide extends StatelessWidget {
  const DishPhotoPromptGuide({super.key, this.providerCategory});

  final String? providerCategory;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final prompt = DishPhotoPrompts.fullForCategory(providerCategory);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withValues(alpha: 0.28),
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.22)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: Insets.md),
          childrenPadding: const EdgeInsets.fromLTRB(
            Insets.md,
            0,
            Insets.md,
            Insets.md,
          ),
          leading: Icon(Icons.auto_awesome, color: AppColors.primary, size: IconSizes.md),
          title: Text(
            l.dishPhotoPromptGuideTitle,
            style: TextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            l.dishPhotoPromptGuideSubtitle,
            style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          children: [
            SelectableText(
              prompt,
              style: TextStyles.bodySmall.copyWith(height: 1.45),
            ),
            Gaps.smV,
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: FilledButton.tonalIcon(
                onPressed: () async {
                  await Clipboard.setData(ClipboardData(text: prompt));
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l.dishPhotoPromptCopied)),
                  );
                },
                icon: const Icon(Icons.copy_rounded, size: 18),
                label: Text(l.dishPhotoPromptCopy),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
