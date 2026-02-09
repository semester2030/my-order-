import 'package:flutter/material.dart';

/// Animation curves for smooth animations.
class AppCurves {
  AppCurves._();

  static const Curve standard = Curves.easeInOut;
  static const Curve smooth = Curves.easeOutCubic;
  static const Curve bounce = Curves.elasticOut;
  static const Curve sharp = Curves.easeOut;
  static const Curve gentle = Curves.easeInOutCubic;
  static const Curve premium = Curves.easeOutCubic;
  static const Curve fastOutSlowIn = Curves.fastOutSlowIn;
  static const Curve decelerate = Curves.decelerate;
  static const Curve accelerate = Curves.easeIn;
}
