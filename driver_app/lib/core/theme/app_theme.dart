import 'package:flutter/material.dart';
import 'driver_theme.dart';

/// App theme - delegates to DriverTheme
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => DriverTheme.lightTheme;
}
