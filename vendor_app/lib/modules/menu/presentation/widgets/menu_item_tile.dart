import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/formatters.dart';
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/modules/menu/domain/entities/menu_item.dart';
import 'package:vendor_app/modules/menu/presentation/widgets/availability_switch.dart';

/// بطاقة وجبة واحدة — الفيديو في الأعلى واسم الوجبة وبيناتها في الأسفل (عرض كامل الشاشة).
class MenuItemTile extends StatelessWidget {
  const MenuItemTile({
    super.key,
    required this.item,
    this.onToggleAvailability,
    this.isToggling = false,
  });

  final MenuItem item;
  final ValueChanged<bool>? onToggleAvailability;
  final bool isToggling;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      child: InkWell(
        onTap: () => context.push(RouteNames.menuItemEdit(item.id)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // الفيديو/الصورة في الأعلى — مربع كامل عرض الشاشة
            ClipRRect(
              borderRadius: AppRadius.topLG,
              child: SizedBox(
                width: double.infinity,
                height: 220,
                child: _buildMediaContent(item),
              ),
            ),
            // اسم الوجبة وبيناتها في الأسفل
            Padding(
              padding: EdgeInsets.all(Insets.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      if (item.videoUrl != null && item.videoUrl!.isNotEmpty)
                        Icon(Icons.videocam, size: 20, color: AppColors.primary),
                      if (item.videoUrl != null && item.videoUrl!.isNotEmpty) Gaps.smH,
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyles.titleLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (item.description != null && item.description!.isNotEmpty) ...[
                    Gaps.smV,
                    Text(
                      item.description!,
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  Gaps.mdV,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Formatters.currency(item.price),
                        style: TextStyles.titleMedium.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (onToggleAvailability != null)
                        AvailabilitySwitch(
                          item: item,
                          onChanged: onToggleAvailability!,
                          isLoading: isToggling,
                        )
                      else
                        Icon(Icons.chevron_left, color: AppColors.textTertiary, size: IconSizes.md),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMediaContent(MenuItem item) {
    final String? imageUrl = item.imageUrl != null && item.imageUrl!.isNotEmpty
        ? item.imageUrl
        : null;
    final String? videoThumbUrl = item.videoThumbnailUrl;
    final String? thumbUrl = imageUrl ?? videoThumbUrl;
    final bool hasVideo = item.videoUrl != null && item.videoUrl!.isNotEmpty;

    if (thumbUrl != null && thumbUrl.isNotEmpty) {
      return Image.network(
        thumbUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _mediaPlaceholder(hasVideo: hasVideo),
      );
    }
    return _mediaPlaceholder(hasVideo: hasVideo);
  }

  Widget _mediaPlaceholder({required bool hasVideo}) {
    return Container(
      color: AppColors.surfaceVariant,
      child: Center(
        child: Icon(
          hasVideo ? Icons.videocam : Icons.restaurant,
          color: AppColors.textTertiary,
          size: 64,
        ),
      ),
    );
  }
}
