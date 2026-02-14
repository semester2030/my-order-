// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/constants/provider_categories.dart';
import '../../../../core/routing/route_names.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/vendor.dart' show Vendor, PopularCookingAddOn;
import '../../../addresses/domain/entities/address.dart';
import '../../../addresses/presentation/providers/address_notifier.dart';
import '../providers/vendor_notifier.dart';
import '../../domain/repositories/vendors_repo.dart';
import '../../../../core/di/providers.dart';

/// شاشة طلب طباخة أو احجز الطباخ (الطبخ الشعبي).
/// — طبخ شعبي: الطباخ يأتي عندك ليطبخ الذبايح + طلبات جانبية (جريش، قرصان، إدامات).
/// — طبخ منزلي: اختيار أطباق + استلام أو توصيل.
class RequestChefScreen extends ConsumerStatefulWidget {
  final String vendorId;
  /// فئة من الـ Feed (مثلاً popular_cooking) — تُستخدم إذا كان المورد لم يُحدّد فئته بعد.
  final String? feedCategory;

  const RequestChefScreen({
    super.key,
    required this.vendorId,
    this.feedCategory,
  });

  @override
  ConsumerState<RequestChefScreen> createState() => _RequestChefScreenState();
}

class _RequestChefScreenState extends ConsumerState<RequestChefScreen> {
  final _notesController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  int _guestsCount = 1;
  /// true = توصيل الطلب لموقعي، false = استلام الطلب من عند الطباخ
  bool _delivery = false;
  bool _isSubmitting = false;
  /// معرّفات الأطباق المختارة (ما يريده العميل من هذه الطباخة).
  final Set<String> _selectedDishIds = {};
  /// للطبخ الشعبي: عنوان استقبال الذبايح (مكان الطبخ عند العميل).
  String? _selectedAddressId;
  /// للطبخ الشعبي: أسماء الطلبات الجانبية المختارة (جريش، قرصان، إدامات...).
  final Set<String> _selectedAddOnNames = {};

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

