import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../domain/entities/cart_item.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CartItemRow extends StatelessWidget {
  final CartItem item;
  final ValueChanged<int>? onQuantityChanged;
  final VoidCallback? onRemove;

  const CartItemRow({
    super.key,
    required this.item,
    this.onQuantityChanged,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: Insets.md),
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.elevation1,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item image
          ClipRRect(
            borderRadius: AppRadius.smAll,
            child: item.menuItem.image != null
                ? CachedNetworkImage(
                    imageUrl: item.menuItem.image!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      width: 80,
                      height: 80,
                      color: AppColors.surface,
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      width: 80,
                      height: 80,
                      color: AppColors.surface,
                      child: const Icon(
                        Icons.restaurant,
                        color: AppColors.textTertiary,
                      ),
                    ),
                  )
                : Container(
                    width: 80,
                    height: 80,
                    color: AppColors.surface,
                    child: const Icon(
                      Icons.restaurant,
                      color: AppColors.textTertiary,
                    ),
                  ),
          ),
          Gaps.mdH,
          // Item details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.menuItem.name,
                  style: TextStyles.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Gaps.xsV,
                Text(
                  '${item.price.toStringAsFixed(2)} SAR',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Gaps.smV,
                // Quantity controls
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onTap: item.quantity > 1
                          ? () => onQuantityChanged?.call(item.quantity - 1)
                          : null,
                    ),
                    Gaps.smH,
                    Text(
                      '${item.quantity}',
                      style: TextStyles.titleMedium,
                    ),
                    Gaps.smH,
                    _QuantityButton(
                      icon: Icons.add,
                      onTap: () => onQuantityChanged?.call(item.quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Subtotal and remove
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.subtotal.toStringAsFixed(2)} SAR',
                style: TextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.smV,
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: AppColors.error,
                  size: IconSizes.sm,
                ),
                onPressed: onRemove,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QuantityButton({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: onTap != null
              ? AppColors.primaryContainer
              : AppColors.disabledContainer,
          borderRadius: AppRadius.smAll,
          border: Border.all(
            color: onTap != null
                ? AppColors.primary
                : AppColors.disabled,
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: IconSizes.sm,
          color: onTap != null
              ? AppColors.primary
              : AppColors.disabledText,
        ),
      ),
    );
  }
}
