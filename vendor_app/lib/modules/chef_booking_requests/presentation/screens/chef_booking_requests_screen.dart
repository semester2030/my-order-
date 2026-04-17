import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/chef_booking_requests/data/models/chef_booking_request_dto.dart';
import 'package:vendor_app/modules/chef_booking_requests/presentation/providers/chef_booking_requests_state.dart';

/// طلبات حجز طبخ الذبائح والشواء — ليست طلبات المناسبات الخاصة.
class ChefBookingRequestsScreen extends ConsumerStatefulWidget {
  const ChefBookingRequestsScreen({super.key});

  @override
  ConsumerState<ChefBookingRequestsScreen> createState() =>
      _ChefBookingRequestsScreenState();
}

class _ChefBookingRequestsScreenState extends ConsumerState<ChefBookingRequestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(chefBookingRequestsNotifierProvider.notifier).load();
    });
  }

  String _requestTypeLabel(AppLocalizations l10n, String type) {
    switch (type) {
      case 'grilling':
        return l10n.chefBookingTypeGrilling;
      case 'popular_cooking':
      default:
        return l10n.chefBookingTypePopularCooking;
    }
  }

  String _statusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'accepted':
        return l10n.chefBookingStatusAccepted;
      case 'rejected':
        return l10n.chefBookingStatusRejected;
      case 'cancelled':
        return l10n.chefBookingStatusCancelled;
      case 'pending':
      default:
        return l10n.eventStatusPending;
    }
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

  String _formatDeadline(AppLocalizations l10n, String iso) {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return iso;
    return DateFormat.yMMMd(l10n.locale.languageCode).add_jm().format(dt.toLocal());
  }

  Future<void> _accept(String id) async {
    final ok = await ref.read(chefBookingRequestsNotifierProvider.notifier).accept(id);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.accept), backgroundColor: SemanticColors.success),
      );
    } else {
      final st = ref.read(chefBookingRequestsNotifierProvider);
      if (st is ChefBookingRequestsError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(st.message), backgroundColor: SemanticColors.error),
        );
      }
    }
  }

  Future<void> _reject(String id) async {
    final ok = await ref.read(chefBookingRequestsNotifierProvider.notifier).reject(id);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.reject), backgroundColor: AppColors.textSecondary),
      );
    } else {
      final st = ref.read(chefBookingRequestsNotifierProvider);
      if (st is ChefBookingRequestsError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(st.message), backgroundColor: SemanticColors.error),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(chefBookingRequestsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          l10n.chefBookingRequests,
          style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: switch (state) {
        ChefBookingRequestsInitial() || ChefBookingRequestsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        ChefBookingRequestsError(:final message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.lg),
                  child: Text(message, textAlign: TextAlign.center),
                ),
                Gaps.mdV,
                TextButton(
                  onPressed: () =>
                      ref.read(chefBookingRequestsNotifierProvider.notifier).load(),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        ChefBookingRequestsLoaded(:final requests) => requests.isEmpty
            ? Center(
                child: Text(
                  l10n.noChefBookingRequests,
                  style: TextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                ),
              )
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(chefBookingRequestsNotifierProvider.notifier).load(),
                child: ListView.builder(
                  padding: EdgeInsets.all(Insets.lg),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: Insets.md),
                      child: _ChefBookingTile(
                        request: req,
                        requestTypeLabel: _requestTypeLabel(l10n, req.requestType),
                        mealSlotLabel: (req.mealSlot != null && req.mealSlot!.isNotEmpty)
                            ? _mealSlotLabel(l10n, req.mealSlot!)
                            : null,
                        statusLabel: _statusLabel(l10n, req.status),
                        guestsLabel: l10n.guestsCount(req.guestsCount),
                        respondByLine: req.respondBy != null && req.respondBy!.isNotEmpty
                            ? l10n.chefBookingRespondByLine(_formatDeadline(l10n, req.respondBy!))
                            : null,
                        onAccept: () => _accept(req.id),
                        onReject: () => _reject(req.id),
                      ),
                    );
                  },
                ),
              ),
      },
    );
  }
}

class _ChefBookingTile extends StatelessWidget {
  const _ChefBookingTile({
    required this.request,
    required this.requestTypeLabel,
    this.mealSlotLabel,
    required this.statusLabel,
    required this.guestsLabel,
    required this.respondByLine,
    required this.onAccept,
    required this.onReject,
  });

  final ChefBookingRequestDto request;
  final String requestTypeLabel;
  final String? mealSlotLabel;
  final String statusLabel;
  final String guestsLabel;
  final String? respondByLine;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canAct = request.status == 'pending';
    final respondLine = respondByLine;
    final userName = request.user?.name ?? request.user?.phone ?? '—';
    final addressStr = request.address != null
        ? '${request.address!.streetAddress ?? ''} ${request.address!.city ?? ''}'.trim()
        : '';

    return Card(
      child: Padding(
        padding: EdgeInsets.all(Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(userName, style: TextStyles.titleSmall),
            Gaps.xsV,
            Text(
              requestTypeLabel,
              style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
            Gaps.smV,
            Text(
              mealSlotLabel != null
                  ? '${request.scheduledDate} · $mealSlotLabel'
                  : '${request.scheduledDate} · ${request.scheduledTime}',
              style: TextStyles.bodyMedium,
            ),
            Gaps.xsV,
            Text(guestsLabel, style: TextStyles.bodySmall),
            if (addressStr.isNotEmpty) ...[
              Gaps.xsV,
              Text(addressStr, style: TextStyles.bodySmall),
            ],
            if (request.notes != null && request.notes!.trim().isNotEmpty) ...[
              Gaps.xsV,
              Text(request.notes!, style: TextStyles.bodySmall),
            ],
            Gaps.smV,
            Text(statusLabel, style: TextStyles.labelLarge),
            if (canAct && respondLine != null) ...[
              Gaps.xsV,
              Text(
                respondLine,
                style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
            if (canAct) ...[
              Gaps.mdV,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReject,
                      child: Text(l10n.reject),
                    ),
                  ),
                  SizedBox(width: Insets.sm),
                  Expanded(
                    child: FilledButton(
                      onPressed: onAccept,
                      child: Text(l10n.accept),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
