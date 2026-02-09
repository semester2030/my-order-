import 'package:flutter/material.dart';
import 'design_system.dart';

/// Driver Theme - Extends shared theme with driver-specific variants
class DriverTheme {
  DriverTheme._();

  // Driver-specific variants
  static const double touchTargetMinSize = 48.0; // Larger (vs 44.0 for customer)
  static const double fontScaleFactor = 1.1; // +10% larger for better visibility

  // Navigation-specific colors (higher contrast)
  static const Color navigationText = AppColors.textPrimary;
  static const Color navigationBackground = AppColors.background;

  /// Light theme for driver app
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textInverse,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textOnPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyles.titleLarge,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyles.displayLarge,
        displayMedium: TextStyles.displayMedium,
        displaySmall: TextStyles.displaySmall,
        headlineLarge: TextStyles.headlineLarge.copyWith(
          fontSize: TextStyles.headlineLarge.fontSize! * fontScaleFactor,
        ),
        headlineMedium: TextStyles.headlineMedium.copyWith(
          fontSize: TextStyles.headlineMedium.fontSize! * fontScaleFactor,
        ),
        headlineSmall: TextStyles.headlineSmall.copyWith(
          fontSize: TextStyles.headlineSmall.fontSize! * fontScaleFactor,
        ),
        titleLarge: TextStyles.titleLarge.copyWith(
          fontSize: TextStyles.titleLarge.fontSize! * fontScaleFactor,
        ),
        titleMedium: TextStyles.titleMedium,
        titleSmall: TextStyles.titleSmall,
        bodyLarge: TextStyles.bodyLarge,
        bodyMedium: TextStyles.bodyMedium,
        bodySmall: TextStyles.bodySmall,
        labelLarge: TextStyles.labelLarge,
        labelMedium: TextStyles.labelMedium,
        labelSmall: TextStyles.labelSmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppButtonTheme.primary,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: AppButtonTheme.outlined,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: const OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: AppColors.border),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: AppColors.border),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: SemanticColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Insets.md,
          vertical: Insets.md,
        ),
      ),
    );
  }
}
