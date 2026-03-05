import 'package:flutter/material.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../addresses/domain/entities/address.dart';

/// Bottom sheet: عنوان + متى تريد الطلب — قبل الدفع.
class CheckoutDetailsSheet extends StatefulWidget {
  final Address? defaultAddress;
  final VoidCallback onSelectAddress;
  final void Function({
    required String addressId,
    String? notes,
    String? requestedReadyAt,
    String? orderType,
  }) onContinue;

  const CheckoutDetailsSheet({
    super.key,
    required this.defaultAddress,
    required this.onSelectAddress,
    required this.onContinue,
  });

  static Future<void> show(
    BuildContext context, {
    required Address? defaultAddress,
    required VoidCallback onSelectAddress,
    required void Function({
      required String addressId,
      String? notes,
      String? requestedReadyAt,
      String? orderType,
    }) onContinue,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CheckoutDetailsSheet(
        defaultAddress: defaultAddress,
        onSelectAddress: onSelectAddress,
        onContinue: onContinue,
      ),
    );
  }
}

class _CheckoutDetailsSheetState extends State<CheckoutDetailsSheet> {
  bool _isReadyNow = true;
  DateTime? _scheduledDateTime;

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(hours: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(
        _scheduledDateTime ?? now.add(const Duration(hours: 1)),
      ),
    );
    if (time == null || !mounted) return;
    setState(() {
      _scheduledDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _handleContinue() {
    final address = widget.defaultAddress;
    if (address == null) {
      widget.onSelectAddress();
      return;
    }

    String? requestedReadyAt;
    String? orderType;
    if (!_isReadyNow && _scheduledDateTime != null) {
      requestedReadyAt = _scheduledDateTime!.toIso8601String();
      orderType = 'scheduled';
    } else {
      orderType = 'ready_now';
    }

    Navigator.of(context).pop();
    widget.onContinue(
      addressId: address.id,
      requestedReadyAt: requestedReadyAt,
      orderType: orderType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final address = widget.defaultAddress;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        left: Insets.lg,
        right: Insets.lg,
        top: Insets.lg,
        bottom: MediaQuery.of(context).padding.bottom + Insets.lg,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Gaps.lgV,
          Text(
            l10n.whenDoYouWantOrder,
            style: TextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.mdV,
          Row(
            children: [
              Expanded(
                child: _OptionChip(
                  label: l10n.readyNow,
                  selected: _isReadyNow,
                  onTap: () => setState(() {
                    _isReadyNow = true;
                    _scheduledDateTime = null;
                  }),
                ),
              ),
              Gaps.mdH,
              Expanded(
                child: _OptionChip(
                  label: l10n.scheduledFor,
                  selected: !_isReadyNow,
                  onTap: () => setState(() => _isReadyNow = false),
                ),
              ),
            ],
          ),
          if (!_isReadyNow) ...[
            Gaps.mdV,
            InkWell(
              onTap: _pickDateTime,
              borderRadius: AppRadius.mdAll,
              child: Container(
                padding: const EdgeInsets.all(Insets.md),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.divider),
                  borderRadius: AppRadius.mdAll,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      color: AppColors.primary,
                      size: IconSizes.md,
                    ),
                    Gaps.smH,
                    Expanded(
                      child: Text(
                        _scheduledDateTime != null
                            ? '${_scheduledDateTime!.year}-${_scheduledDateTime!.month.toString().padLeft(2, '0')}-${_scheduledDateTime!.day} ${_scheduledDateTime!.hour.toString().padLeft(2, '0')}:${_scheduledDateTime!.minute.toString().padLeft(2, '0')}'
                            : l10n.selectTime,
                        style: TextStyles.bodyMedium.copyWith(
                          color: _scheduledDateTime != null
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_left),
                  ],
                ),
              ),
            ),
          ],
          Gaps.lgV,
          Text(
            l10n.selectAddress,
            style: TextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          Gaps.smV,
          InkWell(
            onTap: widget.onSelectAddress,
            borderRadius: AppRadius.mdAll,
            child: Container(
              padding: const EdgeInsets.all(Insets.md),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.divider),
                borderRadius: AppRadius.mdAll,
              ),
              child: address != null
                  ? Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: AppColors.primary,
                          size: IconSizes.md,
                        ),
                        Gaps.smH,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                address.label,
                                style: TextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Gaps.xsV,
                              Text(
                                '${address.streetAddress}${address.building != null && address.building!.isNotEmpty ? ', ${address.building}' : ''}',
                                style: TextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_left),
                      ],
                    )
                  : Row(
                      children: [
                        Icon(
                          Icons.add_location_alt_outlined,
                          color: AppColors.textSecondary,
                          size: IconSizes.md,
                        ),
                        Gaps.smH,
                        Text(
                          l10n.selectAddressFirst,
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          Gaps.xlV,
          PrimaryButton(
            onPressed: () {
              if (address == null) {
                widget.onSelectAddress();
                return;
              }
              if (!_isReadyNow && _scheduledDateTime == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(l10n.selectTime),
                    backgroundColor: SemanticColors.warning,
                  ),
                );
                return;
              }
              _handleContinue();
            },
            text: l10n.continueToPayment,
            width: double.infinity,
          ),
        ],
      ),
    );
  }
}

class _OptionChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _OptionChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.mdAll,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Insets.md, horizontal: Insets.sm),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withValues(alpha: 0.12) : AppColors.surfaceElevated,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 2 : 1,
          ),
          borderRadius: AppRadius.mdAll,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyles.bodyMedium.copyWith(
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
