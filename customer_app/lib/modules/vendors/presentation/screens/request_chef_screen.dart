// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/constants/provider_categories.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../domain/entities/vendor.dart' show Vendor, PopularCookingAddOn;
import '../../../addresses/domain/entities/address.dart';
import '../../../addresses/presentation/providers/address_notifier.dart';
import '../providers/vendor_notifier.dart';
import '../../domain/repositories/vendors_repo.dart';
import '../../../../core/di/providers.dart';

/// شاشة طلب طباخة أو احجز الطباخ (طبخ الذبائح).
/// — طبخ الذبائح: الطباخ يأتي عندك ليطبخ الذبائح + طلبات جانبية (جريش، قرصان، إدامات).
/// — طبخ منزلي: اختيار أطباق + استلام أو توصيل.
class RequestChefScreen extends ConsumerStatefulWidget {
  final String vendorId;
  /// فئة من الـ Feed (مثلاً popular_cooking) — تُستخدم إذا كان المورد لم يُحدّد فئته بعد.
  final String? feedCategory;
  /// يُمرَّر من صفحة المورّد (مثلاً ?dish=) لتحديد طبق من المعرض مسبقاً.
  final String? initialDishId;

  const RequestChefScreen({
    super.key,
    required this.vendorId,
    this.feedCategory,
    this.initialDishId,
  });

  @override
  ConsumerState<RequestChefScreen> createState() => _RequestChefScreenState();
}

class _RequestChefScreenState extends ConsumerState<RequestChefScreen> {
  final _notesController = TextEditingController();
  final _customDishesController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  /// غداء/عشاء لحجز الولائم أو الشوي عند الموقع — قيم API: `lunch` | `dinner`.
  String? _mealSlot;
  int _guestsCount = 1;
  /// true = توصيل الطلب لموقعي، false = استلام الطلب من عند الطباخ
  bool _delivery = false;
  bool _isSubmitting = false;
  /// معرّفات الأطباق المختارة (ما يريده العميل من هذه الطباخة).
  final Set<String> _selectedDishIds = {};
  /// لطبخ الذبائح: عنوان استقبال الذبائح (مكان الطبخ عند العميل).
  String? _selectedAddressId;
  /// لطبخ الذبائح: أسماء الطلبات الجانبية المختارة (جريش، قرصان، إدامات...).
  final Set<String> _selectedAddOnNames = {};
  /// للشواء الخارجي: أنواع شواء ومقبلات شائعة (تُدمج مع الملاحظات عند الإرسال).
  final Set<String> _selectedGrillingOptions = {};
  /// طبخ منزلي: وقت حر بدل نافذة فطور/غداء/عشاء
  bool _homeUseCustomTime = false;
  /// `breakfast` | `lunch` | `dinner` — عندما لا يُستخدم وقت مخصص
  String? _homeMealSlot;

  @override
  void initState() {
    super.initState();
    final pre = widget.initialDishId?.trim();
    if (pre != null && pre.isNotEmpty) {
      _selectedDishIds.add(pre);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _customDishesController.dispose();
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
      initialTime: _selectedTime ?? const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null) setState(() => _selectedTime = picked);
  }

  void _toggleDish(String dishId) {
    setState(() {
      if (_selectedDishIds.contains(dishId)) {
        _selectedDishIds.remove(dishId);
      } else {
        _selectedDishIds.add(dishId);
      }
    });
  }

  void _toggleAddOn(String name) {
    setState(() {
      if (_selectedAddOnNames.contains(name)) {
        _selectedAddOnNames.remove(name);
      } else {
        _selectedAddOnNames.add(name);
      }
    });
  }

  void _toggleGrillingOption(String key) {
    setState(() {
      if (_selectedGrillingOptions.contains(key)) {
        _selectedGrillingOptions.remove(key);
      } else {
        _selectedGrillingOptions.add(key);
      }
    });
  }

  /// ملاحظات الشواء: سطر من الاختيارات + الملاحظات الحرة (إن وُجدت).
  String? _composeGrillingNotes(AppLocalizations l) {
    final user = _notesController.text.trim();
    if (_selectedGrillingOptions.isEmpty) {
      return user.isEmpty ? null : user;
    }
    final ordered = AppLocalizations.grillingOptionKeys
        .where(_selectedGrillingOptions.contains)
        .map((k) => l.grillingOptionLabel(k))
        .toList();
    final selectionLine = '${l.grillingNotesPrefix}: ${ordered.join('، ')}';
    if (user.isEmpty) return selectionLine;
    return '$selectionLine\n\n$user';
  }

