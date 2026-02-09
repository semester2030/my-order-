import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import 'primary_button.dart';

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: SemanticColors.error,
            ),
            Gaps.lgV,
            Text(
              'Oops! Something went wrong',
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
            if (onRetry != null) ...[
              Gaps.xlV,
              PrimaryButton(
                onPressed: onRetry,
                text: 'Retry',
                width: 200,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
