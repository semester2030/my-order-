import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/result.dart';
import 'package:vendor_app/core/utils/validators.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/core/widgets/error_state.dart';
import 'package:vendor_app/core/widgets/loading_view.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/menu/domain/entities/menu_item.dart';
import 'package:vendor_app/modules/menu/presentation/providers/menu_state.dart';
import 'package:vendor_app/modules/videos/presentation/screens/videos_screen.dart';
import 'package:vendor_app/modules/videos/presentation/widgets/video_picker_sheet.dart';

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
  bool _uploadingVideo = false;

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

  Future<void> _pickAndUploadVideo() async {
    final countResult = await ref.read(videosRepoProvider).getVendorVideoCount();
    final count = countResult.valueOrNull ?? 0;

    if (!mounted) return;
    if (count >= kMaxVideosPerVendor) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('الحد الأقصى $kMaxVideosPerVendor مقطع. احذف مقطعاً لإضافة جديد.'), backgroundColor: SemanticColors.error),
      );
      return;
    }

    VideoPickerSheet.show(
      context,
      onImagePicked: (_) {},
      onVideoPicked: (path) => _uploadVideo(path),
    );
  }

  Future<void> _uploadVideo(String filePath) async {
    if (!mounted) return;
    if (filePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لم يتم اختيار فيديو'), backgroundColor: Colors.orange),
      );
      return;
    }
    setState(() => _uploadingVideo = true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('جاري رفع الفيديو...'), duration: Duration(seconds: 2)),
    );

    final progress = ValueNotifier<double>(0.0);
    if (mounted) {
      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => ValueListenableBuilder<double>(
          valueListenable: progress,
          builder: (_, value, __) => AlertDialog(
            title: const Text('جاري رفع الفيديو...'),
            content: LinearProgressIndicator(
              value: value > 0 && value <= 1 ? value : null,
            ),
          ),
        ),
      );
    }

    try {
      final result = await ref.read(videosRepoProvider).uploadVideoForMenuItem(
        widget.itemId,
        filePath,
        onProgress: (sent, total) {
          progress.value = total > 0 ? sent / total : 0.0;
        },
      );

      if (mounted) Navigator.of(context).pop();

      if (result.isSuccess) {
        if (mounted) {
          ref.invalidate(menuItemByIdProvider(widget.itemId));
          ref.read(menuNotifierProvider.notifier).refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم رفع الفيديو بنجاح'), backgroundColor: Colors.green),
          );
        }
      } else {
        final f = result.errorOrNull;
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(f?.message ?? 'فشل رفع الفيديو'),
              backgroundColor: SemanticColors.error,
              duration: const Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: ${e.toString()}'),
            backgroundColor: SemanticColors.error,
            duration: const Duration(seconds: 6),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _uploadingVideo = false);
    }
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
                    Gaps.lgV,
                    OutlinedButton.icon(
                      onPressed: _uploadingVideo ? null : _pickAndUploadVideo,
                      icon: Icon(_uploadingVideo ? Icons.hourglass_empty : Icons.video_library, color: AppColors.primary),
                      label: Text(item.videoUrl != null && item.videoUrl!.isNotEmpty ? 'استبدال الفيديو' : 'إضافة فيديو'),
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
