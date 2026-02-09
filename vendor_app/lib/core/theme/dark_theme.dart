import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'design_system.dart';
import 'design_system.dart' as components;

/// Dark theme configuration.
class DarkTheme {
  DarkTheme._();

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondaryLight,
        surface: AppColors.darkSurface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textInverse,
        onSurface: AppColors.darkTextPrimary,
        onError: AppColors.textInverse,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyles.displayLarge.copyWith(color: AppColors.darkTextPrimary),
        displayMedium: TextStyles.displayMedium.copyWith(color: AppColors.darkTextPrimary),
        displaySmall: TextStyles.displaySmall.copyWith(color: AppColors.darkTextPrimary),
        headlineLarge: TextStyles.headlineLarge.copyWith(color: AppColors.darkTextPrimary),
        headlineMedium: TextStyles.headlineMedium.copyWith(color: AppColors.darkTextPrimary),
        headlineSmall: TextStyles.headlineSmall.copyWith(color: AppColors.darkTextPrimary),
        titleLarge: TextStyles.titleLarge.copyWith(color: AppColors.darkTextPrimary),
        titleMedium: TextStyles.titleMedium.copyWith(color: AppColors.darkTextPrimary),
        titleSmall: TextStyles.titleSmall.copyWith(color: AppColors.darkTextPrimary),
        bodyLarge: TextStyles.bodyLarge.copyWith(color: AppColors.darkTextPrimary),
        bodyMedium: TextStyles.bodyMedium.copyWith(color: AppColors.darkTextSecondary),
        bodySmall: TextStyles.bodySmall.copyWith(color: AppColors.darkTextSecondary),
        labelLarge: TextStyles.labelLarge.copyWith(color: AppColors.darkTextPrimary),
        labelMedium: TextStyles.labelMedium.copyWith(color: AppColors.darkTextSecondary),
        labelSmall: TextStyles.labelSmall.copyWith(color: AppColors.darkTextSecondary),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        titleTextStyle: TextStyles.headlineMedium.copyWith(color: AppColors.darkTextPrimary),
        iconTheme: IconThemeData(
          color: AppColors.darkTextPrimary,
          size: IconSizes.md,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkSurfaceElevated,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
        margin: EdgeInsets.all(Insets.sm),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: components.CTAHierarchy.primary,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: components.ButtonTheme.outlined.copyWith(
          side: WidgetStateProperty.all(
            BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: CTAHierarchy.tertiary,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        contentPadding: EdgeInsets.symmetric(
          horizontal: Insets.md,
          vertical: Insets.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: AppColors.darkDivider, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: AppColors.darkDivider, width: 1.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mdAll,
          borderSide: BorderSide(color: AppColors.primary, width: 2.0),
        ),
        labelStyle: TextStyles.bodyMedium.copyWith(color: AppColors.darkTextSecondary),
        hintStyle: TextStyles.bodyMedium.copyWith(color: AppColors.darkTextSecondary),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.darkSurfaceElevated,
        elevation: 8.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1.0,
        space: 1.0,
      ),
      iconTheme: IconThemeData(
        color: AppColors.darkTextPrimary,
        size: IconSizes.md,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.fullAll,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.darkTextSecondary,
        selectedLabelStyle: TextStyles.labelMedium,
        unselectedLabelStyle: TextStyles.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 8.0,
      ),
    );
  }
}
