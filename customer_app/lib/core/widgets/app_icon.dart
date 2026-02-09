import 'package:flutter/material.dart';
import '../theme/design_system.dart';

/// Unified icon widget for displaying icons
class AppIcon extends StatelessWidget {
  final String icon;
  final double? size;
  final Color? color;
  final bool useMaterialIcon;

  const AppIcon({
    super.key,
    required this.icon,
    this.size,
    this.color,
    this.useMaterialIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = size ?? IconSizes.md;
    final iconColor = color ?? AppColors.textPrimary;

    if (useMaterialIcon) {
      return Icon(
        _getMaterialIcon(icon),
        size: iconSize,
        color: iconColor,
      );
    } else {
      // For SVG icons, you would use flutter_svg package
      // return SvgPicture.asset(
      //   'assets/icons/$icon.svg',
      //   width: iconSize,
      //   height: iconSize,
      //   colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
      // );
      return Icon(
        _getMaterialIcon(icon),
        size: iconSize,
        color: iconColor,
      );
    }
  }

  IconData _getMaterialIcon(String iconName) {
    // Map icon names to Material Icons
    final iconMap = <String, IconData>{
      AppIcons.home: Icons.home,
      AppIcons.search: Icons.search,
      AppIcons.cart: Icons.shopping_cart,
      AppIcons.orders: Icons.receipt,
      AppIcons.profile: Icons.person,
      AppIcons.add: Icons.add,
      AppIcons.remove: Icons.remove,
      AppIcons.delete: Icons.delete,
      AppIcons.edit: Icons.edit,
      AppIcons.close: Icons.close,
      AppIcons.check: Icons.check,
      AppIcons.arrowBack: Icons.arrow_back,
      AppIcons.arrowForward: Icons.arrow_forward,
      AppIcons.restaurant: Icons.restaurant,
      AppIcons.food: Icons.fastfood,
      AppIcons.star: Icons.star,
      AppIcons.starBorder: Icons.star_border,
      AppIcons.favorite: Icons.favorite,
      AppIcons.favoriteBorder: Icons.favorite_border,
      AppIcons.location: Icons.location_on,
      AppIcons.locationPin: Icons.place,
      AppIcons.map: Icons.map,
      AppIcons.payment: Icons.payment,
      AppIcons.creditCard: Icons.credit_card,
      AppIcons.wallet: Icons.account_balance_wallet,
      AppIcons.delivery: Icons.delivery_dining,
      AppIcons.truck: Icons.local_shipping,
      AppIcons.time: Icons.access_time,
      AppIcons.play: Icons.play_arrow,
      AppIcons.pause: Icons.pause,
      AppIcons.volumeUp: Icons.volume_up,
      AppIcons.volumeOff: Icons.volume_off,
      AppIcons.fullscreen: Icons.fullscreen,
      AppIcons.checkCircle: Icons.check_circle,
      AppIcons.error: Icons.error,
      AppIcons.warning: Icons.warning,
      AppIcons.info: Icons.info,
      AppIcons.share: Icons.share,
      AppIcons.phone: Icons.phone,
      AppIcons.email: Icons.email,
    };

    return iconMap[iconName] ?? Icons.help_outline;
  }
}
