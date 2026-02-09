import 'package:flutter/material.dart';

/// Gradient colors for premium effects
class GradientColors {
  GradientColors._();

  // Primary Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B35),
      Color(0xFFFF8C5A),
    ],
  );

  static const LinearGradient primaryDarkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFE55A2B),
      Color(0xFFFF6B35),
    ],
  );

  // Premium Gradient (Primary to Gold)
  static const LinearGradient premiumGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B35),
      Color(0xFFFFD700),
    ],
  );

  // Video Overlay Gradient
  static const LinearGradient videoOverlayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0x66000000), // 40% opacity
      Color(0x33000000), // 20% opacity
      Colors.transparent,
    ],
  );

  // Card Gradient
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFFFFF),
      Color(0xFFF8F9FA),
    ],
  );

  // Button Gradient
  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFF6B35),
      Color(0xFFE55A2B),
    ],
  );

  // Success Gradient
  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF27AE60),
      Color(0xFF52C97F),
    ],
  );

  // Shadow Gradient (for glow effects)
  static const RadialGradient glowGradient = RadialGradient(
    colors: [
      Color(0x4DFFD700), // 30% opacity
      Colors.transparent,
    ],
  );
}
