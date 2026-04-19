import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/chef_booking_requests/data/models/chef_booking_request_dto.dart';
import 'package:vendor_app/modules/chef_booking_requests/presentation/providers/chef_booking_requests_state.dart';

/// حجوزات ذبائح/شواء — نفس مسار الطبخ المنزلي: عرض سعر → دفع العميل → جاهز → تسليم.
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

  Future<void> _showQuoteDialog(String id) async {
    final l10n = AppLocalizations.of(context);
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.homeCookingQuoteDialogTitle),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: amountCtrl,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(labelText: l10n.homeCookingQuoteAmountHint),
                validator: (v) {
                  final n = double.tryParse((v ?? '').trim().replaceAll(',', '.'));
                  if (n == null || n < 0.01) return l10n.homeCookingInvalidAmount;
                  return null;
                },
              ),
              Gaps.smV,
              TextFormField(
                controller: notesCtrl,
                decoration: InputDecoration(labelText: l10n.homeCookingQuoteNotesHint),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              if (formKey.currentState?.validate() ?? false) {
                Navigator.pop(ctx, true);
              }
            },
            child: Text(l10n.homeCookingSendQuote),
          ),
        ],
      ),
    );

    try {
      if (go != true || !mounted) return;
      final amt = double.parse(amountCtrl.text.trim().replaceAll(',', '.'));
      final ok = await ref.read(chefBookingRequestsNotifierProvider.notifier).quote(
            id,
            quotedAmount: amt,
            quoteNotes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
          );
      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.homeCookingSendQuote), backgroundColor: SemanticColors.success),
        );
      } else {
        final st = ref.read(chefBookingRequestsNotifierProvider);
        if (st is ChefBookingRequestsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(st.message), backgroundColor: SemanticColors.error),
          );
        }
      }
    } finally {
      amountCtrl.dispose();
      notesCtrl.dispose();
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

  Future<void> _markReady(String id) async {
    final ok = await ref.read(chefBookingRequestsNotifierProvider.notifier).markReady(id);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.homeCookingMarkReady), backgroundColor: SemanticColors.success),
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

  Future<void> _showHandoverDialog(String id) async {
    final l10n = AppLocalizations.of(context);
    final notesCtrl = TextEditingController();
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.homeCookingHandoverDialogTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.homeCookingHandoverDialogSubtitle, style: TextStyles.bodySmall),
              Gaps.mdV,
              TextField(
                controller: notesCtrl,
                decoration: InputDecoration(labelText: l10n.homeCookingHandoverNotesHint),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.homeCookingHandoverConfirm)),
        ],
      ),
    );
    try {
      if (go != true || !mounted) return;
      final ok = await ref.read(chefBookingRequestsNotifierProvider.notifier).markHandedOver(
            id,
            handoverNotes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
          );
      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.homeCookingHandedOverSuccess), backgroundColor: SemanticColors.success),
        );
      } else {
        final st = ref.read(chefBookingRequestsNotifierProvider);
        if (st is ChefBookingRequestsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(st.message), backgroundColor: SemanticColors.error),
          );
        }
      }
    } finally {
      notesCtrl.dispose();
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
                        onQuote: () => _showQuoteDialog(req.id),
                        onReject: () => _reject(req.id),
                        onMarkReady: () => _markReady(req.id),
                        onMarkHandedOver: () => _showHandoverDialog(req.id),
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
    required this.onQuote,
    required this.onReject,
    required this.onMarkReady,
    required this.onMarkHandedOver,
  });

  final ChefBookingRequestDto request;
  final String requestTypeLabel;
  final String? mealSlotLabel;
  final String statusLabel;
  final String guestsLabel;
  final String? respondByLine;
  final VoidCallback onQuote;
  final VoidCallback onReject;
  final VoidCallback onMarkReady;
  final VoidCallback onMarkHandedOver;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pending = request.status == 'pending';
    final accepted = request.status == 'accepted';
    final ready = request.status == 'ready';
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
            if (request.quotedAmount != null && request.quotedAmount!.trim().isNotEmpty) ...[
              Gaps.smV,
              Text(
                '${l10n.homeCookingQuotedAmount}: ${request.quotedAmount} ر.س',
                style: TextStyles.bodyMedium,
              ),
            ],
            if (request.quoteNotes != null && request.quoteNotes!.trim().isNotEmpty) ...[
              Gaps.xsV,
              Text(request.quoteNotes!, style: TextStyles.bodySmall),
            ],
            Gaps.smV,
            Text(statusLabel, style: TextStyles.labelLarge),
            if (pending && respondLine != null) ...[
              Gaps.xsV,
              Text(
                respondLine,
                style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
            if (pending) ...[
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
                      onPressed: onQuote,
                      child: Text(l10n.homeCookingSendQuote),
                    ),
                  ),
                ],
              ),
            ],
            if (accepted) ...[
              Gaps.mdV,
              FilledButton(
                onPressed: onMarkReady,
                child: Text(l10n.homeCookingMarkReady),
              ),
            ],
            if (ready) ...[
              Gaps.mdV,
              FilledButton(
                onPressed: onMarkHandedOver,
                child: Text(l10n.homeCookingMarkHandedOverButton),
              ),
            ],
            if (request.status == 'completed' &&
                request.completionCertificateCode != null &&
                request.completionCertificateCode!.isNotEmpty) ...[
              Gaps.smV,
              Text(
                '${l10n.homeCookingCompletionRefLabel}: ${request.completionCertificateCode}',
                style: TextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
