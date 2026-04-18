// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/providers.dart';
import '../../../../core/errors/network_exceptions.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/app_bottom_navigation_bar.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/saved_payment_method.dart';

class PaymentMethodsScreen extends ConsumerStatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  ConsumerState<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends ConsumerState<PaymentMethodsScreen> {
  bool _loading = true;
  Object? _loadError;
  List<SavedPaymentMethod> _madaCards = [];

  @override
  void initState() {
    super.initState();
    _loadMadaCards();
  }

  Future<void> _loadMadaCards() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final list = await ref.read(paymentsRepositoryProvider).listSavedPaymentMethods();
      if (!mounted) return;
      setState(() {
        _madaCards = list;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e;
        _loading = false;
      });
    }
  }

  Future<void> _openAddCard() async {
    await context.push(RouteNames.addCard);
    if (mounted) await _loadMadaCards();
  }

  Future<void> _confirmDelete(SavedPaymentMethod card) async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteSavedCardConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.delete)),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    try {
      await ref.read(paymentsRepositoryProvider).deleteSavedPaymentMethod(card.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.savedCardDeletedSuccess)),
      );
      await _loadMadaCards();
    } catch (e) {
      if (!mounted) return;
      final msg = e is NetworkException ? e.message : e.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg), backgroundColor: SemanticColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.paymentMethods,
          style: TextStyles.titleLarge,
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 2),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Insets.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _openAddCard,
              icon: Icon(Icons.add_card),
              label: Text(l10n.addPaymentCard),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: Insets.lg,
                  vertical: Insets.md,
                ),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textOnPrimary,
              ),
            ),
            Gaps.xlV,
            Text(
              l10n.madaSavedCardsTitle,
              style: TextStyles.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Gaps.mdV,
            if (_loading)
              const Center(child: Padding(padding: EdgeInsets.all(Insets.lg), child: CircularProgressIndicator()))
            else if (_loadError != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.loadSavedCardsFailed,
                    style: TextStyles.bodyMedium.copyWith(color: SemanticColors.error),
                  ),
                  Gaps.mdV,
                  OutlinedButton(onPressed: _loadMadaCards, child: Text(l10n.retry)),
                ],
              )
            else if (_madaCards.isEmpty)
              _PaymentMethodCard(
                icon: Icons.credit_card,
                title: 'Mada',
                subtitle: l10n.noCardsSaved,
                onTap: _openAddCard,
              )
            else
              ..._madaCards.map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: Insets.sm),
                  child: _SavedMadaCardTile(
                    card: c,
                    onDelete: () => _confirmDelete(c),
                  ),
                ),
              ),
            Gaps.xlV,
            Text(
              l10n.savedPaymentMethods,
              style: TextStyles.titleMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Gaps.mdV,
            _PaymentMethodCard(
              icon: Icons.apple,
              title: 'Apple Pay',
              subtitle: l10n.connected,
              onTap: () {},
            ),
            Gaps.smV,
            _PaymentMethodCard(
              icon: Icons.account_balance_wallet,
              title: 'STC Pay',
              subtitle: l10n.notConnected,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.comingSoon),
                    backgroundColor: AppColors.info,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedMadaCardTile extends StatelessWidget {
  final SavedPaymentMethod card;
  final VoidCallback onDelete;

  const _SavedMadaCardTile({
    required this.card,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final exp =
        '${card.expMonth.toString().padLeft(2, '0')}/${(card.expYear % 100).toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.all(Insets.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.mdAll,
        boxShadow: AppShadows.elevation1,
      ),
      child: Row(
        children: [
          Icon(Icons.credit_card, color: AppColors.primary, size: IconSizes.lg),
          Gaps.mdH,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mada', style: TextStyles.titleMedium),
                Gaps.xsV,
                Text(
                  '${card.maskedLine} · $exp',
                  style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
                Gaps.xsV,
                Text(
                  card.holderName,
                  style: TextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.delete_outline, color: SemanticColors.error),
            onPressed: onDelete,
            tooltip: AppLocalizations.of(context).delete,
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const _PaymentMethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: Container(
        padding: const EdgeInsets.all(Insets.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceElevated,
          borderRadius: AppRadius.mdAll,
          boxShadow: AppShadows.elevation1,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppColors.primary,
              size: IconSizes.lg,
            ),
            Gaps.mdH,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.titleMedium,
                  ),
                  Gaps.xsV,
                  Text(
                    subtitle,
                    style: TextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.chevron_right,
                color: AppColors.textTertiary,
              ),
          ],
        ),
      ),
    );
  }
}
