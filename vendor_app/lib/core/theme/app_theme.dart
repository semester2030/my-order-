import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'design_system.dart';
import 'design_system.dart' as components;

/// Main app theme configuration.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: AppColors.textOnPrimary,
        onSecondary: AppColors.textInverse,
        onSurface: AppColors.textPrimary,
        onError: AppColors.textInverse,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyles.displayLarge,
        displayMedium: TextStyles.displayMedium,
        displaySmall: TextStyles.displaySmall,
        headlineLarge: TextStyles.headlineLarge,
        headlineMedium: TextStyles.headlineMedium,
        headlineSmall: TextStyles.headlineSmall,
        titleLarge: TextStyles.titleLarge,
        titleMedium: TextStyles.titleMedium,
        titleSmall: TextStyles.titleSmall,
        bodyLarge: TextStyles.bodyLarge,
        bodyMedium: TextStyles.bodyMedium,
        bodySmall: TextStyles.bodySmall,
        labelLarge: TextStyles.labelLarge,
        labelMedium: TextStyles.labelMedium,
        labelSmall: TextStyles.labelSmall,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyles.headlineMedium,
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
          size: IconSizes.md,
        ),
      ),
      cardTheme: components.CardTheme.defaultTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: components.ButtonTheme.primary,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: components.ButtonTheme.outlined,
      ),
      textButtonTheme: TextButtonThemeData(
        style: components.ButtonTheme.text,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: components.ButtonTheme.icon,
      ),
      inputDecorationTheme: InputTheme.defaultTheme,
      bottomSheetTheme: BottomSheetTheme.defaultTheme,
      dividerTheme: DividerThemeData(
        color: AppColors.divider,
        thickness: 1.0,
        space: 1.0,
      ),
      iconTheme: IconThemeData(
        color: AppColors.textPrimary,
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
        backgroundColor: AppColors.surfaceElevated,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiary,
        selectedLabelStyle: TextStyles.labelMedium,
        unselectedLabelStyle: TextStyles.labelSmall,
        type: BottomNavigationBarType.fixed,
        elevation: 8.0,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primaryContainer,
        labelStyle: TextStyles.bodyMedium,
        secondaryLabelStyle: TextStyles.bodySmall,
        padding: EdgeInsets.symmetric(
          horizontal: Insets.md,
          vertical: Insets.sm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.fullAll,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceElevated,
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.lgAll,
        ),
        titleTextStyle: TextStyles.headlineMedium,
        contentTextStyle: TextStyles.bodyMedium,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.secondary,
        contentTextStyle: TextStyles.bodyMedium.copyWith(
          color: AppColors.textInverse,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.mdAll,
        ),
        behavior: SnackBarBehavior.floating,
        elevation: 4.0,
      ),
    );
  }
}
