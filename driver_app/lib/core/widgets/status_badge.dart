import 'package:flutter/material.dart';
import '../theme/design_system.dart';

class StatusBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const StatusBadge({
    super.key,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Insets.sm,
        vertical: Insets.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: AppRadius.smAll,
      ),
      child: Text(
        text,
        style: TextStyles.labelSmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // Factory constructors for common statuses
  factory StatusBadge.success(String text) {
    return StatusBadge(
      text: text,
      backgroundColor: SemanticColors.successContainer,
      textColor: SemanticColors.success,
    );
  }

  factory StatusBadge.error(String text) {
    return StatusBadge(
      text: text,
      backgroundColor: SemanticColors.errorContainer,
      textColor: SemanticColors.error,
    );
  }

  factory StatusBadge.warning(String text) {
    return StatusBadge(
      text: text,
      backgroundColor: SemanticColors.warningContainer,
      textColor: SemanticColors.warning,
    );
  }

  factory StatusBadge.info(String text) {
    return StatusBadge(
      text: text,
      backgroundColor: SemanticColors.infoContainer,
      textColor: SemanticColors.info,
    );
  }
}
