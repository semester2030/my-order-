// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/service_request_list_card.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/routing/route_names.dart';
import '../providers/my_home_cooking_notifier.dart';

/// طلبات الطبخ المنزلي — دورة عرض سعر / تحويل / تحضير / جاهز (بدون طلبات الوجبات الجاهزة).
class MyHomeCookingRequestsScreen extends ConsumerStatefulWidget {
  const MyHomeCookingRequestsScreen({super.key});

  @override
  ConsumerState<MyHomeCookingRequestsScreen> createState() => _MyHomeCookingRequestsScreenState();
}

class _MyHomeCookingRequestsScreenState extends ConsumerState<MyHomeCookingRequestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myHomeCookingNotifierProvider.notifier).load();
    });
  }

  String? _stringField(Map<String, dynamic> row, String camel, String snake) {
    final v = row[camel] ?? row[snake];
    if (v == null) return null;
    return v.toString();
  }

  String _normStatus(String? raw) {
    final t = (raw ?? '').trim().toLowerCase();
    return t.isEmpty ? 'pending' : t;
  }

  String _vendorName(Map<String, dynamic> row) {
    final v = row['vendor'];
    if (v is Map<String, dynamic>) {
      final n = v['name'] ?? v['trade_name'] ?? v['tradeName'];
      if (n is String && n.isNotEmpty) return n;
    }
    return '—';
  }

  String _statusLabel(AppLocalizations l10n, String? status) {
    switch (status) {
      case 'quoted':
        return l10n.homeCookingStatusQuoted;
      case 'payment_pending':
        return l10n.homeCookingStatusPaymentPending;
      case 'accepted':
        return l10n.homeCookingStatusAccepted;
      case 'ready':
        return l10n.homeCookingStatusReadyShort;
      case 'handed_over':
        return l10n.homeCookingStatusHandedOver;
      case 'completed':
        return l10n.homeCookingStatusCompleted;
      case 'rejected':
        return l10n.homeCookingStatusRejected;
      case 'cancelled':
        return l10n.homeCookingStatusCancelled;
      case 'pending':
      default:
        return l10n.homeCookingStatusPending;
    }
  }

  String _scheduleLine(Map<String, dynamic> row) {
    final date = _stringField(row, 'scheduledDate', 'scheduled_date') ?? '';
    final time = _stringField(row, 'scheduledTime', 'scheduled_time') ?? '';
    if (date.isEmpty) return time;
    if (time.isEmpty) return date;
    return '$date · $time';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(myHomeCookingNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.myHomeCookingRequests, style: TextStyles.titleLarge),
      ),
      body: switch (state) {
        MyHomeCookingInitial() || MyHomeCookingLoading() => const Center(child: CircularProgressIndicator()),
        MyHomeCookingError(:final message) => Center(
            child: Padding(
              padding: const EdgeInsets.all(Insets.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message, textAlign: TextAlign.center, style: TextStyles.bodyMedium),
                  Gaps.mdV,
                  TextButton(
                    onPressed: () => ref.read(myHomeCookingNotifierProvider.notifier).load(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          ),
        MyHomeCookingLoaded(:final items) => items.isEmpty
            ? Center(
                child: Text(
                  l10n.noHomeCookingRequests,
                  style: TextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              )
            : RefreshIndicator(
                onRefresh: () => ref.read(myHomeCookingNotifierProvider.notifier).load(),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(Insets.lg),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => Gaps.mdV,
                  itemBuilder: (context, index) {
                    final row = items[index];
                    final id = _stringField(row, 'id', 'id') ?? '';
                    final status = _normStatus(_stringField(row, 'status', 'status'));
                    final vendorName = _vendorName(row);
                    final guests = row['guestsCount'] ?? row['guests_count'];
                    final quoted = row['quotedAmount'] ?? row['quoted_amount'];

                    Color statusColor;
                    switch (status) {
                      case 'completed':
                      case 'ready':
                      case 'accepted':
                        statusColor = SemanticColors.success;
                        break;
                      case 'rejected':
                      case 'cancelled':
                        statusColor = AppColors.textSecondary;
                        break;
                      default:
                        statusColor = AppColors.primary;
                    }

                    return ServiceRequestListCard(
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: AppRadius.lgAll,
                          onTap: id.isEmpty
                              ? null
                              : () => context.push('${RouteNames.myHomeCookingRequests}/$id'),
                          child: Padding(
                            padding: const EdgeInsets.all(Insets.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Text(vendorName, style: TextStyles.titleSmall)),
                                    Icon(Icons.chevron_right, color: AppColors.textSecondary),
                                  ],
                                ),
                                Gaps.smV,
                                Text(
                                  _scheduleLine(row),
                                  style: TextStyles.bodyMedium,
                                ),
                                if (guests != null) ...[
                                  Gaps.xsV,
                                  Text(
                                    '${l10n.guestsCount}: $guests',
                                    style: TextStyles.bodySmall,
                                  ),
                                ],
                                if (quoted != null && quoted.toString().isNotEmpty) ...[
                                  Gaps.xsV,
                                  Text(
                                    '${l10n.homeCookingQuotedAmount}: ${quoted.toString()} ر.س',
                                    style: TextStyles.bodySmall,
                                  ),
                                ],
                                Gaps.smV,
                                Text(
                                  _statusLabel(l10n, status),
                                  style: TextStyles.labelLarge.copyWith(color: statusColor),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      },
    );
  }
}
