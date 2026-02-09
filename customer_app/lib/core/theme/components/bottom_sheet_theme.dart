// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

/// Bottom sheet theme configuration
class BottomSheetTheme {
  BottomSheetTheme._();

  // Default bottom sheet theme
  static BottomSheetThemeData get defaultTheme => BottomSheetThemeData(
        backgroundColor: AppColors.surfaceElevated,
        elevation: 8.0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(24.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        modalBackgroundColor: AppColors.videoOverlay,
        constraints: const BoxConstraints(
          maxHeight: 600.0,
        ),
      );
}
