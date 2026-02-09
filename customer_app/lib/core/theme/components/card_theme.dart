// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../shapes/radius.dart';
import '../spacing/insets.dart';

/// Card theme configuration
class CardTheme {
  CardTheme._();

  // Default card theme
  static CardThemeData defaultTheme = CardThemeData(
    color: AppColors.surfaceElevated,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.mdAll,
    ),
    margin: EdgeInsets.all(Insets.sm),
    shadowColor: Colors.transparent,
  );

  // Elevated card theme
  static CardThemeData elevated = CardThemeData(
    color: AppColors.surfaceElevated,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.lgAll,
    ),
    margin: EdgeInsets.all(Insets.md),
    shadowColor: Colors.transparent,
  );

  // Outlined card theme
  static CardThemeData outlined = CardThemeData(
    color: AppColors.surfaceElevated,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: AppRadius.mdAll,
      side: BorderSide(
        color: AppColors.border,
        width: 1.0,
      ),
    ),
    margin: EdgeInsets.all(Insets.sm),
    shadowColor: Colors.transparent,
  );
}
