import 'package:flutter/material.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/validators.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/modules/side_orders/domain/entities/side_order_item.dart';

/// نموذج إضافة/تعديل صنف طلب جانبي — Phase 12.
class AddSideOrderForm extends StatefulWidget {
  const AddSideOrderForm({
    super.key,
    this.initialItem,
    required this.onSaved,
    required this.onCancel,
  });

  final SideOrderItem? initialItem;
  final void Function(SideOrderItem item) onSaved;
  final VoidCallback onCancel;

  @override
  State<AddSideOrderForm> createState() => _AddSideOrderFormState();
}

class _AddSideOrderFormState extends State<AddSideOrderForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialItem?.name ?? '');
    _priceController = TextEditingController(
      text: widget.initialItem?.price != null
          ? widget.initialItem!.price.toStringAsFixed(
              widget.initialItem!.price.truncateToDouble() == widget.initialItem!.price ? 0 : 2,
            )
          : '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final price = double.tryParse(_priceController.text.trim());
    if (price == null || price < 0) return;
    widget.onSaved(SideOrderItem(
      id: widget.initialItem?.id ?? '',
      name: _nameController.text.trim(),
      price: price,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: Insets.lg),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.initialItem == null ? 'إضافة صنف' : 'تعديل الصنف',
              style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
            ),
            Gaps.lgV,
            AppTextField(
              controller: _nameController,
              validator: (v) => Validators.required(v, 'اسم الصنف'),
              decoration: InputDecoration(
                labelText: 'اسم الصنف',
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
                if (v == null || v.trim().isEmpty) return 'أدخل السعر';
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
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onCancel,
                    child: const Text('إلغاء'),
                  ),
                ),
                Gaps.mdH,
                Expanded(
                  child: PrimaryButton(
                    label: widget.initialItem == null ? 'إضافة' : 'حفظ',
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
            Gaps.lgV,
          ],
        ),
      ),
    );
  }
}
