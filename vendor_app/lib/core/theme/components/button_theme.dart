import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../shapes/radius.dart';
import '../typography/text_styles.dart';
import '../spacing/insets.dart';

/// Button theme configuration.
class ButtonTheme {
  ButtonTheme._();

  static ButtonStyle primary = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.primary),
    foregroundColor: WidgetStateProperty.all(AppColors.textOnPrimary),
    elevation: WidgetStateProperty.all(0),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    ),
    textStyle: WidgetStateProperty.all(TextStyles.button),
  );

  static ButtonStyle primaryGradient = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    foregroundColor: WidgetStateProperty.all(AppColors.textOnPrimary),
    elevation: WidgetStateProperty.all(0),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    ),
    textStyle: WidgetStateProperty.all(TextStyles.button),
  );

  static ButtonStyle secondary = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.secondary),
    foregroundColor: WidgetStateProperty.all(AppColors.textInverse),
    elevation: WidgetStateProperty.all(0),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    ),
    textStyle: WidgetStateProperty.all(TextStyles.button),
  );

  static ButtonStyle outlined = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    foregroundColor: WidgetStateProperty.all(AppColors.primary),
    side: WidgetStateProperty.all(
      BorderSide(color: AppColors.primary, width: 1.5),
    ),
    elevation: WidgetStateProperty.all(0),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    ),
    textStyle: WidgetStateProperty.all(TextStyles.button),
  );

  static ButtonStyle text = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    foregroundColor: WidgetStateProperty.all(AppColors.primary),
    elevation: WidgetStateProperty.all(0),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(horizontal: Insets.md, vertical: Insets.sm),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    ),
    textStyle: WidgetStateProperty.all(TextStyles.button),
  );

  static ButtonStyle icon = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.surface),
    foregroundColor: WidgetStateProperty.all(AppColors.textPrimary),
    elevation: WidgetStateProperty.all(0),
    padding: WidgetStateProperty.all(EdgeInsets.all(Insets.md)),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
    ),
  );
}