  Future<void> _submitRequest() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('اختر التاريخ والوقت'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }
    final isPopularCooking = ref.read(vendorNotifierProvider(widget.vendorId)).maybeWhen(
      loaded: (Vendor v, _) => v.isPopularCooking || (widget.feedCategory == ProviderCategories.popularCooking),
      orElse: () => widget.feedCategory == ProviderCategories.popularCooking,
    );
    if (isPopularCooking) {
      if (_selectedAddressId == null || _selectedAddressId!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('اختر عنوان استقبال الذبايح (مكان الطبخ عندك)'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    } else {
      if (_selectedDishIds.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('اختر طبقاً واحداً على الأقل مما تتقنه الطباخة'),
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
      await repo.createEventRequest(
        CreateEventRequestParams(
          vendorId: widget.vendorId,
          requestType: isPopularCooking ? 'popular_cooking' : 'home_cooking',
          scheduledDate: '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}',
          scheduledTime: '${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
          guestsCount: _guestsCount,
          addressId: isPopularCooking ? _selectedAddressId : null,
          addOns: addOnsList,
          dishIds: isPopularCooking ? null : _selectedDishIds.toList(),
          delivery: isPopularCooking ? null : _delivery,
          notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isPopularCooking ? 'تم حجز الطباخ. سيتم الرد قريباً.' : 'تم إرسال الطلب. سيتم الرد من الطباخة قريباً.'),
          backgroundColor: AppColors.primary,
        ),
      );
      context.pop();
      context.go(RouteNames.orders);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('فشل إرسال الطلب: ${e.toString()}'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vendorState = ref.watch(vendorNotifierProvider(widget.vendorId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
          title: vendorState.maybeWhen(
          loaded: (Vendor v, _) => Text(
            (v.isPopularCooking || widget.feedCategory == ProviderCategories.popularCooking)
                ? 'احجز الطباخ'
                : 'طلب طباخة',
          ),
          orElse: () => Text(
            widget.feedCategory == ProviderCategories.popularCooking
                ? 'احجز الطباخ'
                : 'طلب طباخة',
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
                  child: const Text('إعادة المحاولة'),
                ),
              ],
            ),
          ),
        ),
        loaded: (vendor, menuItems) {
          // استخدام feedCategory كاحتياطي عند وصول المستخدم من Feed بفئة الطبخ الشعبي
          final isPopularCooking = vendor.isPopularCooking ||
              (widget.feedCategory == ProviderCategories.popularCooking);
          final availableDishes = menuItems.where((m) => m.isAvailable).toList();
          final addressState = ref.watch(addressNotifierProvider);
          final addOns = vendor.popularCookingAddOns ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(Insets.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  isPopularCooking ? 'احجز الطباخ' : 'خدمات عند الطلب',
                  style: TextStyles.headlineMedium,
                ),
                Gaps.smV,
                Text(
                  isPopularCooking
                      ? '${vendor.name} سيأتي عندك ليطبخ الذبايح في مكانك (المنزل، المزرعة، الاستراحة). حدد العنوان والتاريخ والوقت وعدد الأشخاص.'
                      : 'اختر ما تريد من أطباق ${vendor.name}، ثم حدد التاريخ والوقت وعدد الأشخاص. لا دفع الآن — سيُرد عليك بعرض سعر أو قبول.',
                  style: TextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                Gaps.xlV,
                // للطبخ الشعبي: عنوان استقبال الذبايح
                if (isPopularCooking) ...[
                  Text('عنوان استقبال الذبايح (مكان الطبخ عندك)', style: TextStyles.titleMedium),
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
                                'لا يوجد عنوان. أضف عنواناً لاستقبال الذبايح.',
                                style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                              ),
                              Gaps.smV,
                              FilledButton.icon(
                                onPressed: () => context.push(RouteNames.addAddress),
                                icon: const Icon(Icons.add_location_alt),
                                label: const Text('إضافة عنوان'),
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
                  // الطلبات الجانبية (جريش، قرصان، إدامات...)
                  if (addOns.isNotEmpty) ...[
                    Text('طلبات جانبية (اختياري)', style: TextStyles.titleMedium),
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
                          label: Text('${addOn.name} — ${addOn.price.toStringAsFixed(0)} ر.س'),
                          selected: isSelected,
                          onSelected: (_) => _toggleAddOn(addOn.name),
                          selectedColor: AppColors.primaryContainer,
                          checkmarkColor: AppColors.primary,
                        );
                      }).toList(),
                    ),
                    Gaps.xlV,
                  ] else ...[
                    Text('طلبات جانبية (اختياري)', style: TextStyles.titleMedium),
                    Gaps.smV,
                    Text(
                      'اضغط لاختيار الطلبات الجانبية المطلوبة:',
                      style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                    Gaps.smV,
                    Wrap(
                      spacing: Insets.sm,
                      runSpacing: Insets.sm,
                      children: ['جريش', 'قرصان', 'إدامات'].map((name) {
                        final isSelected = _selectedAddOnNames.contains(name);
                        return FilterChip(
                          avatar: Icon(
                            _getAddOnIcon(name),
                            size: 20,
                            color: isSelected ? AppColors.primary : AppColors.textSecondary,
                          ),
                          label: Text(name),
                          selected: isSelected,
                          onSelected: (_) => _toggleAddOn(name),
                          selectedColor: AppColors.primaryContainer,
                          checkmarkColor: AppColors.primary,
                        );
                      }).toList(),
                    ),
                    Gaps.xlV,
                  ],
                ] else ...[
                  // ماذا تتقن هذه الطباخة؟ — اختيار الأطباق (للطبخ المنزلي)
                  Text('ماذا تريد من هذه الطباخة؟', style: TextStyles.titleMedium),
                  Gaps.smV,
                  Text(
                    'اختر الأطباق المطلوبة (مثلاً: مقلوبة، حلا تمر، مكرونة بشاميل)',
                    style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  Gaps.mdV,
                  if (availableDishes.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(Insets.lg),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceElevated,
                        borderRadius: AppRadius.mdAll,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.lunch_dining, color: AppColors.textTertiary),
                          Gaps.mdH,
                          Expanded(
                            child: Text(
                              'لا توجد أطباق متاحة للطلب حالياً من هذه الطباخة.',
                              style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Wrap(
                      spacing: Insets.sm,
                      runSpacing: Insets.sm,
                      children: availableDishes.map((dish) {
                        final isSelected = _selectedDishIds.contains(dish.id);
                        return FilterChip(
                          label: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (dish.isSignature)
                                Padding(
                                  padding: const EdgeInsets.only(left: Insets.xs),
                                  child: Icon(
                                    Icons.star,
                                    size: 14,
                                    color: isSelected ? AppColors.textOnPrimary : AppColors.accent,
                                  ),
                                ),
                              Flexible(
                                child: Text(
                                  dish.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          selected: isSelected,
                          onSelected: (_) => _toggleDish(dish.id),
                          selectedColor: AppColors.primaryContainer,
                          checkmarkColor: AppColors.primary,
                        );
                      }).toList(),
                    ),
                  if (_selectedDishIds.isNotEmpty) ...[
                    Gaps.smV,
                    Text(
                      'تم اختيار ${_selectedDishIds.length} طبق/أطباق',
                      style: TextStyles.labelSmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  Gaps.xlV,
                ],
                // عدد الأشخاص
                Text('عدد الأشخاص', style: TextStyles.labelLarge),
                Gaps.smV,
                Row(
                  children: [
                    IconButton(
                      onPressed: _guestsCount > 1
                          ? () => setState(() => _guestsCount--)
                          : null,
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
                // التاريخ
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('التاريخ', style: TextStyles.labelLarge),
                  subtitle: Text(
                    _selectedDate != null
                        ? '${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}'
                        : 'اختر التاريخ',
                    style: TextStyles.bodyMedium.copyWith(
                      color: _selectedDate != null ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: _pickDate,
                ),
                Gaps.smV,
                // الوقت
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('وقت البدء', style: TextStyles.labelLarge),
                  subtitle: Text(
                    _selectedTime != null
                        ? _selectedTime!.format(context)
                        : 'اختر الوقت',
                    style: TextStyles.bodyMedium.copyWith(
                      color: _selectedTime != null ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                  trailing: const Icon(Icons.access_time),
                  onTap: _pickTime,
                ),
                Gaps.lgV,
                // استلام الطلب أو توصيل الطلب — للطبخ المنزلي فقط
                if (!isPopularCooking) ...[
                  Text('كيف تريد استلام الطلب؟', style: TextStyles.labelLarge),
                  Gaps.smV,
                  Row(
                    children: [
                      Expanded(
                        child: FilterChip(
                          label: const Text('استلام الطلب'),
                          selected: !_delivery,
                          onSelected: (_) => setState(() => _delivery = false),
                        ),
                      ),
                      Gaps.smH,
                      Expanded(
                        child: FilterChip(
                          label: const Text('توصيل الطلب'),
                          selected: _delivery,
                          onSelected: (_) => setState(() => _delivery = true),
                        ),
                      ),
                    ],
                  ),
                  Gaps.smV,
                  Text(
                    _delivery ? 'سيتم توصيل الطلب إلى عنوانك' : 'استلام الطلب من عند الطباخ (الطباخ يطبخ في بيته)',
                    style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  Gaps.xlV,
                ],
                AppTextField(
                  controller: _notesController,
                  label: 'ملاحظات إضافية (اختياري)',
                  hint: isPopularCooking ? 'مثال: عدد الذبايح، تفضيلات الطبخ' : 'مثال: بدون بصل، حار، أدوات إضافية',
                  maxLines: 2,
                ),
                Gaps.xxlV,
                PrimaryButton(
                  onPressed: _isSubmitting ? null : () {
                    if (isPopularCooking) {
                      if (_selectedAddressId == null || _selectedAddressId!.isEmpty) return;
                    } else {
                      if (_selectedDishIds.isEmpty) return;
                    }
                    _submitRequest();
                  },
                  isLoading: _isSubmitting,
                  text: isPopularCooking
                      ? (_selectedAddressId == null || _selectedAddressId!.isEmpty
                          ? 'اختر عنوان استقبال الذبايح'
                          : 'احجز الطباخ')
                      : (_selectedDishIds.isEmpty
                          ? 'اختر طبقاً واحداً على الأقل'
                          : 'إرسال الطلب'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
