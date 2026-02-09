import 'package:flutter/material.dart';
import '../theme/design_system.dart';
import '../theme/driver_theme.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height ?? DriverTheme.touchTargetMinSize, // Driver-specific: larger touch target
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: AppButtonTheme.primary,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.textOnPrimary,
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: IconSizes.md),
                    Gaps.smH,
                  ],
                  Text(text, style: TextStyles.button),
                ],
              ),
      ),
    );
  }
}
