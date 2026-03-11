import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/modules/event_offers/data/models/event_offer_dto.dart';
import 'package:vendor_app/modules/event_offers/presentation/providers/event_offers_state.dart';

/// شاشة عروض المناسبات — عرض القائمة وإضافة/تعديل/حذف.
class EventOffersScreen extends ConsumerStatefulWidget {
  const EventOffersScreen({super.key});

  @override
  ConsumerState<EventOffersScreen> createState() => _EventOffersScreenState();
}

class _EventOffersScreenState extends ConsumerState<EventOffersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(eventOffersNotifierProvider.notifier).load();
    });
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = ref.watch(eventOffersNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          l10n.eventOffers,
          style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: switch (state) {
        EventOffersInitial() || EventOffersLoading() => const Center(
            child: CircularProgressIndicator(),
          ),
        EventOffersError(:final message) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message, textAlign: TextAlign.center),
                Gaps.mdV,
                TextButton(
                  onPressed: () =>
                      ref.read(eventOffersNotifierProvider.notifier).load(),
                  child: Text(l10n.retry),
                ),
              ],
            ),
          ),
        EventOffersSaving() => const Center(child: CircularProgressIndicator()),
        EventOffersLoaded(:final offers) => offers.isEmpty
            ? Center(
                child: Text(
                  l10n.noEventOffers,
                  style: TextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              )
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(eventOffersNotifierProvider.notifier).load(),
                child: ListView.builder(
                  padding: EdgeInsets.all(Insets.lg),
                  itemCount: offers.length,
                  itemBuilder: (context, index) {
                    final offer = offers[index];
                    return _EventOfferTile(
                      offer: offer,
                      serviceLabel: _serviceTypeLabel(l10n, offer.serviceType),
                      eventLabel: _eventTypeLabel(l10n, offer.eventType),
                      onTap: () =>
                          context.push(RouteNames.eventOfferEdit(offer.id)),
                      onDelete: () => _confirmDelete(context, l10n, offer),
                    );
                  },
                ),
              ),
      },
      floatingActionButton: state is! EventOffersInitial &&
              state is! EventOffersLoading &&
              state is! EventOffersError
          ? FloatingActionButton.extended(
              onPressed: () => context.push(RouteNames.eventOffersAdd),
              icon: const Icon(Icons.add),
              label: Text(l10n.addEventOffer),
            )
          : null,
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AppLocalizations l10n,
    EventOfferDto offer,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(
          '${offer.title ?? offer.serviceType} — ${l10n.delete}؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: SemanticColors.error,
            ),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (ok == true && mounted) {
      await ref.read(eventOffersNotifierProvider.notifier).deleteOffer(offer.id);
    }
  }
}

class _EventOfferTile extends StatelessWidget {
  const _EventOfferTile({
    required this.offer,
    required this.serviceLabel,
    required this.eventLabel,
    required this.onTap,
    required this.onDelete,
  });

  final EventOfferDto offer;
  final String serviceLabel;
  final String eventLabel;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final priceStr = offer.priceTotal != null
        ? '${offer.priceTotal!.toStringAsFixed(0)} ر.س'
        : offer.pricePerPerson != null
            ? '${offer.pricePerPerson!.toStringAsFixed(0)} ر.س/فرد'
            : '—';

    return Card(
      margin: EdgeInsets.only(bottom: Insets.md),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: Insets.lg,
          vertical: Insets.sm,
        ),
        title: Text(
          offer.title ?? '$serviceLabel — $eventLabel',
          style: TextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (offer.title != null)
              Text(
                '$serviceLabel — $eventLabel',
                style: TextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            Text(
              priceStr,
              style: TextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            if (!offer.isActive)
              Text(
                l10n.inactive,
                style: TextStyles.bodySmall.copyWith(
                  color: SemanticColors.warning,
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (v) {
            if (v == 'edit') {
              onTap();
            } else if (v == 'delete') {
              onDelete();
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(value: 'edit', child: Text(l10n.editEventOffer)),
            PopupMenuItem(
              value: 'delete',
              child: Text(l10n.delete, style: TextStyle(color: SemanticColors.error)),
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
