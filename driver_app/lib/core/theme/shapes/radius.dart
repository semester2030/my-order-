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
}
