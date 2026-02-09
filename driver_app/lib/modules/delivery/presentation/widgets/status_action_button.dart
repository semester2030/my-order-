import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/primary_button.dart';

/// Status Action Button
/// 
/// Displays action button based on delivery status
class StatusActionButton extends StatelessWidget {
  final String orderStatus;
  final VoidCallback? onNavigateToRestaurant;
  final VoidCallback? onPickup;
  final VoidCallback? onNavigateToCustomer;
  final VoidCallback? onDelivered;
  final bool isLoading;

  const StatusActionButton({
    super.key,
    required this.orderStatus,
    this.onNavigateToRestaurant,
    this.onPickup,
    this.onNavigateToCustomer,
    this.onDelivered,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final action = _getActionForStatus(orderStatus);

    if (action == null) {
      return const SizedBox.shrink();
    }

    return PrimaryButton(
      onPressed: isLoading || action.onPressed == null ? null : action.onPressed!,
      text: action.text,
      icon: action.icon,
      isLoading: isLoading,
    );
  }

  _Action? _getActionForStatus(String status) {
    return switch (status) {
      'pending' || 'accepted' => _Action(
          text: 'Navigate to Restaurant',
          icon: Icons.restaurant,
          onPressed: onNavigateToRestaurant,
        ),
      'picked_up' => _Action(
          text: 'Navigate to Customer',
          icon: Icons.navigation,
          onPressed: onNavigateToCustomer,
        ),
      'on_the_way' => _Action(
          text: 'Mark as Delivered',
          icon: Icons.check_circle,
          onPressed: onDelivered,
        ),
      _ => null,
    };
  }
}

class _Action {
  final String text;
  final IconData icon;
  final VoidCallback? onPressed;

  _Action({
    required this.text,
    required this.icon,
    this.onPressed,
  });
}
