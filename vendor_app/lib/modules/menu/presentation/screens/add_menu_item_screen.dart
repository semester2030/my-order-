import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/result.dart';
import 'package:vendor_app/core/utils/validators.dart';
import 'package:vendor_app/core/widgets/app_text_field.dart';
import 'package:vendor_app/core/widgets/primary_button.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/menu/domain/entities/menu_item.dart';
import 'package:vendor_app/modules/videos/presentation/widgets/video_picker_sheet.dart';
import 'package:vendor_app/modules/videos/presentation/screens/videos_screen.dart';
import 'package:vendor_app/modules/menu/presentation/providers/menu_state.dart';

/// شاشة إضافة وجبة — ثيم موحد (Phase 10).
class AddMenuItemScreen extends ConsumerStatefulWidget {
  const AddMenuItemScreen({super.key});

  @override
  ConsumerState<AddMenuItemScreen> createState() => _AddMenuItemScreenState();
}

class _AddMenuItemScreenState extends ConsumerState<AddMenuItemScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  String? _selectedImagePath;
  String? _selectedVideoPath;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    String? imageUrl = _selectedImagePath;
    // Phase 19: رفع الصورة مع تقدّم الرفع إن كان المسار محلياً.
    if (_selectedImagePath != null && !_selectedImagePath!.startsWith('http')) {
      final progress = ValueNotifier<double>(0.0);
      if (mounted) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ValueListenableBuilder<double>(
            valueListenable: progress,
            builder: (_, value, __) => AlertDialog(
              title: Text(AppLocalizations.of(context).uploadingImage),
              content: LinearProgressIndicator(
                value: value > 0 && value <= 1 ? value : null,
              ),
            ),
          ),
        );
      }
      final result = await ref.read(videosRepoProvider).uploadFile(
            _selectedImagePath!,
            onProgress: (sent, total) {
              progress.value = total > 0 ? sent / total : 0.0;
            },
          );
      if (mounted) Navigator.of(context).pop();
      result.when(
        success: (url) => imageUrl = url,
        failure: (f) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(f.message), backgroundColor: SemanticColors.error),
            );
          }
        },
      );
      if (result.isFailure) return;
    }

    String? videoUrl;
    if (_selectedVideoPath != null && !_selectedVideoPath!.startsWith('http')) {
      final progress = ValueNotifier<double>(0.0);
      if (mounted) {
        showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ValueListenableBuilder<double>(
            valueListenable: progress,
            builder: (_, value, __) => AlertDialog(
              title: Text(AppLocalizations.of(context).uploadingVideo),
              content: LinearProgressIndicator(
                value: value > 0 && value <= 1 ? value : null,
              ),
            ),
          ),
        );
      }
      final resultVideo = await ref.read(videosRepoProvider).uploadFile(
            _selectedVideoPath!,
            onProgress: (sent, total) {
              progress.value = total > 0 ? sent / total : 0.0;
            },
          );
      if (mounted) Navigator.of(context).pop();
      resultVideo.when(
        success: (url) => videoUrl = url,
        failure: (f) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(f.message), backgroundColor: SemanticColors.error),
            );
          }
        },
      );
      if (resultVideo.isFailure) return;
    } else if (_selectedVideoPath != null) {
      videoUrl = _selectedVideoPath;
    }

    final price = double.tryParse(_priceController.text.trim()) ?? 0.0;
    final item = MenuItem(
      id: '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      price: price,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      isAvailable: true,
      category: null,
    );
    final ok = await ref.read(menuNotifierProvider.notifier).addItem(item);
    if (!mounted) return;
    if (ok) {
      ref.read(menuNotifierProvider.notifier).refresh();
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
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        title: Text(
          'إضافة وجبة',
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
                Gaps.mdV,
                OutlinedButton.icon(
                  onPressed: () => VideoPickerSheet.show(
                    context,
                    onImagePicked: (path) => setState(() => _selectedImagePath = path),
                  ),
                  icon: const Icon(Icons.add_photo_alternate),
                  label: Text(_selectedImagePath == null ? 'إضافة صورة' : 'تم اختيار صورة'),
                ),
                Gaps.smV,
                OutlinedButton.icon(
                  onPressed: () async {
                    final countResult = await ref.read(videosRepoProvider).getVendorVideoCount();
                    if (!mounted) return;
                    countResult.when(
                      success: (count) {
                        if (count >= kMaxVideosPerVendor) {
                          showDialog<void>(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text(AppLocalizations.of(context).videos),
                              content: Text(AppLocalizations.of(context).videosMaxReached),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(ctx).pop(),
                                  child: Text(AppLocalizations.of(context).cancel),
                                ),
                              ],
                            ),
                          );
                          return;
                        }
                        VideoPickerSheet.show(
                          context,
                          onImagePicked: (_) {},
                          onVideoPicked: (path) => setState(() => _selectedVideoPath = path),
                        );
                      },
                      failure: (_) {
                        VideoPickerSheet.show(
                          context,
                          onImagePicked: (_) {},
                          onVideoPicked: (path) => setState(() => _selectedVideoPath = path),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.video_library),
                  label: Text(_selectedVideoPath == null ? 'إضافة فيديو' : 'تم اختيار فيديو'),
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
      ),
    );
  }
}
