import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../colors/semantic_colors.dart';

/// Accessibility contrast checker and guidelines
class ContrastChecker {
  ContrastChecker._();

  /// Check if text color has sufficient contrast on background
  /// Returns true if contrast ratio >= 4.5:1 (WCAG AA standard)
  static bool hasSufficientContrast(Color textColor, Color backgroundColor) {
    final contrastRatio = _calculateContrastRatio(textColor, backgroundColor);
    return contrastRatio >= 4.5;
  }

  /// Calculate contrast ratio between two colors
  static double _calculateContrastRatio(Color color1, Color color2) {
    final luminance1 = _relativeLuminance(color1);
    final luminance2 = _relativeLuminance(color2);

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Calculate relative luminance of a color
  static double _relativeLuminance(Color color) {
    final r = _linearize((color.r * 255.0).round() / 255.0);
    final g = _linearize((color.g * 255.0).round() / 255.0);
    final b = _linearize((color.b * 255.0).round() / 255.0);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  static double _linearize(double value) {
    if (value <= 0.03928) {
      return value / 12.92;
    }
    return math.pow((value + 0.055) / 1.055, 2.4).toDouble();
  }

  /// Get safe text color for gold on different backgrounds
  static Color getSafeGoldTextColor(Color backgroundColor) {
    // Gold on white - needs shadow or darker gold
    if (backgroundColor == AppColors.background ||
        backgroundColor == AppColors.surface) {
      return SemanticColors.badgePremium; // Darker gold
    }

    // Gold on video/dark - use regular gold
    if (backgroundColor == AppColors.videoBackground ||
        backgroundColor == AppColors.darkBackground) {
      return AppColors.accent;
    }

    // Default
    return SemanticColors.badgePremium;
  }

  /// Get safe text style with shadow for gold text
  static TextStyle getGoldTextStyleWithShadow({
    required double fontSize,
    Color? backgroundColor,
  }) {
    final textColor = getSafeGoldTextColor(
      backgroundColor ?? AppColors.background,
    );

    return TextStyle(
      color: textColor,
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      shadows: [
        Shadow(
          color: SemanticColors.goldShadow,
          blurRadius: fontSize < 14 ? 2.0 : 4.0,
          offset: const Offset(0, 1),
        ),
      ],
    );
  }

  /// Accessibility guidelines for color usage
  static const Map<String, String> guidelines = {
    'gold_on_white': 'Use darker gold (#D4AF37) with shadow for text on white',
    'gold_on_video': 'Use regular gold (#FFD700) with overlay background',
    'gold_small_text': 'Avoid gold for text smaller than 14px',
    'primary_on_white': 'Primary orange on white has excellent contrast',
    'primary_on_video': 'Primary orange on video needs white background or overlay',
  };
}
