import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class AppSnackbar {
  AppSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Color? textColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyles.bodyMedium.copyWith(
            color: textColor ?? AppColors.textOnPrimary,
          ),
        ),
        backgroundColor: backgroundColor ?? AppColors.primary,
        duration: duration,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static void showSuccess(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: SemanticColors.success,
    );
  }

  static void showError(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: SemanticColors.error,
    );
  }

  static void showWarning(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: SemanticColors.warning,
    );
  }

  static void showInfo(BuildContext context, String message) {
    show(
      context,
      message: message,
      backgroundColor: SemanticColors.info,
    );
  }
}
