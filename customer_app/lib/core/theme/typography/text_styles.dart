import 'package:flutter/material.dart';
import 'font_families.dart';
import 'font_sizes.dart';
import '../colors/app_colors.dart';

/// Text styles for the app
class TextStyles {
  TextStyles._();

  // Display
  static TextStyle displayLarge = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.displayLarge,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle displayMedium = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.displayMedium,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.5,
    color: AppColors.textPrimary,
    height: 1.2,
  );

  static TextStyle displaySmall = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.displaySmall,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // Headline
  static TextStyle headlineLarge = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.headlineLarge,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.25,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle headlineMedium = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.headlineMedium,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle headlineSmall = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.headlineSmall,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Title
  static TextStyle titleLarge = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.titleLarge,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle titleMedium = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.titleMedium,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle titleSmall = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.titleSmall,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // Body
  static TextStyle bodyLarge = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.bodyLarge,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.bodyMedium,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static TextStyle bodySmall = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.bodySmall,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // Label
  static TextStyle labelLarge = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.labelLarge,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle labelMedium = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.labelMedium,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle labelSmall = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.labelSmall,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: AppColors.textTertiary,
    height: 1.4,
  );

  // Special styles
  static TextStyle button = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.bodyLarge,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textOnPrimary,
    height: 1.2,
  );

  static TextStyle caption = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.bodySmall,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static TextStyle overline = const TextStyle(
    fontFamily: FontFamilies.primary,
    fontSize: FontSizes.labelSmall,
    fontWeight: FontWeight.w500,
    letterSpacing: 1.5,
    color: AppColors.textTertiary,
    height: 1.4,
  );
}
