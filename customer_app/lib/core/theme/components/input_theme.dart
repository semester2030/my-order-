// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../colors/semantic_colors.dart';
import '../shapes/radius.dart';
import '../spacing/insets.dart';
import '../typography/text_styles.dart';

/// Input field theme configuration
class InputTheme {
  InputTheme._();

  // Default input decoration
  static InputDecorationTheme defaultTheme = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface,
    contentPadding: EdgeInsets.symmetric(
      horizontal: Insets.md,
      vertical: Insets.md,
    ),
    border: OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(
        color: AppColors.border,
        width: 1.0,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(
        color: AppColors.border,
        width: 1.0,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(
        color: AppColors.primary,
        width: 2.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(
        color: SemanticColors.error,
        width: 1.5,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(
        color: SemanticColors.error,
        width: 2.0,
      ),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: AppRadius.mdAll,
      borderSide: BorderSide(
        color: AppColors.disabled,
        width: 1.0,
      ),
    ),
    labelStyle: TextStyles.bodyMedium.copyWith(
      color: AppColors.textSecondary,
    ),
    hintStyle: TextStyles.bodyMedium.copyWith(
      color: AppColors.textTertiary,
    ),
    errorStyle: TextStyles.bodySmall.copyWith(
      color: SemanticColors.error,
    ),
  );
}
