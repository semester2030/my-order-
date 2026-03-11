import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/validators.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/event_offers/data/models/event_offer_dto.dart';
import 'package:vendor_app/modules/event_offers/presentation/providers/event_offers_state.dart';

/// شاشة إضافة عرض مناسبة.
class AddEventOfferScreen extends ConsumerStatefulWidget {
  const AddEventOfferScreen({super.key});

  @override
  ConsumerState<AddEventOfferScreen> createState() =>
      _AddEventOfferScreenState();
}

class _AddEventOfferScreenState extends ConsumerState<AddEventOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _pricePerPersonController = TextEditingController();
  final _priceTotalController = TextEditingController();
  final _minGuestsController = TextEditingController(text: '1');
  final _maxGuestsController = TextEditingController();

  String _serviceType = 'buffet';
  String _eventType = 'wedding';
  bool _isActive = true;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _pricePerPersonController.dispose();
    _priceTotalController.dispose();
    _minGuestsController.dispose();
    _maxGuestsController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final minG = int.tryParse(_minGuestsController.text.trim()) ?? 1;
    final maxG = int.tryParse(_maxGuestsController.text.trim());
    final pricePer = double.tryParse(_pricePerPersonController.text.trim());
    final priceTot = double.tryParse(_priceTotalController.text.trim());

    final dto = EventOfferDto(
      id: '',
      serviceType: _serviceType,
      eventType: _eventType,
      title: _titleController.text.trim().isEmpty
          ? null
          : _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      pricePerPerson: pricePer,
      priceTotal: priceTot,
      minGuests: minG,
      maxGuests: maxG,
      isActive: _isActive,
    );

    final ok =
        await ref.read(eventOffersNotifierProvider.notifier).addOffer(dto);
    if (!mounted) return;
    if (ok) {
      context.pop();
    } else {
      final state = ref.read(eventOffersNotifierProvider);
      if (state is EventOffersError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(state.message),
            backgroundColor: SemanticColors.error,
          ),
        );
      }
    }
  }

  bool get _saving {
    final state = ref.watch(eventOffersNotifierProvider);
    return state is EventOffersSaving;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          l10n.addEventOffer,
          style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: Insets.lg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Gaps.lgV,
                Text(l10n.serviceType, style: TextStyles.bodyMedium),
                Gaps.smV,
                DropdownButtonFormField<String>(
                  value: _serviceType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'buffet', child: Text('buffet')),
                    DropdownMenuItem(value: 'desserts', child: Text('desserts')),
                    DropdownMenuItem(value: 'drinks', child: Text('drinks')),
                    DropdownMenuItem(value: 'staff', child: Text('staff')),
                  ],
                  onChanged: (v) => setState(() => _serviceType = v ?? 'buffet'),
                ),
                Gaps.mdV,
                Text(l10n.eventType, style: TextStyles.bodyMedium),
                Gaps.smV,
                DropdownButtonFormField<String>(
                  value: _eventType,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                  items: const [
                    DropdownMenuItem(value: 'wedding', child: Text('wedding')),
                    DropdownMenuItem(
                        value: 'graduation', child: Text('graduation')),
                    DropdownMenuItem(value: 'henna', child: Text('henna')),
                    DropdownMenuItem(
                        value: 'engagement', child: Text('engagement')),
                    DropdownMenuItem(value: 'other', child: Text('other')),
                  ],
                  onChanged: (v) => setState(() => _eventType = v ?? 'wedding'),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: l10n.titleOptional,
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n.description,
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _pricePerPersonController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.pricePerPersonOptional,
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _priceTotalController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: l10n.priceTotalOptional,
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _minGuestsController,
                  keyboardType: TextInputType.number,
                  validator: (v) => Validators.required(v, l10n.minGuests),
                  decoration: InputDecoration(
                    labelText: l10n.minGuests,
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                AppTextField(
                  controller: _maxGuestsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n.maxGuests,
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                SwitchListTile(
                  title: Text(l10n.active),
                  value: _isActive,
                  onChanged: (v) => setState(() => _isActive = v),
                ),
                Gaps.xlV,
                PrimaryButton(
                  label: _saving ? l10n.saving : l10n.save,
                  onPressed: _saving ? null : _save,
                ),
                Gaps.xxlV,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
