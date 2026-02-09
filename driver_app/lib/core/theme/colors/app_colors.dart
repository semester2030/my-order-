import 'package:flutter/material.dart';
import 'semantic_colors.dart';

/// Primary color palette - Sunset Premium (Shared with Customer App)
class AppColors {
  AppColors._();

  // Primary - Sunset Orange
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryDark = Color(0xFFE55A2B);
  static const Color primaryLight = Color(0xFFFF8C5A);
  static const Color primaryContainer = Color(0xFFFFE5DC);

  // Accent - Gold
  static const Color accent = Color(0xFFFFD700);
  static const Color accentDark = Color(0xFFFFA500);
  static const Color accentLight = Color(0xFFFFE44D);
  static const Color accentContainer = Color(0xFFFFF8DC);

  // Secondary - Deep Charcoal
  static const Color secondary = Color(0xFF1A1A1A);
  static const Color secondaryDark = Color(0xFF000000);
  static const Color secondaryLight = Color(0xFF2C3E50);
  static const Color secondaryContainer = Color(0xFFF5F5F5);

  // Background
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color surfaceElevated = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFE8E8E8);

  // Warm Neutrals
  static const Color warmSurface = Color(0xFFFAF7F2);
  static const Color warmDivider = Color(0xFFEFE6D8);
  static const Color warmBackground = Color(0xFFFFFBF5);

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6C757D);
  static const Color textTertiary = Color(0xFF95A5A6);
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFF1A1A1A);

  // Borders & Dividers
  static const Color border = Color(0xFFE0E0E0);
  static const Color divider = Color(0xFFF0F0F0);
  static const Color dividerStrong = Color(0xFFE0E0E0);

  // Disabled
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color disabledContainer = Color(0xFFF5F5F5);
  static const Color disabledText = Color(0xFF9E9E9E);

  // Dark Mode
  static const Color darkBackground = Color(0xFF0E0E0E);
  static const Color darkSurface = Color(0xFF1A1A1A);
  static const Color darkSurfaceElevated = Color(0xFF2C2C2C);
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
  static const Color darkDivider = Color(0xFF2C2C2C);

  // Semantic colors
  static Color get error => SemanticColors.error;
  static Color get success => SemanticColors.success;
  static Color get warning => SemanticColors.warning;
  static Color get info => SemanticColors.info;
  static Color get infoContainer => SemanticColors.infoContainer;
}
