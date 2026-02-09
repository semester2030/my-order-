import 'package:flutter/material.dart';

/// Border radius values
class AppRadius {
  AppRadius._();

  // Small
  static const double sm = 4.0;
  static const BorderRadius smAll = BorderRadius.all(Radius.circular(sm));

  // Medium
  static const double md = 8.0;
  static const BorderRadius mdAll = BorderRadius.all(Radius.circular(md));

  // Large
  static const double lg = 12.0;
  static const BorderRadius lgAll = BorderRadius.all(Radius.circular(lg));

  // Extra Large
  static const double xl = 16.0;
  static const BorderRadius xlAll = BorderRadius.all(Radius.circular(xl));

  // Extra Extra Large
  static const double xxl = 24.0;
  static const BorderRadius xxlAll = BorderRadius.all(Radius.circular(xxl));

  // Full (for pills)
  static const double full = 999.0;
  static const BorderRadius fullAll = BorderRadius.all(Radius.circular(full));

  // Top only
  static const BorderRadius topSM = BorderRadius.vertical(top: Radius.circular(sm));
  static const BorderRadius topMD = BorderRadius.vertical(top: Radius.circular(md));
  static const BorderRadius topLG = BorderRadius.vertical(top: Radius.circular(lg));
  static const BorderRadius topXL = BorderRadius.vertical(top: Radius.circular(xl));

  // Bottom only
  static const BorderRadius bottomSM = BorderRadius.vertical(bottom: Radius.circular(sm));
  static const BorderRadius bottomMD = BorderRadius.vertical(bottom: Radius.circular(md));
  static const BorderRadius bottomLG = BorderRadius.vertical(bottom: Radius.circular(lg));
  static const BorderRadius bottomXL = BorderRadius.vertical(bottom: Radius.circular(xl));
}
