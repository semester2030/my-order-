import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import '../theme/design_system.dart';

/// خطوات متابعة طلب الخدمة — تُقرأ من `progressSteps` في استجابة الـ API.
class EventRequestProgressTimeline extends StatelessWidget {
  const EventRequestProgressTimeline({
    super.key,
    required this.steps,
    required this.l10n,
  });

  final List<Map<String, dynamic>> steps;
  final AppLocalizations l10n;

  static List<Map<String, dynamic>> parseSteps(dynamic raw) {
    if (raw is! List) return const [];
    return raw.whereType<Map>().map((e) => Map<String, dynamic>.from(e)).toList();
  }

  static IconData _iconFor(String name) {
    switch (name) {
      case 'receipt_long':
        return Icons.receipt_long_outlined;
      case 'sell':
        return Icons.sell_outlined;
      case 'payments':
        return Icons.payments_outlined;
      case 'account_balance_wallet':
        return Icons.account_balance_wallet_outlined;
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'check_circle':
        return Icons.check_circle_outline;
      case 'local_shipping':
        return Icons.local_shipping_outlined;
      case 'verified':
        return Icons.verified_outlined;
      default:
        return Icons.circle_outlined;
    }
  }

  String _label(String id) {
    switch (id) {
      case 'created':
        return l10n.serviceProgressCreated;
      case 'quoted':
        return l10n.serviceProgressQuoted;
      case 'payment_declared':
        return l10n.serviceProgressPaymentDeclared;
      case 'payment_received':
        return l10n.serviceProgressPaymentReceived;
      case 'preparing':
        return l10n.serviceProgressPreparing;
      case 'ready':
        return l10n.serviceProgressReady;
      case 'handed_over':
        return l10n.serviceProgressHandedOver;
      case 'completed':
        return l10n.serviceProgressCompleted;
      default:
        return id;
    }
  }

  String? _formatAt(String? iso) {
    if (iso == null || iso.isEmpty) return null;
    final dt = DateTime.tryParse(iso);
    if (dt == null) return null;
    final local = dt.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '${local.year}-${local.month.toString().padLeft(2, '0')}-${local.day.toString().padLeft(2, '0')} · $h:$m';
  }

  @override
  Widget build(BuildContext context) {
    if (steps.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.serviceProgressTitle, style: TextStyles.titleSmall),
        Gaps.smV,
        ...steps.map((step) {
          final id = step['id']?.toString() ?? '';
          final done = step['done'] == true;
          final current = step['current'] == true;
          final iconName = step['icon']?.toString() ?? '';
          final at = _formatAt(step['at']?.toString());

          final color = done
              ? SemanticColors.success
              : current
                  ? AppColors.primary
                  : AppColors.textSecondary.withValues(alpha: 0.45);

          return Padding(
            padding: EdgeInsets.only(bottom: Insets.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(_iconFor(iconName), size: 22, color: color),
                SizedBox(width: Insets.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        _label(id),
                        style: TextStyles.bodyMedium.copyWith(
                          fontWeight: current ? FontWeight.w700 : FontWeight.w500,
                          color: done || current
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                      if (at != null) ...[
                        Gaps.xsV,
                        Text(at, style: TextStyles.bodySmall),
                      ],
                    ],
                  ),
                ),
                if (done)
                  Icon(Icons.check, size: 18, color: SemanticColors.success)
                else if (current)
                  SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
