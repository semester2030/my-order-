import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/event_requests/data/models/private_event_request_dto.dart';
import 'package:vendor_app/modules/event_requests/presentation/providers/event_requests_state.dart';

/// شاشة طلبات المناسبات — عرض الطلبات وقبول/رفض.
class EventRequestsScreen extends ConsumerStatefulWidget {
  const EventRequestsScreen({super.key});

  @override
  ConsumerState<EventRequestsScreen> createState() =>
      _EventRequestsScreenState();
}

class _EventRequestsScreenState extends ConsumerState<EventRequestsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventRequestsNotifierProvider.notifier).load();
    });
  }

  String _eventTypeLabel(AppLocalizations l10n, String type) {
    switch (type) {
      case 'wedding':
        return l10n.eventTypeWedding;
      case 'graduation':
        return l10n.eventTypeGraduation;
      case 'henna':
        return l10n.eventTypeHenna;
      case 'engagement':
        return l10n.eventTypeEngagement;
      case 'other':
        return l10n.eventTypeOther;
      default:
        return type;
    }
  }

  String _serviceTypeLabel(AppLocalizations l10n, String type) {
    switch (type) {
      case 'buffet':
        return l10n.eventOfferBuffet;
      case 'desserts':
        return l10n.eventOfferDesserts;
      case 'drinks':
        return l10n.eventOfferDrinks;
      case 'staff':
        return l10n.eventOfferStaff;
      default:
        return type;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(eventRequestsNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          l10n.eventRequests,
          style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: switch (state) {
        EventRequestsInitial() || EventRequestsLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        EventRequestsError(:final message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message, textAlign: TextAlign.center),
                Gaps.mdV,
                TextButton(
                  onPressed: () =>
                      ref.read(eventRequestsNotifierProvider.notifier).load(),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        EventRequestsActioning() => const Center(child: CircularProgressIndicator()),
        EventRequestsLoaded(:final requests) => requests.isEmpty
            ? Center(
                child: Text(
                  l10n.noEventRequests,
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(eventRequestsNotifierProvider.notifier).load(),
                child: ListView.builder(
                  padding: EdgeInsets.all(Insets.lg),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final req = requests[index];
                    return _EventRequestTile(
                      request: req,
                      eventLabel: _eventTypeLabel(l10n, req.eventType),
                      guestsLabel: l10n.guestsCount(req.guestsCount),
                      serviceLabel: (t) => _serviceTypeLabel(l10n, t),
                      onAccept: () => _accept(req.id),
                      onReject: () => _reject(req.id),
                    );
                  },
                ),
              ),
      },
    );
  }

  Future<void> _accept(String id) async {
    final ok =
        await ref.read(eventRequestsNotifierProvider.notifier).accept(id);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).accept),
          backgroundColor: SemanticColors.success,
        ),
      );
    } else {
      final state = ref.read(eventRequestsNotifierProvider);
      if (state is EventRequestsError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: SemanticColors.error,
          ),
        );
      }
    }
  }

  Future<void> _reject(String id) async {
    final ok =
        await ref.read(eventRequestsNotifierProvider.notifier).reject(id);
    if (!mounted) return;
    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).reject),
          backgroundColor: AppColors.textSecondary,
        ),
      );
    } else {
      final state = ref.read(eventRequestsNotifierProvider);
      if (state is EventRequestsError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: SemanticColors.error,
          ),
        );
      }
    }
  }
}

class _EventRequestTile extends StatelessWidget {
  const _EventRequestTile({
    required this.request,
    required this.eventLabel,
    required this.guestsLabel,
    required this.serviceLabel,
    required this.onAccept,
    required this.onReject,
  });

  final PrivateEventRequestDto request;
  final String eventLabel;
  final String guestsLabel;
  final String Function(String) serviceLabel;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final canAct = request.status == 'pending';
    final userName = request.user?.name ?? request.user?.phone ?? '—';
    final addressStr = request.address != null
        ? '${request.address!.streetAddress ?? ''} ${request.address!.city ?? ''}'
            .trim()
        : '';

    return Card(
      margin: EdgeInsets.only(bottom: Insets.md),
      child: Padding(
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    eventLabel,
                    style: TextStyles.bodyLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                _StatusChip(status: request.status),
              ],
            ),
            Gaps.smV,
            Text(
              userName,
              style: TextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              '${request.eventDate} ${request.eventTime}',
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              guestsLabel,
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (request.services.isNotEmpty) ...[
              Gaps.smV,
              Text(
                request.services
                    .map((s) => '${serviceLabel(s.serviceType)}: ${s.guestsCount}')
                    .join(' • '),
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            if (addressStr.isNotEmpty)
              Text(
                addressStr,
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            if (request.notes != null && request.notes!.isNotEmpty)
              Text(
                request.notes!,
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            if (canAct) ...[
              Gaps.mdV,
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: onReject,
                    style: TextButton.styleFrom(
                      foregroundColor: SemanticColors.error,
                    ),
                    child: Text(l10n.reject),
                  ),
                  Gaps.smH,
                  ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SemanticColors.success,
                    ),
                    child: Text(l10n.accept),
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

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    String label;
    Color color;
    switch (status) {
      case 'pending':
        label = l10n.eventStatusPending;
        color = SemanticColors.warning;
        break;
      case 'accepted':
        label = l10n.accept;
        color = SemanticColors.success;
        break;
      case 'rejected':
        label = l10n.reject;
        color = SemanticColors.error;
        break;
      default:
        label = status;
        color = AppColors.textSecondary;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Insets.sm, vertical: Insets.xs),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: AppRadius.smAll,
      ),
      child: Text(
        label,
        style: TextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
