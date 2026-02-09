import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';

/// Error state placeholder (Phase 1: minimal). Phase 20: retry label from l10n.
class ErrorState extends StatelessWidget {
  const ErrorState({super.key, this.message, this.onRetry});

  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.maybeOf(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(message ?? (l10n?.errorGeneric ?? 'حدث خطأ')),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            TextButton(
              onPressed: onRetry,
              child: Text(l10n?.retry ?? 'إعادة المحاولة'),
            ),
          ],
        ],
      ),
    );
  }
}