  /// حجز طباخ في موقع العميل (ذبائح أو شواء خارجي أو فلترة من الـ Feed).
  bool _onSiteChefBooking(Vendor v) {
    if (v.isPopularCooking || v.isGrilling) return true;
    final f = widget.feedCategory;
    return f == ProviderCategories.popularCooking ||
        f == ProviderCategories.grilling;
  }

  /// طلبات جانبية (جريش…) — لطبخ الذبائح فقط، ليس للشواء الخارجي.
  bool _sacrificeSideOrdersFlow(Vendor v) {
    if (v.isPopularCooking) return true;
    return widget.feedCategory == ProviderCategories.popularCooking &&
        !v.isGrilling;
  }

  String _apiRequestType(Vendor v) {
    if (!_onSiteChefBooking(v)) return 'home_cooking';
    if (v.isGrilling || widget.feedCategory == ProviderCategories.grilling) {
      return 'grilling';
    }
    return 'popular_cooking';
  }

  IconData _getAddOnIcon(String name) {
    switch (name) {
      case 'جريش':
        return Icons.breakfast_dining;
      case 'قرصان':
        return Icons.cake;
      case 'إدامات':
        return Icons.lunch_dining;
      default:
        return Icons.restaurant;
    }
  }

  /// بطاقة قسم أنيقة مع أيقونة وعنوان
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

