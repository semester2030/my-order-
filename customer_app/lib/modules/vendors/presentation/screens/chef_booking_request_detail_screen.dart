// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/providers.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/theme/design_system.dart';
import '../providers/my_chef_bookings_notifier.dart';

/// تفاصيل حجز ذبائح/شواء — نفس مسار الطبخ المنزلي (عرض سعر → دفع → تسليم → تأكيد استلام).
class ChefBookingRequestDetailScreen extends ConsumerStatefulWidget {
  const ChefBookingRequestDetailScreen({super.key, required this.requestId});

  final String requestId;

  @override
  ConsumerState<ChefBookingRequestDetailScreen> createState() =>
      _ChefBookingRequestDetailScreenState();
}

class _ChefBookingRequestDetailScreenState extends ConsumerState<ChefBookingRequestDetailScreen> {
  Map<String, dynamic>? _row;
  String? _loadError;
  bool _loading = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final repo = ref.read(vendorsRepositoryProvider);
      final row = await repo.getMyChefBookingRequestById(widget.requestId);
      if (!mounted) return;
      setState(() {
        _row = row;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError = 'err';
        _loading = false;
      });
    }
  }

  String? _stringField(Map<String, dynamic> row, String camel, String snake) {
    final v = row[camel] ?? row[snake];
    if (v == null) return null;
    return v.toString();
  }

  String _vendorName(Map<String, dynamic> row) {
    final v = row['vendor'];
    if (v is Map<String, dynamic>) {
      final n = v['name'] ?? v['trade_name'] ?? v['tradeName'];
      if (n is String && n.isNotEmpty) return n;
    }
    return '—';
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

  String _mealSlotLabel(AppLocalizations l10n, String slot) {
    switch (slot) {
      case 'dinner':
        return l10n.chefMealSlotDinner;
      case 'lunch':
      default:
        return l10n.chefMealSlotLunch;
    }
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

  Future<void> _showConfirmReceiptDialog(String id) async {
    final l10n = AppLocalizations.of(context);
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.homeCookingConfirmReceiptTitle),
        content: SingleChildScrollView(
          child: Text(l10n.homeCookingConfirmReceiptMessage, style: TextStyles.bodyMedium),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.homeCookingConfirmReceiptButton)),
        ],
      ),
    );
    if (go != true || !mounted) return;
    setState(() => _busy = true);
    try {
      await ref.read(vendorsRepositoryProvider).confirmHomeCookingReceipt(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.homeCookingReceiptConfirmedSnackbar)),
      );
      await ref.read(myChefBookingsNotifierProvider.notifier).refresh();
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _legacyConfirmCompletion(String id) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(vendorsRepositoryProvider).confirmChefServiceCompletion(id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.chefBookingCompletionConfirmedSnack)),
      );
      await ref.read(myChefBookingsNotifierProvider.notifier).refresh();
      await _load();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  bool _canCancel(String? status) {
    return status == 'pending' || status == 'quoted' || status == 'payment_pending';
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
      await _load();
    } else {
      final st = ref.read(myChefBookingsNotifierProvider);
      final msg = st is MyChefBookingsError ? st.message : l10n.chefBookingCancelFailed;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _completeCardPayment(String requestId, String method) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final init =
          await ref.read(vendorsRepositoryProvider).initiateHomeCookingCardPayment(requestId, method);
      if (!mounted) return;
      final paymentId = init['id']?.toString();
      if (paymentId == null || paymentId.isEmpty) {
        throw Exception(l10n.isAr ? 'استجابة غير صالحة من الخادم' : 'Invalid server response');
      }
      final secret = init['clientSecret']?.toString();
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.homeCookingCardPaymentTitle),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (secret != null && secret.isNotEmpty) ...[
                  SelectableText(secret, style: TextStyles.bodySmall),
                  Gaps.smV,
                ],
                Text(l10n.homeCookingCardPaymentHint, style: TextStyles.bodySmall),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: Text(l10n.homeCookingCardCompleteButton),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
      await ref.read(paymentsRepositoryProvider).confirmPayment(
            paymentId,
            'client_confirmed_${DateTime.now().millisecondsSinceEpoch}',
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.homeCookingCardSuccess)),
      );
      await ref.read(myChefBookingsNotifierProvider.notifier).refresh();
      await _load();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showDeclareDialog(String id) async {
    final l10n = AppLocalizations.of(context);
    final refCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final formKey = GlobalKey<FormState>();

    final go = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.homeCookingDeclarePayment),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.homeCookingDeclarePaymentHint, style: TextStyles.bodySmall),
                Gaps.mdV,
                TextFormField(
                  controller: refCtrl,
                  decoration: InputDecoration(labelText: l10n.homeCookingPaymentReferenceLabel),
                  validator: (v) {
                    if (v == null || v.trim().length < 3) {
                      return l10n.isAr ? 'ثلاثة أحرف على الأقل' : 'At least 3 characters';
                    }
                    return null;
                  },
                ),
                Gaps.smV,
                TextFormField(
                  controller: notesCtrl,
                  decoration: InputDecoration(labelText: l10n.homeCookingPaymentNotesOptional),
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
            child: Text(l10n.homeCookingSubmitDeclaration),
          ),
        ],
      ),
    );

    try {
      if (go != true || !mounted) return;

      setState(() => _busy = true);
      try {
        await ref.read(vendorsRepositoryProvider).declareHomeCookingPayment(
              id,
              paymentReference: refCtrl.text.trim(),
              notes: notesCtrl.text.trim().isEmpty ? null : notesCtrl.text.trim(),
            );
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.homeCookingDeclareSuccess)),
        );
        await ref.read(myChefBookingsNotifierProvider.notifier).refresh();
        await _load();
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      } finally {
        if (mounted) setState(() => _busy = false);
      }
    } finally {
      refCtrl.dispose();
      notesCtrl.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l10n.myChefBookings, style: TextStyles.titleLarge),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _loadError != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(Insets.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(l10n.homeCookingLoadError, textAlign: TextAlign.center),
                        Gaps.mdV,
                        TextButton(onPressed: _load, child: Text(l10n.retry)),
                      ],
                    ),
                  ),
                )
              : _buildBody(context, l10n, _row!),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n, Map<String, dynamic> row) {
    final id = _stringField(row, 'id', 'id') ?? '';
    final status = _stringField(row, 'status', 'status');
    final date = _stringField(row, 'scheduledDate', 'scheduled_date') ?? '';
    final time = _stringField(row, 'scheduledTime', 'scheduled_time') ?? '';
    final mealSlot = _stringField(row, 'mealSlot', 'meal_slot');
    final reqType = _stringField(row, 'requestType', 'request_type');
    final guests = row['guestsCount'] ?? row['guests_count'];
    final quoted = row['quotedAmount'] ?? row['quoted_amount'];
    final quoteNotes = row['quoteNotes'] ?? row['quote_notes'];
    final notes = row['notes'] as String?;
    final payRef = row['paymentReference'] ?? row['payment_reference'];
    final handoverNotes = row['handoverNotes'] ?? row['handover_notes'];
    final completionCode =
        row['completionCertificateCode'] ?? row['completion_certificate_code'];
    final scheduleLine = (mealSlot != null && mealSlot.isNotEmpty)
        ? '$date · ${_mealSlotLabel(l10n, mealSlot)}'
        : '$date · $time';
    final quotedEmpty = quoted == null || quoted.toString().trim().isEmpty;

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(Insets.lg),
        children: [
          Text(_vendorName(row), style: TextStyles.titleMedium),
          Gaps.xsV,
          Text(
            _requestTypeLabel(l10n, reqType),
            style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
          ),
          Gaps.smV,
          Text(
            _statusLabel(l10n, status),
            style: TextStyles.labelLarge.copyWith(
              color: status == 'completed' ? SemanticColors.success : AppColors.primary,
            ),
          ),
          Gaps.mdV,
          Text(scheduleLine, style: TextStyles.bodyMedium),
          if (guests != null) ...[
            Gaps.smV,
            Text('${l10n.guestsCount}: $guests', style: TextStyles.bodySmall),
          ],
          if (notes != null && notes.trim().isNotEmpty) ...[
            Gaps.smV,
            Text(notes, style: TextStyles.bodySmall),
          ],
          if (quoted != null && quoted.toString().isNotEmpty) ...[
            Gaps.mdV,
            Text('${l10n.homeCookingQuotedAmount}: ${quoted.toString()} ر.س', style: TextStyles.bodyLarge),
          ],
          if (quoteNotes != null && quoteNotes.toString().trim().isNotEmpty) ...[
            Gaps.xsV,
            Text('${l10n.homeCookingQuoteNotes}: ${quoteNotes.toString()}', style: TextStyles.bodySmall),
          ],
          if (status == 'payment_pending' && payRef != null) ...[
            Gaps.mdV,
            Text('${l10n.homeCookingPaymentReferenceLabel}: $payRef', style: TextStyles.bodySmall),
          ],
          if (handoverNotes != null && handoverNotes.toString().trim().isNotEmpty) ...[
            Gaps.mdV,
            Text(handoverNotes.toString(), style: TextStyles.bodySmall),
          ],
          if (status == 'completed' &&
              completionCode != null &&
              completionCode.toString().isNotEmpty) ...[
            Gaps.lgV,
            Text(l10n.homeCookingCompletionCertificate, style: TextStyles.titleSmall),
            Gaps.smV,
            SelectableText(
              completionCode.toString(),
              style: TextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Gaps.smV,
            Text(l10n.homeCookingCompletionCertificateHint, style: TextStyles.bodySmall),
          ],
          if (status == 'completed') ...[
            Gaps.lgV,
            FilledButton.tonal(
              onPressed: _busy
                  ? null
                  : () => context.push(
                        '${RouteNames.rating}/$id?subjectType=event_request',
                      ),
              child: Text(l10n.rateServiceAction),
            ),
            Gaps.smV,
            OutlinedButton(
              onPressed: _busy
                  ? null
                  : () => context.push(
                        '${RouteNames.serviceQualityTicket}?subjectType=event_request&subjectId=$id',
                      ),
              child: Text(l10n.reportQualityAction),
            ),
          ],
          if (status == 'handed_over') ...[
            Gaps.lgV,
            FilledButton(
              onPressed: _busy ? null : () => _showConfirmReceiptDialog(id),
              child: Text(l10n.homeCookingConfirmReceiptButton),
            ),
          ],
          if (status == 'quoted') ...[
            Gaps.lgV,
            Text(l10n.homeCookingCardPaymentTitle, style: TextStyles.titleSmall),
            Gaps.smV,
            Text(l10n.homeCookingCardPaymentHint, style: TextStyles.bodySmall),
            Gaps.mdV,
            Wrap(
              spacing: Insets.sm,
              runSpacing: Insets.sm,
              children: [
                OutlinedButton(
                  onPressed: _busy ? null : () => _completeCardPayment(id, 'mada'),
                  child: Text(l10n.homeCookingCardPayMada),
                ),
                OutlinedButton(
                  onPressed: _busy ? null : () => _completeCardPayment(id, 'apple_pay'),
                  child: Text(l10n.homeCookingCardPayApple),
                ),
                OutlinedButton(
                  onPressed: _busy ? null : () => _completeCardPayment(id, 'stc_pay'),
                  child: Text(l10n.homeCookingCardPayStc),
                ),
              ],
            ),
            Gaps.lgV,
            Text(l10n.homeCookingDeclarePaymentHint, style: TextStyles.bodySmall),
            Gaps.mdV,
            FilledButton(
              onPressed: _busy ? null : () => _showDeclareDialog(id),
              child: Text(l10n.homeCookingDeclarePayment),
            ),
          ],
          if (status == 'accepted' && quotedEmpty) ...[
            Gaps.lgV,
            FilledButton(
              onPressed: _busy ? null : () => _legacyConfirmCompletion(id),
              child: Text(l10n.chefBookingConfirmCompletionButton),
            ),
          ],
          if (_canCancel(status) && id.isNotEmpty) ...[
            Gaps.mdV,
            OutlinedButton(
              onPressed: _busy ? null : () => _confirmCancel(id),
              child: Text(l10n.chefBookingCancelButton),
            ),
          ],
        ],
      ),
    );
  }
}
