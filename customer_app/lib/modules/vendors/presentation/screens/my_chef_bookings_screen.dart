// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/design_system.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/routing/route_names.dart';
import '../providers/my_chef_bookings_notifier.dart';

/// طلبات حجز الطبّاخ — طبخ الذبائح والشواء الخارجي فقط.
class MyChefBookingsScreen extends ConsumerStatefulWidget {
  const MyChefBookingsScreen({super.key});

  @override
  ConsumerState<MyChefBookingsScreen> createState() => _MyChefBookingsScreenState();
}

class _MyChefBookingsScreenState extends ConsumerState<MyChefBookingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(myChefBookingsNotifierProvider.notifier).load();
    });
  }

  String _mealSlotLabel(AppLocalizations l10n, String slot) {
    switch (slot) {
      case 'dinner':
        return l10n.chefMealSlotDinner;
      case 'lunch':
      default:
        return l10n.chefMealSlotLunch;
    }
  }

  String _requestTypeLabel(AppLocalizations l10n, String? type) {
    switch (type) {
      case 'grilling':
        return l10n.chefBookingTypeGrilling;
      case 'popular_cooking':
      default:
        return l10n.chefBookingTypePopularCooking;
    }
  }

  String _statusLabel(AppLocalizations l10n, String? status) {
    switch (status) {
      case 'completed':
        return l10n.chefBookingStatusCompleted;
      case 'accepted':
        return l10n.chefBookingStatusAccepted;
      case 'rejected':
        return l10n.chefBookingStatusRejected;
      case 'cancelled':
        return l10n.chefBookingStatusCancelled;
      case 'pending':
      default:
        return l10n.chefBookingStatusPending;
    }
  }

  String? _stringField(Map<String, dynamic> row, String camel, String snake) {
    final v = row[camel] ?? row[snake];
    if (v == null) return null;
    return v.toString();
  }

  String _formatDeadline(AppLocalizations l10n, String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return DateFormat.yMMMd(l10n.locale.languageCode).add_jm().format(dt.toLocal());
  }

  String _vendorName(Map<String, dynamic> row) {
    final v = row['vendor'];
    if (v is Map<String, dynamic>) {
      final n = v['name'] ?? v['trade_name'] ?? v['tradeName'];
      if (n is String && n.isNotEmpty) return n;
    }
    return '—';
  }

  Future<void> _confirmChefCompletion(BuildContext context, String id) async {
    final l10n = AppLocalizations.of(context);
    try {
      await ref.read(vendorsRepositoryProvider).confirmChefServiceCompletion(id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.chefBookingCompletionConfirmedSnack)),
      );
      await ref.read(myChefBookingsNotifierProvider.notifier).load();
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _confirmCancel(String id) async {
    final l10n = AppLocalizations.of(context);
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.chefBookingCancelTitle),
        content: Text(l10n.chefBookingCancelMessage),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.chefBookingConfirmCancel)),
        ],
      ),
    );
    if (go != true || !mounted) return;

    final ok = await ref.read(myChefBookingsNotifierProvider.notifier).cancelRequest(id);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.chefBookingCancelledSnackbar)),
      );
    } else {
      final st = ref.read(myChefBookingsNotifierProvider);
      final msg = st is MyChefBookingsError ? st.message : l10n.chefBookingCancelFailed;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      await ref.read(myChefBookingsNotifierProvider.notifier).load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(myChefBookingsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.myChefBookings, style: TextStyles.titleLarge),
      ),
      body: switch (state) {
        MyChefBookingsInitial() || MyChefBookingsLoading() => const Center(child: CircularProgressIndicator()),
        MyChefBookingsError(:final message) => Center(
            child: Padding(
              padding: const EdgeInsets.all(Insets.lg),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(message, textAlign: TextAlign.center, style: TextStyles.bodyMedium),
                  Gaps.mdV,
                  TextButton(
                    onPressed: () => ref.read(myChefBookingsNotifierProvider.notifier).load(),
                    child: Text(l10n.retry),
                  ),
                ],
              ),
            ),
          ),
        MyChefBookingsLoaded(:final items) => items.isEmpty
            ? Center(
                child: Text(
                  l10n.noChefBookings,
                  style: TextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                  textAlign: TextAlign.center,
                ),
              )
            : RefreshIndicator(
                onRefresh: () => ref.read(myChefBookingsNotifierProvider.notifier).load(),
                child: ListView.separated(
                  padding: const EdgeInsets.all(Insets.lg),
                  itemCount: items.length,
                  separatorBuilder: (_, __) => Gaps.mdV,
                  itemBuilder: (context, index) {
                    final row = items[index];
                    final id = _stringField(row, 'id', 'id') ?? '';
                    final status = _stringField(row, 'status', 'status');
                    final reqType = _stringField(row, 'requestType', 'request_type');
                    final date = _stringField(row, 'scheduledDate', 'scheduled_date') ?? '';
                    final time = _stringField(row, 'scheduledTime', 'scheduled_time') ?? '';
                    final mealSlot = _stringField(row, 'mealSlot', 'meal_slot');
                    final scheduleLine = (mealSlot != null && mealSlot.isNotEmpty)
                        ? '$date · ${_mealSlotLabel(l10n, mealSlot)}'
                        : '$date · $time';
                    final guests = row['guestsCount'] ?? row['guests_count'];
                    final respondBy = _stringField(row, 'respondBy', 'respond_by');
                    final pending = status == 'pending';
                    final vendorName = _vendorName(row);

                    Color statusColor;
                    switch (status) {
                      case 'completed':
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

                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(Insets.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(vendorName, style: TextStyles.titleSmall),
                            Gaps.smV,
                            Text(
                              _requestTypeLabel(l10n, reqType),
                              style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                            ),
                            Gaps.smV,
                            Text(
                              scheduleLine,
                              style: TextStyles.bodyMedium,
                            ),
                            if (guests != null) ...[
                              Gaps.xsV,
                              Text(
                                '${l10n.guestsCount}: $guests',
                                style: TextStyles.bodySmall,
                              ),
                            ],
                            Gaps.smV,
                            Text(
                              _statusLabel(l10n, status),
                              style: TextStyles.labelLarge.copyWith(color: statusColor),
                            ),
                            if (pending && respondBy != null && respondBy.isNotEmpty) ...[
                              Gaps.xsV,
                              Text(
                                l10n.chefBookingRespondByLine(_formatDeadline(l10n, respondBy)),
                                style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              ),
                            ],
                            if (pending) ...[
                              Gaps.mdV,
                              OutlinedButton(
                                onPressed: () => _confirmCancel(id),
                                child: Text(l10n.chefBookingCancelButton),
                              ),
                            ],
                            if (status == 'accepted') ...[
                              Gaps.mdV,
                              FilledButton(
                                onPressed: () => _confirmChefCompletion(context, id),
                                child: Text(l10n.chefBookingConfirmCompletionButton),
                              ),
                            ],
                            if (status == 'completed') ...[
                              Gaps.mdV,
                              FilledButton.tonal(
                                onPressed: () => context.push(
                                      '${RouteNames.rating}/$id?subjectType=event_request',
                                    ),
                                child: Text(l10n.rateServiceAction),
                              ),
                              Gaps.smV,
                              OutlinedButton(
                                onPressed: () => context.push(
                                      '${RouteNames.serviceQualityTicket}?subjectType=event_request&subjectId=$id',
                                    ),
                                child: Text(l10n.reportQualityAction),
                              ),
                            ],
                          ],
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
