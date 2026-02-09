import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../colors/semantic_colors.dart';

/// Border styles.
class AppBorders {
  AppBorders._();

  static Border defaultBorder = Border.all(color: AppColors.border, width: 1.0);
  static Border lightBorder = Border.all(color: AppColors.divider, width: 0.5);
  static Border strongBorder = Border.all(color: AppColors.border, width: 2.0);
  static Border primaryBorder = Border.all(color: AppColors.primary, width: 1.5);
  static Border errorBorder = Border.all(color: SemanticColors.error, width: 1.5);
  static Border noBorder = Border.all(color: Colors.transparent, width: 0);
}
