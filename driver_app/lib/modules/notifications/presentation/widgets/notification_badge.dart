import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

/// Notification Badge Widget
/// 
/// Displays a badge with notification count
class NotificationBadge extends StatelessWidget {
  final int count;
  final Widget child;
  final bool showZero;

  const NotificationBadge({
    super.key,
    required this.count,
    required this.child,
    this.showZero = false,
  });

  @override
  Widget build(BuildContext context) {
    if (!showZero && count == 0) {
      return child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        Positioned(
          right: -8,
          top: -8,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: SemanticColors.error,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.background,
                width: 2,
              ),
            ),
            constraints: const BoxConstraints(
              minWidth: 16,
              minHeight: 16,
            ),
            child: Text(
              count > 99 ? '99+' : count.toString(),
              style: TextStyles.labelSmall.copyWith(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
