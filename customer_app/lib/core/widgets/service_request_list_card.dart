import 'package:flutter/material.dart';

import '../theme/design_system.dart';

/// إطار موحّد لبطاقة طلب في قوائم العميل (طبخ منزلي / ذبائح وشواء).
class ServiceRequestListCard extends StatelessWidget {
  const ServiceRequestListCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      margin: EdgeInsets.zero,
      color: scheme.surfaceContainerHighest.withValues(alpha: 0.4),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgAll,
        side: BorderSide(
          color: scheme.outlineVariant.withValues(alpha: 0.85),
          width: 1,
        ),
      ),
      child: child,
    );
  }
}
