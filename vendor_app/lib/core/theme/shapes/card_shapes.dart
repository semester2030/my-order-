import 'package:flutter/material.dart';

import 'radius.dart';

/// Card shape configurations.
class CardShapes {
  CardShapes._();

  static const ShapeBorder small = RoundedRectangleBorder(borderRadius: AppRadius.smAll);
  static const ShapeBorder medium = RoundedRectangleBorder(borderRadius: AppRadius.mdAll);
  static const ShapeBorder large = RoundedRectangleBorder(borderRadius: AppRadius.lgAll);
  static const ShapeBorder extraLarge = RoundedRectangleBorder(borderRadius: AppRadius.xlAll);
  static const ShapeBorder rounded = RoundedRectangleBorder(borderRadius: AppRadius.xxlAll);
}