  /// زر اختيار (استلام / توصيل)
  Widget _buildOptionChip({
    required IconData icon,
    required String label,
    String? caption,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: selected ? AppColors.primaryContainer : AppColors.surface,
      borderRadius: AppRadius.mdAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: Insets.md, horizontal: Insets.sm),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20, color: selected ? AppColors.primary : AppColors.textSecondary),
                  Gaps.smH,
                  Flexible(
                    child: Text(
                      label,
                      style: TextStyles.labelMedium.copyWith(
                        color: selected ? AppColors.primary : AppColors.textSecondary,
                        fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              if (caption != null && caption.isNotEmpty) ...[
                Gaps.xsV,
                Text(
                  caption,
                  style: TextStyles.labelSmall.copyWith(
                    color: selected ? AppColors.primary.withValues(alpha: 0.85) : AppColors.textTertiary,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitRequest() async {
    final l = AppLocalizations.of(context);
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.selectDate),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    final vendorForFlow = ref.read(vendorNotifierProvider(widget.vendorId)).maybeWhen(
      loaded: (Vendor v, _) => v,
      orElse: () => null,
    );
    if (vendorForFlow == null) return;
    final onSite = _onSiteChefBooking(vendorForFlow);
    /// يطابق شرط الباكند: طبخ منزلي بدون عنوان إلزامي — يعتمد على `providerCategory` أو `?category=` من الـ Feed.
    final isHomeFlow = !onSite &&
        (vendorForFlow.isHomeCooking ||
            widget.feedCategory == ProviderCategories.homeCooking);
    if (onSite) {
      if (_mealSlot == null || _mealSlot!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.selectMealSlot),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    } else if (isHomeFlow) {
      if (_homeUseCustomTime) {
        if (_selectedTime == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.homeCookingSelectCustomTime),
              backgroundColor: AppColors.error,
            ),
          );
          return;
        }
      } else {
        if (_homeMealSlot == null || _homeMealSlot!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l.homeCookingSelectMealSlot),
              backgroundColor: AppColors.error,
            ),
          );
          return;
        }
      }
    } else if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l.selectDateAndTime),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    if (onSite) {
      if (_selectedAddressId == null || _selectedAddressId!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _sacrificeSideOrdersFlow(vendorForFlow)
                  ? l.selectSlaughterAddress
                  : l.selectOnsiteServiceAddress,
            ),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    } else {
      final hasCustomDishes = _customDishesController.text.trim().isNotEmpty;
      final hasSelectedDishes = _selectedDishIds.isNotEmpty;
      if (!hasCustomDishes && !hasSelectedDishes) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l.enterOrSelectDish),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(vendorsRepositoryProvider);
      final vendorData = ref.read(vendorNotifierProvider(widget.vendorId)).maybeWhen(
        loaded: (v, _) => v,
        orElse: () => null,
      );
      final addOnsList = _selectedAddOnNames.map((name) {
        PopularCookingAddOn? addOn;
        for (final a in vendorData?.popularCookingAddOns ?? []) {
          if (a.name == name) {
            addOn = a;
            break;
          }
        }
        return <String, dynamic>{
          'name': name,
          if (addOn != null) 'price': addOn.price,
        };
      }).toList();
      final sacrificeAddonsSubmit = _sacrificeSideOrdersFlow(vendorForFlow);
      final addOnsForApi =
          sacrificeAddonsSubmit ? addOnsList : <Map<String, dynamic>>[];
      final customDishes = _customDishesController.text.trim();
      final rt = _apiRequestType(vendorForFlow);
      final onSiteSubmit = _onSiteChefBooking(vendorForFlow);
      final notesForApi = rt == 'grilling'
          ? _composeGrillingNotes(l)
          : (_notesController.text.trim().isEmpty ? null : _notesController.text.trim());
      final isHome = !onSiteSubmit &&
          (vendorData?.isHomeCooking == true ||
              widget.feedCategory == ProviderCategories.homeCooking);
      final String? scheduledTimeApi = onSiteSubmit
          ? null
          : (isHome && !_homeUseCustomTime
              ? null
              : (_selectedTime != null
                  ? '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}'
                  : null));
      final String? mealSlotApi = onSiteSubmit
          ? _mealSlot
          : (isHome && !_homeUseCustomTime ? _homeMealSlot : null);
      await repo.createEventRequest(
        CreateEventRequestParams(
          vendorId: widget.vendorId,
          requestType: rt,
          scheduledDate: '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
          scheduledTime: scheduledTimeApi,
          mealSlot: mealSlotApi,
          guestsCount: _guestsCount,
          addressId: onSiteSubmit ? _selectedAddressId : null,
          addOns: addOnsForApi,
          dishIds: onSiteSubmit ? null : (_selectedDishIds.isEmpty ? null : _selectedDishIds.toList()),
          customDishNames: onSiteSubmit ? null : (customDishes.isEmpty ? null : customDishes),
          delivery: onSiteSubmit ? null : _delivery,
          notes: notesForApi,
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(onSiteSubmit ? l.chefBookedSuccess : l.orderSentSuccess),
          backgroundColor: AppColors.primary,
        ),
      );
      context.pop();
      if (isHome || onSiteSubmit) {
        context.go(RouteNames.myRequestsHub);
      } else {
        context.go(RouteNames.categories);
      }
    } catch (e) {
      if (!mounted) return;
      final l = AppLocalizations.of(context);
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

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final vendorState = ref.watch(vendorNotifierProvider(widget.vendorId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
          title: vendorState.maybeWhen(
          loaded: (Vendor v, _) => Text(
            _onSiteChefBooking(v) ? l.bookChef : l.requestCooking,
          ),
          orElse: () => Text(
            (widget.feedCategory == ProviderCategories.popularCooking ||
                    widget.feedCategory == ProviderCategories.grilling)
                ? l.bookChef
                : l.requestCooking,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: vendorState.when(
        initial: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (msg) => Center(
          child: Padding(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(msg, textAlign: TextAlign.center),
                Gaps.mdV,
                FilledButton(
                  onPressed: () => ref.read(vendorNotifierProvider(widget.vendorId).notifier).refresh(),
                  child: Text(l.retry),
                ),
              ],
            ),
          ),
        ),
        loaded: (vendor, menuItems) {
          final onSite = _onSiteChefBooking(vendor);
          final sacrificeAddons = _sacrificeSideOrdersFlow(vendor);
          final availableDishes = menuItems.where((m) => m.isAvailable).toList();
          final addressState = ref.watch(addressNotifierProvider);
          final addOns = vendor.popularCookingAddOns ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  onSite ? l.bookChef : l.servicesOnRequest,
                  style: TextStyles.headlineMedium,
                ),
                Gaps.smV,
                Text(
                  sacrificeAddons
                      ? l.popularCookingDescWithName(vendor.name)
                      : (onSite
                          ? l.grillingServiceDescWithName(vendor.name)
                          : l.homeCookingDescWithName(vendor.name)),
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Gaps.xlV,
                // طبخ ذبائح أو شواء خارجي: عنوان موقع التنفيذ
                if (onSite) ...[
                  Text(
                    sacrificeAddons
                        ? l.selectSlaughterAddress
                        : l.selectOnsiteServiceAddress,
                    style: TextStyles.titleMedium,
                  ),
                  Gaps.smV,
                  addressState.when(
                    initial: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    error: (msg) => Text(msg, style: TextStyles.bodySmall.copyWith(color: AppColors.error)),
                    loaded: (List<Address> addresses) {
                      if (addresses.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(Insets.lg),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceElevated,
                            borderRadius: AppRadius.mdAll,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                sacrificeAddons
                                    ? l.noAddressAddOne
                                    : l.noAddressAddOneOnsite,
                                style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                              ),
                              Gaps.smV,
                              FilledButton.icon(
                                onPressed: () => context.push(RouteNames.addAddress),
                                icon: const Icon(Icons.add_location_alt),
                                label: Text(l.addAddress),
                              ),
                            ],
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: addresses.map((addr) {
                          final label = addr.label.isNotEmpty ? addr.label : addr.streetAddress;
                          return RadioListTile<String>(
                            value: addr.id,
                            groupValue: _selectedAddressId,
                            onChanged: (v) => setState(() => _selectedAddressId = v),
                            title: Text(label, style: TextStyles.bodyMedium),
                            subtitle: Text(
                              '${addr.streetAddress}${addr.building != null ? '، مبنى ${addr.building}' : ''}',
                              style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                  Gaps.xlV,
                  if (onSite && !sacrificeAddons) ...[
                    Text(l.grillingSelectionsTitle, style: TextStyles.titleMedium),
                    Gaps.smV,
                    Text(
                      l.grillingSelectionsSubtitle,
                      style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    Gaps.smV,
                    Wrap(
                      spacing: Insets.sm,
                      runSpacing: Insets.sm,
                      children: AppLocalizations.grillingOptionKeys.map((key) {
                        final isSelected = _selectedGrillingOptions.contains(key);
                        return FilterChip(
                          label: Text(l.grillingOptionLabel(key)),
                          selected: isSelected,
                          onSelected: (_) => _toggleGrillingOption(key),
                          selectedColor: AppColors.primaryContainer,
                          checkmarkColor: AppColors.primary,
                        );
                      }).toList(),
                    ),
                    Gaps.xlV,
                  ],
                  if (sacrificeAddons && addOns.isNotEmpty) ...[
                    Text(l.sideOrdersOptional, style: TextStyles.titleMedium),
                    Gaps.smV,
                    Wrap(
                      spacing: Insets.sm,
                      runSpacing: Insets.sm,
                      children: addOns.map((addOn) {
                        final isSelected = _selectedAddOnNames.contains(addOn.name);
                        return FilterChip(
                          avatar: Icon(
                            _getAddOnIcon(addOn.name),
                            size: 20,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                          label: Text('${l.addOnDisplayName(addOn.name)} — ${addOn.price.toStringAsFixed(0)} ر.س'),
                          selected: isSelected,
                          onSelected: (_) => _toggleAddOn(addOn.name),
                          selectedColor: AppColors.primaryContainer,
                          checkmarkColor: AppColors.primary,
                        );
                      }).toList(),
                    ),
                    Gaps.xlV,
                  ] else if (sacrificeAddons) ...[
                    Text(l.sideOrdersOptional, style: TextStyles.titleMedium),
                    Gaps.smV,
                    Text(
                      l.tapToSelectSideOrders,
                      style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    Gaps.smV,
                    Wrap(
                      spacing: Insets.sm,
                      runSpacing: Insets.sm,
                      children: l.addOnFallbackKeys.map((name) {
                        final isSelected = _selectedAddOnNames.contains(name);
                        return FilterChip(
                          avatar: Icon(
                            _getAddOnIcon(name),
                            size: 20,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                          label: Text(l.addOnDisplayName(name)),
                          selected: isSelected,
                          onSelected: (_) => _toggleAddOn(name),
                          selectedColor: AppColors.primaryContainer,
                          checkmarkColor: AppColors.primary,
                        );
                      }).toList(),
                    ),
                    Gaps.xlV,
                  ],
                  // موقع الخدمة: عدد الأشخاص والتاريخ والوقت
                  Text(l.guestsCount, style: TextStyles.labelLarge),
                  Gaps.smV,
                  Row(
                    children: [
                      IconButton(
                        onPressed: _guestsCount > 1 ? () => setState(() => _guestsCount--) : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text('$_guestsCount', style: TextStyles.titleLarge),
                      IconButton(
                        onPressed: () => setState(() => _guestsCount++),
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                  Gaps.lgV,
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.date, style: TextStyles.labelLarge),
                    subtitle: Text(
                      _selectedDate != null
                          ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                          : l.selectDate,
                      style: TextStyles.bodyMedium.copyWith(
                        color: _selectedDate != null ? AppColors.textPrimary : AppColors.textSecondary,
                      ),
                    ),
                    trailing: const Icon(Icons.calendar_today),
                    onTap: _pickDate,
                  ),
                  Gaps.smV,
                  Text(l.chefMealSlotTitle, style: TextStyles.labelLarge),
                  Gaps.smV,
                  Row(
                    children: [
                      Expanded(
                        child: _buildOptionChip(
                          icon: Icons.wb_sunny_outlined,
                          label: l.chefMealSlotLunch,
                          selected: _mealSlot == 'lunch',
                          onTap: () => setState(() => _mealSlot = 'lunch'),
                        ),
                      ),
                      Gaps.smH,
                      Expanded(
                        child: _buildOptionChip(
                          icon: Icons.nightlight_outlined,
                          label: l.chefMealSlotDinner,
                          selected: _mealSlot == 'dinner',
                          onTap: () => setState(() => _mealSlot = 'dinner'),
                        ),
                      ),
                    ],
                  ),
                  Gaps.smV,
                  Text(
                    _mealSlot == 'dinner'
                        ? l.chefMealSlotDinnerHint
                        : (_mealSlot == 'lunch' ? l.chefMealSlotLunchHint : '${l.chefMealSlotLunchHint}\n${l.chefMealSlotDinnerHint}'),
                    style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  Gaps.lgV,
                  AppTextField(
                    controller: _notesController,
                    label: l.additionalNotes,
                    hint: sacrificeAddons
                        ? l.notesHint(true)
                        : l.notesHintGrilling,
                    maxLines: sacrificeAddons ? 2 : 4,
                  ),
                  Gaps.xlV,
                ] else ...[
                  // === الطبخ المنزلي: واجهة واضحة مع مربعات وأيقونات ===
                  _buildSectionCard(
                    icon: Icons.restaurant_menu,
                    title: l.whatDoYouWant,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l.enterWhatYouWant,
                          style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                        Gaps.smV,
                        TextField(
                          controller: _customDishesController,
                          maxLines: 3,
                          onChanged: (_) => setState(() {}),
                          decoration: InputDecoration(
                            hintText: l.whatDoYouWantHint,
                            hintStyle: TextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                            filled: true,
                            fillColor: AppColors.surface,
                            contentPadding: const EdgeInsets.all(Insets.md),
                            border: OutlineInputBorder(
                              borderRadius: AppRadius.mdAll,
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: AppRadius.mdAll,
                              borderSide: BorderSide(color: AppColors.border),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: AppRadius.mdAll,
                              borderSide: BorderSide(color: AppColors.primary, width: 2),
                            ),
                          ),
                          style: TextStyles.bodyLarge,
                        ),
                        if (availableDishes.isNotEmpty) ...[
                          Gaps.mdV,
                          Text(
                            l.selectDishesHint,
                            style: TextStyles.labelSmall.copyWith(color: AppColors.textSecondary),
                          ),
                          Gaps.smV,
                          Wrap(
                            spacing: Insets.sm,
                            runSpacing: Insets.sm,
                            children: availableDishes.map((dish) {
                              final isSelected = _selectedDishIds.contains(dish.id);
                              return FilterChip(
                                avatar: Icon(
                                  Icons.lunch_dining,
                                  size: 18,
                                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                                ),
                                label: Text(dish.name, overflow: TextOverflow.ellipsis, maxLines: 1),
                                selected: isSelected,
                                onSelected: (_) => _toggleDish(dish.id),
                                selectedColor: AppColors.primaryContainer,
                                checkmarkColor: AppColors.primary,
                              );
                            }).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Gaps.lgV,
                  _buildSectionCard(
                    icon: Icons.people,
                    title: l.guestsCount,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton.filled(
                          onPressed: _guestsCount > 1
                              ? () => setState(() => _guestsCount--)
                              : null,
                          icon: const Icon(Icons.remove),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primaryContainer,
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                        Gaps.mdH,
                        Text('$_guestsCount', style: TextStyles.headlineMedium),
                        Gaps.mdH,
                        IconButton.filled(
                          onPressed: () => setState(() => _guestsCount++),
                          icon: const Icon(Icons.add),
                          style: IconButton.styleFrom(
                            backgroundColor: AppColors.primaryContainer,
                            foregroundColor: AppColors.primary,
                          ),
                        ),
                      ],
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
                            Icon(Icons.calendar_month, color: AppColors.primary, size: 28),
                            Gaps.mdH,
                            Expanded(
                              child: Text(
                                _selectedDate != null
                                    ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                                    : l.selectDate,
                                style: TextStyles.bodyLarge.copyWith(
                                  color: _selectedDate != null ? AppColors.textPrimary : AppColors.textSecondary,
                                ),
                              ),
                            ),
                            Icon(Icons.chevron_left, color: AppColors.textTertiary),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Gaps.lgV,
                  _buildSectionCard(
                    icon: Icons.schedule,
                    title: l.homeCookingScheduleTitle,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l.homeCookingScheduleSubtitle,
                          style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                        Gaps.mdV,
                        Wrap(
                          spacing: Insets.sm,
                          runSpacing: Insets.sm,
                          children: [
                            ChoiceChip(
                              label: Text(l.homeCookingMealBreakfast),
                              selected: !_homeUseCustomTime && _homeMealSlot == 'breakfast',
                              onSelected: (_) => setState(() {
                                _homeUseCustomTime = false;
                                _homeMealSlot = 'breakfast';
                              }),
                            ),
                            ChoiceChip(
                              label: Text(l.chefMealSlotLunch),
                              selected: !_homeUseCustomTime && _homeMealSlot == 'lunch',
                              onSelected: (_) => setState(() {
                                _homeUseCustomTime = false;
                                _homeMealSlot = 'lunch';
                              }),
                            ),
                            ChoiceChip(
                              label: Text(l.chefMealSlotDinner),
                              selected: !_homeUseCustomTime && _homeMealSlot == 'dinner',
                              onSelected: (_) => setState(() {
                                _homeUseCustomTime = false;
                                _homeMealSlot = 'dinner';
                              }),
                            ),
                            ChoiceChip(
                              label: Text(l.homeCookingCustomTime),
                              selected: _homeUseCustomTime,
                              onSelected: (_) => setState(() {
                                _homeUseCustomTime = true;
                                _homeMealSlot = null;
                              }),
                            ),
                          ],
                        ),
                        Gaps.smV,
                        Text(
                          _homeUseCustomTime
                              ? l.homeCookingCustomTimeHint
                              : l.homeCookingPresetTimeHint,
                          style: TextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                  if (_homeUseCustomTime) ...[
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
                              Icon(Icons.schedule, color: AppColors.primary, size: 28),
                              Gaps.mdH,
                              Expanded(
                                child: Text(
                                  _selectedTime != null
                                      ? _selectedTime!.format(context)
                                      : l.selectTime,
                                  style: TextStyles.bodyLarge.copyWith(
                                    color: _selectedTime != null ? AppColors.textPrimary : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              Icon(Icons.chevron_left, color: AppColors.textTertiary),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  Gaps.lgV,
                  _buildSectionCard(
                    icon: Icons.delivery_dining,
                    title: l.howToReceive,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildOptionChip(
                                icon: Icons.storefront,
                                label: l.pickupOrder,
                                selected: !_delivery,
                                onTap: () => setState(() => _delivery = false),
                              ),
                            ),
                            Gaps.smH,
                            Expanded(
                              child: _buildOptionChip(
                                icon: Icons.directions_car_outlined,
                                label: l.deliveryOrder,
                                caption: l.homeCookingMrsoolDeliveryCaption,
                                selected: _delivery,
                                onTap: () => setState(() => _delivery = true),
                              ),
                            ),
                          ],
                        ),
                        Gaps.smV,
                        Text(
                          _delivery ? l.deliveryToAddress : l.pickupFromChef,
                          style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Gaps.lgV,
                  _buildSectionCard(
                    icon: Icons.note_alt_outlined,
                    title: l.additionalNotes,
                    child: AppTextField(
                      controller: _notesController,
                      hint: l.notesHint(false),
                      maxLines: 2,
                    ),
                  ),
                ],
                Gaps.xxlV,
                PrimaryButton(
                  onPressed: _isSubmitting ? null : () {
                    if (onSite) {
                      if (_selectedAddressId == null || _selectedAddressId!.isEmpty) return;
                    } else {
                      if (_customDishesController.text.trim().isEmpty && _selectedDishIds.isEmpty) return;
                    }
                    _submitRequest();
                  },
                  isLoading: _isSubmitting,
                  text: onSite
                      ? (_selectedAddressId == null || _selectedAddressId!.isEmpty
                          ? (sacrificeAddons
                              ? l.selectSlaughterAddressBtn
                              : l.selectOnsiteServiceAddressBtn)
                          : l.bookChef)
                      : (_customDishesController.text.trim().isEmpty && _selectedDishIds.isEmpty
                          ? l.enterOrSelectDish
                          : l.sendRequest),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
