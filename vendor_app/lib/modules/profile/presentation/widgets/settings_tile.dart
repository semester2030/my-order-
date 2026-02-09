import 'package:flutter/material.dart';

import 'package:vendor_app/core/theme/design_system.dart';

/// عنصر قائمة إعدادات — ثيم موحد (Phase 6).
class SettingsTile extends StatelessWidget {
  const SettingsTile({
    super.key,
    required this.title,
    this.leading,
    this.icon,
    this.onTap,
    this.trailing,
  });

  final String title;
  final Widget? leading;
  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg, vertical: Insets.md),
          child: Row(
            children: [
              if (leading != null)
                leading!
              else if (icon != null)
                Icon(icon, size: IconSizes.md, color: AppColors.primary),
              if (leading != null || icon != null) Gaps.mdH,
              Expanded(
                child: Text(
                  title,
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (trailing != null)
                trailing!
              else if (onTap != null)
                Icon(
                  Icons.chevron_left,
                  size: IconSizes.md,
                  color: AppColors.textTertiary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
