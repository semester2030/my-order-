import 'package:flutter/material.dart';
import 'radius.dart';

/// Card shape configurations
class CardShapes {
  CardShapes._();

  // Small card
  static const ShapeBorder small = RoundedRectangleBorder(
    borderRadius: AppRadius.smAll,
  );

  // Medium card
  static const ShapeBorder medium = RoundedRectangleBorder(
    borderRadius: AppRadius.mdAll,
  );

  // Large card
  static const ShapeBorder large = RoundedRectangleBorder(
    borderRadius: AppRadius.lgAll,
  );

  // Extra large card
  static const ShapeBorder extraLarge = RoundedRectangleBorder(
    borderRadius: AppRadius.xlAll,
  );

  // Rounded card (more rounded)
  static const ShapeBorder rounded = RoundedRectangleBorder(
    borderRadius: AppRadius.xxlAll,
  );
}
