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

/// شاشة تعديل عرض مناسبة.
class EditEventOfferScreen extends ConsumerStatefulWidget {
  const EditEventOfferScreen({super.key, required this.offerId});

  final String offerId;

  @override
  ConsumerState<EditEventOfferScreen> createState() =>
      _EditEventOfferScreenState();
}

class _EditEventOfferScreenState extends ConsumerState<EditEventOfferScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _pricePerPersonController;
  late final TextEditingController _priceTotalController;
  late final TextEditingController _minGuestsController;
  late final TextEditingController _maxGuestsController;

  late String _serviceType;
  late String _eventType;
  late bool _isActive;

  EventOfferDto? _offer;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _pricePerPersonController = TextEditingController();
    _priceTotalController = TextEditingController();
    _minGuestsController = TextEditingController();
    _maxGuestsController = TextEditingController();
    _serviceType = 'buffet';
    _eventType = 'wedding';
    _isActive = true;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadOffer());
  }

  void _loadOffer() {
    final state = ref.read(eventOffersNotifierProvider);
    if (state is EventOffersLoaded) {
      EventOfferDto? found;
      for (final o in state.offers) {
        if (o.id == widget.offerId) {
          found = o;
          break;
        }
      }
      if (found != null) {
        final o = found;
        setState(() {
          _offer = o;
          _titleController.text = o.title ?? '';
          _descriptionController.text = o.description ?? '';
          _pricePerPersonController.text =
              o.pricePerPerson?.toString() ?? '';
          _priceTotalController.text = o.priceTotal?.toString() ?? '';
          _minGuestsController.text = o.minGuests.toString();
          _maxGuestsController.text = o.maxGuests?.toString() ?? '';
          _serviceType = o.serviceType;
          _eventType = o.eventType;
          _isActive = o.isActive;
        });
      }
    }
  }

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
    if (_offer == null) return;
    if (!_formKey.currentState!.validate()) return;

    final minG = int.tryParse(_minGuestsController.text.trim()) ?? 1;
    final maxG = int.tryParse(_maxGuestsController.text.trim());
    final pricePer = double.tryParse(_pricePerPersonController.text.trim());
    final priceTot = double.tryParse(_priceTotalController.text.trim());

    final dto = EventOfferDto(
      id: _offer!.id,
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

    final ok = await ref
        .read(eventOffersNotifierProvider.notifier)
        .updateOffer(widget.offerId, dto);
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

    if (_offer == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          title: Text(
            l10n.editEventOffer,
            style:
                TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          l10n.editEventOffer,
          style:
              TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
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
                  items: [
                    DropdownMenuItem(value: 'buffet', child: Text(l10n.eventOfferBuffet)),
                    DropdownMenuItem(value: 'desserts', child: Text(l10n.eventOfferDesserts)),
                    DropdownMenuItem(value: 'drinks', child: Text(l10n.eventOfferDrinks)),
                    DropdownMenuItem(value: 'staff', child: Text(l10n.eventOfferStaff)),
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
                  items: [
                    DropdownMenuItem(value: 'wedding', child: Text(l10n.eventTypeWedding)),
                    DropdownMenuItem(value: 'graduation', child: Text(l10n.eventTypeGraduation)),
                    DropdownMenuItem(value: 'henna', child: Text(l10n.eventTypeHenna)),
                    DropdownMenuItem(value: 'engagement', child: Text(l10n.eventTypeEngagement)),
                    DropdownMenuItem(value: 'other', child: Text(l10n.eventTypeOther)),
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
