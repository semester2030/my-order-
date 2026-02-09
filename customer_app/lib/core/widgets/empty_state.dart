import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import 'primary_button.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Insets.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: AppColors.textTertiary,
            ),
            Gaps.xlV,
            Text(
              title,
              style: TextStyles.headlineMedium,
              textAlign: TextAlign.center,
            ),
            Gaps.smV,
            Text(
              message,
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onAction != null) ...[
              Gaps.xlV,
              PrimaryButton(
                onPressed: onAction,
                text: actionText!,
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
