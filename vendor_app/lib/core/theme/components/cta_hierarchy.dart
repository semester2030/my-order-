import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../shapes/radius.dart';
import '../typography/text_styles.dart';
import '../spacing/insets.dart';

/// CTA Button Hierarchy - 3 levels.
class CTAHierarchy {
  CTAHierarchy._();

  static ButtonStyle primary = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.primary),
    foregroundColor: WidgetStateProperty.all(AppColors.textOnPrimary),
    elevation: WidgetStateProperty.all(2.0),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(horizontal: Insets.xl, vertical: Insets.md),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    ),
    textStyle: WidgetStateProperty.all(
      TextStyles.button.copyWith(
        fontSize: 16.0,
        fontWeight: FontWeight.w600,
      ),
    ),
    overlayColor: WidgetStateProperty.all(
      AppColors.primaryDark.withValues(alpha: 0.1),
    ),
  );

  static ButtonStyle secondary = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.secondary),
    foregroundColor: WidgetStateProperty.all(AppColors.textInverse),
    elevation: WidgetStateProperty.all(1.0),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    ),
    textStyle: WidgetStateProperty.all(
      TextStyles.button.copyWith(
        fontSize: 15.0,
        fontWeight: FontWeight.w500,
      ),
    ),
    overlayColor: WidgetStateProperty.all(
      Colors.white.withValues(alpha: 0.1),
    ),
  );

  static ButtonStyle tertiary = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    foregroundColor: WidgetStateProperty.all(AppColors.primary),
    elevation: WidgetStateProperty.all(0),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    ),
    textStyle: WidgetStateProperty.all(
      TextStyles.button.copyWith(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        color: AppColors.primary,
      ),
    ),
    overlayColor: WidgetStateProperty.all(AppColors.primary.withValues(alpha: 0.1)),
  );

  static ButtonStyle gold = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.accent),
    foregroundColor: WidgetStateProperty.all(AppColors.textOnAccent),
    elevation: WidgetStateProperty.all(3.0),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    ),
    textStyle: WidgetStateProperty.all(
      TextStyles.button.copyWith(
        fontSize: 15.0,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnAccent,
        shadows: [
          Shadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 2.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
    ),
    overlayColor: WidgetStateProperty.all(
      AppColors.accentDark.withValues(alpha: 0.2),
    ),
  );
}
