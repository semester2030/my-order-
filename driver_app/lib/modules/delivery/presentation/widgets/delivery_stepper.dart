import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';

class DeliveryStepper extends StatelessWidget {
  final String orderStatus;
  /// When driver has tapped "Pickup Order" but backend still returns out_for_delivery
  final bool hasMarkedPickup;
  final VoidCallback onNavigateToRestaurant;
  final VoidCallback onPickup;
  final VoidCallback onNavigateToCustomer;
  final VoidCallback onDelivered;

  const DeliveryStepper({
    super.key,
    required this.orderStatus,
    this.hasMarkedPickup = false,
    required this.onNavigateToRestaurant,
    required this.onPickup,
    required this.onNavigateToCustomer,
    required this.onDelivered,
  });

  @override
  Widget build(BuildContext context) {
    final isPickedUp = hasMarkedPickup ||
        orderStatus == 'picked_up' ||
        orderStatus == 'delivered';
    final isDelivered = orderStatus == 'delivered';

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      child: Padding(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          children: [
            // Step 1: Navigate to Restaurant
            _buildStep(
              icon: Icons.restaurant,
              title: 'Navigate to Restaurant',
              isCompleted: isPickedUp,
              isActive: !isPickedUp && !isDelivered,
              onTap: onNavigateToRestaurant,
            ),
            _buildConnector(isPickedUp),
            
            // Step 2: Pickup
            _buildStep(
              icon: Icons.check_circle_outline,
              title: 'Pickup Order',
              isCompleted: isPickedUp,
              isActive: !isPickedUp && !isDelivered,
              onTap: onPickup,
            ),
            _buildConnector(isPickedUp),
            
            // Step 3: Navigate to Customer
            _buildStep(
              icon: Icons.navigation,
              title: 'Navigate to Customer',
              isCompleted: isDelivered,
              isActive: isPickedUp && !isDelivered,
              onTap: onNavigateToCustomer,
            ),
            _buildConnector(isDelivered),
            
            // Step 4: Delivered
            _buildStep(
              icon: Icons.done_all,
              title: 'Mark as Delivered',
              isCompleted: isDelivered,
              isActive: isPickedUp && !isDelivered,
              onTap: onDelivered,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep({
    required IconData icon,
    required String title,
    required bool isCompleted,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    Color iconColor;
    Color backgroundColor;
    Widget iconWidget;

    if (isCompleted) {
      iconColor = SemanticColors.success;
      backgroundColor = SemanticColors.successContainer;
      iconWidget = Icon(icon, color: iconColor, size: IconSizes.lg);
    } else if (isActive) {
      iconColor = AppColors.primary;
      backgroundColor = AppColors.primaryContainer;
      iconWidget = Icon(icon, color: iconColor, size: IconSizes.lg);
    } else {
      iconColor = AppColors.textTertiary;
      backgroundColor = AppColors.surface;
      iconWidget = Icon(icon, color: iconColor, size: IconSizes.lg);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Insets.xs),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: AppRadius.mdAll,
            ),
            child: iconWidget,
          ),
          Gaps.mdH,
          Expanded(
            child: Text(
              title,
              style: TextStyles.bodyLarge.copyWith(
                color: isActive || isCompleted
                    ? AppColors.textPrimary
                    : AppColors.textTertiary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          if (isCompleted)
            Icon(
              Icons.check_circle,
              color: SemanticColors.success,
              size: IconSizes.md,
            )
          else if (isActive)
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: Insets.md,
                  vertical: Insets.sm,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text('Tap'),
            ),
        ],
      ),
    );
  }

  Widget _buildConnector(bool isCompleted) {
    return Container(
      margin: const EdgeInsets.only(left: 24),
      width: 2,
      height: 20,
      color: isCompleted ? SemanticColors.success : AppColors.border,
    );
  }
}
