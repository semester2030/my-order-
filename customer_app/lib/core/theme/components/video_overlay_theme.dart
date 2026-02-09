// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../colors/gradient_colors.dart';
import '../typography/text_styles.dart';
import '../shapes/radius.dart';
import '../spacing/insets.dart';

/// Video overlay theme for video-first design
class VideoOverlayTheme {
  VideoOverlayTheme._();

  // Overlay gradient
  static const Gradient overlayGradient = GradientColors.videoOverlayGradient;

  // Text styles for video overlay
  static TextStyle titleStyle = TextStyles.headlineMedium.copyWith(
    color: AppColors.videoText,
    shadows: [
      Shadow(
        color: Colors.black.withValues(alpha: 0.5),
        blurRadius: 8.0,
        offset: const Offset(0, 2),
      ),
    ],
  );

  static TextStyle subtitleStyle = TextStyles.bodyMedium.copyWith(
    color: AppColors.videoText,
    shadows: [
      Shadow(
        color: Colors.black.withValues(alpha: 0.5),
        blurRadius: 6.0,
        offset: const Offset(0, 1),
      ),
    ],
  );

  // CTA button style for video
  static ButtonStyle ctaButtonStyle = ButtonStyle(
    backgroundColor: WidgetStateProperty.all(AppColors.primary),
    foregroundColor: WidgetStateProperty.all(AppColors.textOnPrimary),
    elevation: WidgetStateProperty.all(4.0),
    padding: WidgetStateProperty.all(
      EdgeInsets.symmetric(
        horizontal: Insets.md,
        vertical: Insets.sm,
      ),
    ),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: AppRadius.fullAll,
      ),
    ),
    textStyle: WidgetStateProperty.all(
      TextStyles.button.copyWith(
        color: AppColors.textOnPrimary,
      ),
    ),
  );

  // ETA display style
  static TextStyle etaStyle = TextStyles.bodySmall.copyWith(
    color: AppColors.videoText,
    backgroundColor: Colors.black.withValues(alpha: 0.5),
    shadows: [
      Shadow(
        color: Colors.black.withValues(alpha: 0.3),
        blurRadius: 4.0,
        offset: const Offset(0, 1),
      ),
    ],
  );
}
