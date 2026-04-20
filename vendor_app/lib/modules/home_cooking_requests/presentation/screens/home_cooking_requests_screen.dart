import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/widgets/service_request_list_card.dart';
import 'package:vendor_app/modules/home_cooking_requests/data/models/home_cooking_request_dto.dart';
import 'package:vendor_app/modules/home_cooking_requests/presentation/providers/home_cooking_requests_state.dart';

/// طلبات الطبخ المنزلي — عرض سعر / رفض / جاهز (منفصلة عن طلبات الوجبات الجاهزة).
class HomeCookingRequestsScreen extends ConsumerStatefulWidget {
  const HomeCookingRequestsScreen({super.key, this.showDrawerButton = false});

  /// داخل [ShellScreen]: زر القائمة لفتح الـ Drawer.
  final bool showDrawerButton;

  @override
  ConsumerState<HomeCookingRequestsScreen> createState() => _HomeCookingRequestsScreenState();
}

class _HomeCookingRequestsScreenState extends ConsumerState<HomeCookingRequestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeCookingRequestsNotifierProvider.notifier).load();
    });
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

  Future<void> _showQuoteDialog(String id) async {
    final l10n = AppLocalizations.of(context);
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final go = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.homeCookingQuoteDialogTitle),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
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
      final ok = await ref.read(homeCookingRequestsNotifierProvider.notifier).quote(
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
        final st = ref.read(homeCookingRequestsNotifierProvider);
        if (st is HomeCookingRequestsError) {
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
    final l10n = AppLocalizations.of(context);
    final ok = await ref.read(homeCookingRequestsNotifierProvider.notifier).reject(id);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.reject), backgroundColor: AppColors.textSecondary),
      );
    } else {
      final st = ref.read(homeCookingRequestsNotifierProvider);
      if (st is HomeCookingRequestsError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(st.message), backgroundColor: SemanticColors.error),
        );
      }
    }
  }

  Future<void> _markReady(String id) async {
    final l10n = AppLocalizations.of(context);
    final ok = await ref.read(homeCookingRequestsNotifierProvider.notifier).markReady(id);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.homeCookingMarkReady), backgroundColor: SemanticColors.success),
      );
    } else {
      final st = ref.read(homeCookingRequestsNotifierProvider);
      if (st is HomeCookingRequestsError) {
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
      useRootNavigator: true,
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
      final ok = await ref.read(homeCookingRequestsNotifierProvider.notifier).markHandedOver(
            id,
            handoverNotes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
          );
      if (!mounted) return;
      if (ok) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.homeCookingHandedOverSuccess), backgroundColor: SemanticColors.success),
        );
      } else {
        final st = ref.read(homeCookingRequestsNotifierProvider);
        if (st is HomeCookingRequestsError) {
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
    final state = ref.watch(homeCookingRequestsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        leading: widget.showDrawerButton
            ? IconButton(
                icon: Icon(Icons.menu, color: AppColors.textPrimary),
                onPressed: () => Scaffold.of(context).openDrawer(),
              )
            : null,
        title: Text(
          l10n.homeCookingRequests,
          style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: switch (state) {
        HomeCookingRequestsInitial() || HomeCookingRequestsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        HomeCookingRequestsError(:final message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Insets.lg),
                  child: Text(message, textAlign: TextAlign.center),
                ),
                Gaps.mdV,
                TextButton(
                  onPressed: () => ref.read(homeCookingRequestsNotifierProvider.notifier).load(),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        HomeCookingRequestsLoaded(:final requests) => requests.isEmpty
            ? Center(
                child: Text(
                  l10n.noHomeCookingRequests,
                  style: TextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                ),
              )
            : RefreshIndicator(
                onRefresh: () => ref.read(homeCookingRequestsNotifierProvider.notifier).load(),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.all(Insets.lg),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: Insets.md),
                      child: _HomeCookingTile(
                        request: req,
                        statusLabel: _statusLabel(l10n, req.status),
                        guestsLabel: l10n.guestsCount(req.guestsCount),
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

class _HomeCookingTile extends StatelessWidget {
  const _HomeCookingTile({
    required this.request,
    required this.statusLabel,
    required this.guestsLabel,
    required this.onQuote,
    required this.onReject,
    required this.onMarkReady,
    required this.onMarkHandedOver,
  });

  final HomeCookingRequestDto request;
  final String statusLabel;
  final String guestsLabel;
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
    final userName = request.user?.name ?? request.user?.phone ?? '—';
    final addressStr = request.address != null
        ? '${request.address!.streetAddress ?? ''} ${request.address!.city ?? ''}'.trim()
        : '';

    return ServiceRequestListCard(
      child: Padding(
        padding: EdgeInsets.all(Insets.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(userName, style: TextStyles.titleSmall),
            Gaps.smV,
            Text(
              '${request.scheduledDate} · ${request.scheduledTime}',
              style: TextStyles.bodyMedium,
            ),
            Gaps.xsV,
            Text(guestsLabel, style: TextStyles.bodySmall),
            if (request.delivery != null) ...[
              Gaps.xsV,
              Text(
                request.delivery! ? l10n.homeCookingDeliveryYes : l10n.homeCookingDeliveryNo,
                style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
            if (request.customDishNames != null && request.customDishNames!.trim().isNotEmpty) ...[
              Gaps.xsV,
              Text(request.customDishNames!, style: TextStyles.bodySmall),
            ],
            if (request.notes != null && request.notes!.trim().isNotEmpty) ...[
              Gaps.xsV,
              Text(request.notes!, style: TextStyles.bodySmall),
            ],
            if (addressStr.isNotEmpty) ...[
              Gaps.xsV,
              Text(addressStr, style: TextStyles.bodySmall),
            ],
            if (request.quotedAmount != null && request.quotedAmount!.isNotEmpty) ...[
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
            if (pending) ...[
              Gaps.mdV,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onReject,
                      child: Text(l10n.homeCookingRejectRequest),
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
