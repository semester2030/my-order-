import 'package:flutter/material.dart';

/// Animation curves for smooth animations
class AppCurves {
  AppCurves._();

  // Standard easing
  static const Curve standard = Curves.easeInOut;

  // Smooth entrance
  static const Curve smooth = Curves.easeOutCubic;

  // Bouncy entrance
  static const Curve bounce = Curves.elasticOut;

  // Sharp entrance
  static const Curve sharp = Curves.easeOut;

  // Gentle entrance
  static const Curve gentle = Curves.easeInOutCubic;

  // Custom premium curve
  static const Curve premium = Curves.easeOutCubic;

  // Fast out, slow in
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;

  // Decelerate
  static const Curve decelerate = Curves.decelerate;

  // Accelerate
  static const Curve accelerate = Curves.easeIn;
}
