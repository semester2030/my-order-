import 'package:flutter/material.dart';

/// Semantic colors for app states and actions.
class SemanticColors {
  SemanticColors._();

  static const Color success = Color(0xFF27AE60);
  static const Color successLight = Color(0xFF52C97F);
  static const Color successDark = Color(0xFF1E8449);
  static const Color successContainer = Color(0xFFE8F5E9);

  static const Color warning = Color(0xFFF39C12);
  static const Color warningLight = Color(0xFFFFB84D);
  static const Color warningDark = Color(0xFFD68910);
  static const Color warningContainer = Color(0xFFFFF3E0);

  static const Color error = Color(0xFFE74C3C);
  static const Color errorLight = Color(0xFFFF6B6B);
  static const Color errorDark = Color(0xFFC0392B);
  static const Color errorContainer = Color(0xFFFFEBEE);

  static const Color info = Color(0xFF3498DB);
  static const Color infoLight = Color(0xFF5DADE2);
  static const Color infoDark = Color(0xFF2874A6);
  static const Color infoContainer = Color(0xFFE3F2FD);

  static const Color rating = Color(0xFFFFD700);
  static const Color ratingEmpty = Color(0xFFE0E0E0);

  static const Color badgeNew = Color(0xFF27AE60);
  static const Color badgeHot = Color(0xFFE74C3C);
  static const Color badgePremium = Color(0xFFD4AF37);
  static const Color badgeSignature = Color(0xFFFF6B35);

  static Color goldWithOpacity(double opacity) =>
      const Color(0xFFFFD700).withValues(alpha: opacity);

  static const Color goldShadow = Color(0x80000000);
}
