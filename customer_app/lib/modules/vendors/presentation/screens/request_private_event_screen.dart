// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../addresses/domain/entities/address.dart';
import '../../../addresses/presentation/providers/address_notifier.dart';
import '../providers/vendor_notifier.dart';
import '../../domain/repositories/vendors_repo.dart';
import '../../../../core/di/providers.dart';

/// ثوابت أنواع المناسبات والخدمات
const List<(String, String)> kEventTypes = [
  ('wedding', 'eventTypeWedding'),
  ('graduation', 'eventTypeGraduation'),
  ('henna', 'eventTypeHenna'),
  ('engagement', 'eventTypeEngagement'),
  ('other', 'eventTypeOther'),
];
const List<(String, String)> kServiceTypes = [
  ('buffet', 'serviceBuffet'),
  ('desserts', 'serviceDesserts'),
  ('drinks', 'serviceDrinks'),
  ('staff', 'serviceStaff'),
];

class RequestPrivateEventScreen extends ConsumerStatefulWidget {
  final String vendorId;

  const RequestPrivateEventScreen({super.key, required this.vendorId});

  @override
  ConsumerState<RequestPrivateEventScreen> createState() =>
      _RequestPrivateEventScreenState();
}

class _RequestPrivateEventScreenState
    extends ConsumerState<RequestPrivateEventScreen> {
  final _notesController = TextEditingController();
  String? _eventType;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedAddressId;
  bool _isSubmitting = false;
  final Map<String, int> _serviceGuests = {};

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? const TimeOfDay(hour: 18, minute: 0),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _setServiceGuests(String serviceType, int guests) {
    setState(() {
      if (guests > 0) {
        _serviceGuests[serviceType] = guests;
      } else {
        _serviceGuests.remove(serviceType);
      }
    });
  }

  List<PrivateEventServiceRequest> _buildServices() {
    return _serviceGuests.entries
        .map((e) => PrivateEventServiceRequest(
              serviceType: e.key,
              guestsCount: e.value,
            ))
        .toList();
  }

  int get _totalGuests =>
      _serviceGuests.values.fold(0, (a, b) => a + b);

  Future<void> _submitRequest() async {
    final l = AppLocalizations.of(context);
    if (_eventType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.eventTypeLabel),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.selectDateAndTime),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (_selectedAddressId == null || _selectedAddressId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.selectEventAddress),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    final services = _buildServices();
    if (services.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.selectAtLeastOneService),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(vendorsRepositoryProvider);
      await repo.createPrivateEventRequest(
        CreatePrivateEventRequestParams(
          vendorId: widget.vendorId,
          addressId: _selectedAddressId,
          eventType: _eventType!,
          eventDate:
              '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
          eventTime:
              '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
          guestsCount: _totalGuests,
          services: services,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.privateEventRequestSuccess),
          backgroundColor: AppColors.primary,
        ),
      );
      context.pop();
      context.go(RouteNames.profile);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l.requestFailed}: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(Insets.lg),
      decoration: BoxDecoration(
        color: AppColors.surfaceElevated,
        borderRadius: AppRadius.lgAll,
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Insets.sm),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: AppRadius.mdAll,
                ),
                child: Icon(icon, color: AppColors.primary, size: 24),
              ),
              Gaps.mdH,
              Text(title, style: TextStyles.titleMedium),
            ],
          ),
          Gaps.mdV,
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final vendorState = ref.watch(vendorNotifierProvider(widget.vendorId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(l.requestPrivateEvent),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: vendorState.when(
        initial: () =>
            const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        loading: () =>
            const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (msg) => Center(
          child: Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(msg, textAlign: TextAlign.center),
                Gaps.mdV,
                FilledButton(
                  onPressed: () => ref
                      .read(vendorNotifierProvider(widget.vendorId).notifier)
                      .refresh(),
                  child: Text(l.retry),
                ),
              ],
            ),
          ),
        ),
        loaded: (vendor, _) {
          final addressState = ref.watch(addressNotifierProvider);
          return SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l.servicesNeeded,
                  style: TextStyles.headlineMedium,
                ),
                Gaps.smV,
                Text(
                  '${l.requestPrivateEvent} ${vendor.name}',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Gaps.xlV,
                _buildSectionCard(
                  icon: Icons.brunch_dining_rounded,
                  title: l.eventTypeLabel,
                  child: Wrap(
                    spacing: Insets.sm,
                    runSpacing: Insets.sm,
                    children: kEventTypes.map((e) {
                      final (value, key) = e;
                      final label = key == 'eventTypeWedding'
                          ? l.eventTypeWedding
                          : key == 'eventTypeGraduation'
                              ? l.eventTypeGraduation
                              : key == 'eventTypeHenna'
                                  ? l.eventTypeHenna
                                  : key == 'eventTypeEngagement'
                                      ? l.eventTypeEngagement
                                      : l.eventTypeOther;
                      final isSelected = _eventType == value;
                      return FilterChip(
                        label: Text(label),
                        selected: isSelected,
                        onSelected: (_) => setState(() => _eventType = value),
                        selectedColor: AppColors.primaryContainer,
                        checkmarkColor: AppColors.primary,
                      );
                    }).toList(),
                  ),
                ),
                Gaps.lgV,
                _buildSectionCard(
                  icon: Icons.restaurant,
                  title: l.servicesNeeded,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: kServiceTypes.map((e) {
                      final (value, key) = e;
                      final label = key == 'serviceBuffet'
                          ? l.serviceBuffet
                          : key == 'serviceDesserts'
                              ? l.serviceDesserts
                              : key == 'serviceDrinks'
                                  ? l.serviceDrinks
                                  : l.serviceStaff;
                      final guests = _serviceGuests[value] ?? 0;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: Insets.md),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(label, style: TextStyles.bodyMedium),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: guests > 0
                                      ? () => _setServiceGuests(
                                          value, guests - 1)
                                      : null,
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                SizedBox(
                                  width: 40,
                                  child: Text(
                                    '$guests',
                                    textAlign: TextAlign.center,
                                    style: TextStyles.titleMedium,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () =>
                                      _setServiceGuests(value, guests + 1),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Gaps.lgV,
                _buildSectionCard(
                  icon: Icons.people,
                  title: l.guestsCount,
                  child: Text(
                    '$_totalGuests ${l.guestsCount}',
                    style: TextStyles.titleMedium,
                  ),
                ),
                Gaps.lgV,
                _buildSectionCard(
                  icon: Icons.calendar_today,
                  title: l.date,
                  child: InkWell(
                    onTap: _pickDate,
                    borderRadius: AppRadius.mdAll,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Insets.sm),
                      child: Row(
                        children: [
                          Icon(Icons.calendar_month,
                              color: AppColors.primary, size: 28),
                          Gaps.mdH,
                          Expanded(
                            child: Text(
                              _selectedDate != null
                                  ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                                  : l.selectDate,
                              style: TextStyles.bodyLarge.copyWith(
                                color: _selectedDate != null
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Icon(Icons.chevron_left,
                              color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                  ),
                ),
                Gaps.lgV,
                _buildSectionCard(
                  icon: Icons.access_time,
                  title: l.startTime,
                  child: InkWell(
                    onTap: _pickTime,
                    borderRadius: AppRadius.mdAll,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: Insets.sm),
                      child: Row(
                        children: [
                          Icon(Icons.schedule,
                              color: AppColors.primary, size: 28),
                          Gaps.mdH,
                          Expanded(
                            child: Text(
                              _selectedTime != null
                                  ? _selectedTime!.format(context)
                                  : l.selectTime,
                              style: TextStyles.bodyLarge.copyWith(
                                color: _selectedTime != null
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ),
                          Icon(Icons.chevron_left,
                              color: AppColors.textTertiary),
                        ],
                      ),
                    ),
                  ),
                ),
                Gaps.lgV,
                _buildSectionCard(
                  icon: Icons.location_on,
                  title: l.selectEventAddress,
                  child: addressState.when(
                    initial: () => const Center(
                        child: CircularProgressIndicator(color: AppColors.primary)),
                    loading: () => const Center(
                        child: CircularProgressIndicator(color: AppColors.primary)),
                    error: (msg) => Text(msg,
                        style: TextStyles.bodySmall.copyWith(
                            color: AppColors.error)),
                    loaded: (List<Address> addresses) {
                      if (addresses.isEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              l.noAddressAddOne,
                              style: TextStyles.bodyMedium.copyWith(
                                  color: AppColors.textSecondary),
                            ),
                            Gaps.smV,
                            FilledButton.icon(
                              onPressed: () =>
                                  context.push(RouteNames.addAddress),
                              icon: const Icon(Icons.add_location_alt),
                              label: Text(l.addAddress),
                            ),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: addresses.map((addr) {
                          final label = addr.label.isNotEmpty
                              ? addr.label
                              : addr.streetAddress;
                          return RadioListTile<String>(
                            value: addr.id,
                            groupValue: _selectedAddressId,
                            onChanged: (v) =>
                                setState(() => _selectedAddressId = v),
                            title: Text(label, style: TextStyles.bodyMedium),
                            subtitle: Text(
                              '${addr.streetAddress}${addr.building != null ? '، مبنى ${addr.building}' : ''}',
                              style: TextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
                Gaps.lgV,
                _buildSectionCard(
                  icon: Icons.note_alt_outlined,
                  title: l.additionalNotes,
                  child: AppTextField(
                    controller: _notesController,
                    hint: l.notesHintHome,
                    maxLines: 2,
                  ),
                ),
                Gaps.xxlV,
                PrimaryButton(
                  onPressed: _isSubmitting ? null : _submitRequest,
                  isLoading: _isSubmitting,
                  text: l.sendRequest,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
