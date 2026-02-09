import 'package:flutter/material.dart';

/// Semantic colors for app states and actions
class SemanticColors {
  SemanticColors._();

  // Success - Fresh Green
  static const Color success = Color(0xFF27AE60);
  static const Color successLight = Color(0xFF52C97F);
  static const Color successDark = Color(0xFF1E8449);
  static const Color successContainer = Color(0xFFE8F5E9);

  // Warning - Warm Yellow
  static const Color warning = Color(0xFFF39C12);
  static const Color warningLight = Color(0xFFFFB84D);
  static const Color warningDark = Color(0xFFD68910);
  static const Color warningContainer = Color(0xFFFFF3E0);

  // Error - Soft Red
  static const Color error = Color(0xFFE74C3C);
  static const Color errorLight = Color(0xFFFF6B6B);
  static const Color errorDark = Color(0xFFC0392B);
  static const Color errorContainer = Color(0xFFFFEBEE);

  // Info - Sky Blue
  static const Color info = Color(0xFF3498DB);
  static const Color infoLight = Color(0xFF5DADE2);
  static const Color infoDark = Color(0xFF2874A6);
  static const Color infoContainer = Color(0xFFE3F2FD);

  // Driver-specific status colors
  static const Color onlineStatus = Color(0xFF27AE60); // Green
  static const Color offlineStatus = Color(0xFF95A5A6); // Gray
  static const Color navigationActive = Color(0xFF3498DB); // Blue
  static const Color jobUrgent = Color(0xFFE74C3C); // Red
}
