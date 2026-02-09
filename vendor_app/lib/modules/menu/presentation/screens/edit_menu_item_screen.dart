import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/validators.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/core/widgets/error_state.dart';
import 'package:vendor_app/core/widgets/loading_view.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/menu/domain/entities/menu_item.dart';
import 'package:vendor_app/modules/menu/presentation/providers/menu_state.dart';

/// شاشة تعديل وجبة — ثيم موحد (Phase 10).
class EditMenuItemScreen extends ConsumerStatefulWidget {
  const EditMenuItemScreen({super.key, required this.itemId});

  final String itemId;

  @override
  ConsumerState<EditMenuItemScreen> createState() => _EditMenuItemScreenState();
}

class _EditMenuItemScreenState extends ConsumerState<EditMenuItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _fillFromItem(MenuItem item) {
    _nameController.text = item.name;
    _descriptionController.text = item.description ?? '';
    _priceController.text = item.price.toStringAsFixed(item.price.truncateToDouble() == item.price ? 0 : 2);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final current = await ref.read(menuItemByIdProvider(widget.itemId).future);
    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final item = MenuItem(
      id: widget.itemId,
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      price: price,
      imageUrl: current?.imageUrl,
      videoUrl: current?.videoUrl,
      isAvailable: current?.isAvailable ?? true,
      category: current?.category,
    );
    final result = await ref.read(menuNotifierProvider.notifier).updateItem(item);
    if (!mounted) return;
    if (result) {
      context.pop();
    } else {
      final state = ref.read(menuNotifierProvider);
      if (state is MenuError && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.message), backgroundColor: SemanticColors.error),
        );
      }
    }
  }

  bool get _saving {
    final state = ref.watch(menuNotifierProvider);
    return state is MenuSaving;
  }

  @override
  Widget build(BuildContext context) {
    final itemAsync = ref.watch(menuItemByIdProvider(widget.itemId));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'تعديل الوجبة',
          style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: itemAsync.when(
        data: (item) {
          if (item == null) {
            return ErrorState(
              message: 'الوجبة غير موجودة',
              onRetry: () => ref.invalidate(menuItemByIdProvider(widget.itemId)),
            );
          }
          if (_nameController.text.isEmpty && item.name.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) => _fillFromItem(item));
          }
          return SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: Insets.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Gaps.lgV,
                    AppTextField(
                      controller: _nameController,
                      validator: (v) => Validators.required(v, 'اسم الوجبة'),
                      decoration: InputDecoration(
                        labelText: 'اسم الوجبة',
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
                        labelText: 'الوصف',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                        filled: true,
                        fillColor: AppColors.surface,
                      ),
                    ),
                    Gaps.mdV,
                    AppTextField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'السعر مطلوب';
                        final n = double.tryParse(v.trim());
                        if (n == null || n < 0) return 'أدخل سعراً صالحاً';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'السعر (ر.س)',
                        border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                        filled: true,
                        fillColor: AppColors.surface,
                      ),
                    ),
                    Gaps.xlV,
                    PrimaryButton(
                      label: _saving ? 'جاري الحفظ...' : 'حفظ',
                      onPressed: _saving ? null : _save,
                    ),
                    Gaps.xxlV,
                  ],
                ),
              ),
            ),
          );
        },
        loading: () => const Center(child: LoadingView()),
        error: (err, _) => ErrorState(
          message: err.toString(),
          onRetry: () => ref.invalidate(menuItemByIdProvider(widget.itemId)),
        ),
      ),
    );
  }
}
