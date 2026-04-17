import 'package:flutter/material.dart';

import 'package:vendor_app/core/theme/design_system.dart';

/// شعار العلامة داخل مربع بحجم ثابت.
///
/// يستخدم [BoxFit.contain] ثم [displayZoom] لتكبير مركزي داخل نفس المربع؛
/// يقلّل ظهور «الشعار صغير» عندما يحتوي ملف الصورة على هوامش داخلية أو نسبة عمودية.
class BrandedLogo extends StatelessWidget {
  const BrandedLogo({
    super.key,
    required this.assetPath,
    required this.size,
    this.cornerRadius,
    this.tileColor,
    this.displayZoom = 1.38,
  });

  final String assetPath;
  final double size;

  /// نصف قطر الزوايا؛ الافتراضي متناسب مع [size].
  final double? cornerRadius;

  /// لون خلفية البلاطة. إن كان null يُعرض شفافاً.
  final Color? tileColor;

  /// تكبير داخلي بعد [contain]؛ القصّ على حواف الهامش.
  final double displayZoom;

  @override
  Widget build(BuildContext context) {
    final r = cornerRadius ?? size * 0.25;
    final z = displayZoom.clamp(1.0, 2.0);
    final inner = size / z;

    final image = Image.asset(
      assetPath,
      width: inner,
      height: inner,
      fit: BoxFit.contain,
      filterQuality: FilterQuality.high,
      gaplessPlayback: true,
      errorBuilder: (_, __, ___) => Icon(
        Icons.restaurant_rounded,
        size: inner * 0.42,
        color: AppColors.primary,
      ),
    );

    final scaled = Transform.scale(
      scale: z,
      alignment: Alignment.center,
      child: SizedBox(width: inner, height: inner, child: image),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(r),
      child: SizedBox(
        width: size,
        height: size,
        child: DecoratedBox(
          decoration: BoxDecoration(color: tileColor),
          child: Center(child: scaled),
        ),
      ),
    );
  }
}
