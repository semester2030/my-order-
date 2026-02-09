import 'package:flutter/material.dart';

/// Shadow styles for elevation.
class AppShadows {
  AppShadows._();

  static const BoxShadow sm = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 4.0,
    offset: Offset(0, 2),
    spreadRadius: 0,
  );
  static const BoxShadow md = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 8.0,
    offset: Offset(0, 4),
    spreadRadius: 0,
  );
  static const BoxShadow lg = BoxShadow(
    color: Color(0x1A000000),
    blurRadius: 16.0,
    offset: Offset(0, 8),
    spreadRadius: 0,
  );
  static const BoxShadow xl = BoxShadow(
    color: Color(0x33000000),
    blurRadius: 24.0,
    offset: Offset(0, 12),
    spreadRadius: 0,
  );
  static const BoxShadow xxl = BoxShadow(
    color: Color(0x4D000000),
    blurRadius: 32.0,
    offset: Offset(0, 16),
    spreadRadius: 0,
  );
  static const BoxShadow glow = BoxShadow(
    color: Color(0x4DFFD700),
    blurRadius: 12.0,
    offset: Offset(0, 0),
    spreadRadius: 4.0,
  );
  static const BoxShadow primaryGlow = BoxShadow(
    color: Color(0x4DFF6B35),
    blurRadius: 12.0,
    offset: Offset(0, 0),
    spreadRadius: 4.0,
  );

  static List<BoxShadow> elevation1 = [sm];
  static List<BoxShadow> elevation2 = [md];
  static List<BoxShadow> elevation3 = [lg];
  static List<BoxShadow> elevation4 = [xl];
  static List<BoxShadow> elevation5 = [xxl];
  static List<BoxShadow> elevationGlow = [glow];
  static List<BoxShadow> elevationPrimaryGlow = [primaryGlow];
}
