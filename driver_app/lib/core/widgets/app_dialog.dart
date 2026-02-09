import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import 'primary_button.dart';
import 'secondary_button.dart';

class AppDialog {
  AppDialog._();

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
  }) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: TextStyles.titleLarge),
        content: Text(message, style: TextStyles.bodyMedium),
        actions: [
          if (cancelText != null)
            SecondaryButton(
              onPressed: () {
                Navigator.of(context).pop();
                onCancel?.call();
              },
              text: cancelText,
              width: 100,
            ),
          if (confirmText != null)
            PrimaryButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm?.call();
              },
              text: confirmText,
              width: 100,
            ),
        ],
      ),
    );
  }
}
