import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../shapes/radius.dart';
import '../typography/text_styles.dart';
import '../spacing/insets.dart';

/// Button theme configuration
/// Note: Named AppButtonTheme to avoid conflict with Flutter's ButtonTheme
class AppButtonTheme {
  AppButtonTheme._();

  // Primary button style
  static ButtonStyle get primary => ButtonStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.primary),
    foregroundColor: WidgetStateProperty.all(AppColors.textOnPrimary),
    elevation: WidgetStateProperty.all(0),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(
        horizontal: Insets.lg,
        vertical: Insets.md,
      ),
    ),
    shape: WidgetStateProperty.all(
      const RoundedRectangleBorder(
        borderRadius: AppRadius.mdAll,
      ),
    ),
    textStyle: WidgetStateProperty.all(TextStyles.button),
  );

  // Secondary button style
  static ButtonStyle get secondary => ButtonStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.secondary),
    foregroundColor: WidgetStateProperty.all(AppColors.textInverse),
    elevation: WidgetStateProperty.all(0),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(
        horizontal: Insets.lg,
        vertical: Insets.md,
      ),
    ),
    shape: WidgetStateProperty.all(
      const RoundedRectangleBorder(
        borderRadius: AppRadius.mdAll,
      ),
    ),
    textStyle: WidgetStateProperty.all(TextStyles.button),
  );

  // Outlined button style
  static ButtonStyle get outlined => ButtonStyle(
    backgroundColor: WidgetStateProperty.all(Colors.transparent),
    foregroundColor: WidgetStateProperty.all(AppColors.primary),
    side: WidgetStateProperty.all(
      const BorderSide(color: AppColors.primary, width: 1.5),
    ),
    elevation: WidgetStateProperty.all(0),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(
        horizontal: Insets.lg,
        vertical: Insets.md,
      ),
    ),
    shape: WidgetStateProperty.all(
      const RoundedRectangleBorder(
        borderRadius: AppRadius.mdAll,
      ),
    ),
    textStyle: WidgetStateProperty.all(TextStyles.button),
  );
}
