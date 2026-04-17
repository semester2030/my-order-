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
import 'package:vendor_app/core/routing/route_names.dart';
import 'package:vendor_app/core/widgets/loading_view.dart';
import 'package:vendor_app/modules/menu/domain/entities/menu_item.dart';
import 'package:vendor_app/modules/videos/presentation/widgets/video_picker_sheet.dart';
import 'package:vendor_app/modules/videos/presentation/screens/videos_screen.dart';
import 'package:vendor_app/modules/menu/presentation/providers/menu_state.dart';
import 'package:vendor_app/modules/menu/presentation/utils/vendor_terms_precheck.dart';
import 'package:vendor_app/modules/profile/presentation/providers/profile_state.dart';

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
  bool _checkingMenuOfferingTerms = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureMenuOfferingTerms());
  }

  Future<void> _ensureMenuOfferingTerms() async {
    final pre = await precheckVendorCombinedTerms(ref);
    if (!mounted) return;
    if (pre.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(pre.errorMessage!),
          backgroundColor: SemanticColors.error,
        ),
      );
      context.pop();
      return;
    }
    if (pre.allComplete) {
      setState(() => _checkingMenuOfferingTerms = false);
      return;
    }
    final ok = await context.push<bool>(RouteNames.menuOfferingTerms);
    if (!mounted) return;
    if (ok == true) {
      setState(() => _checkingMenuOfferingTerms = false);
    } else {
      context.pop();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final isHomeCooking =
        ref.read(profileNotifierProvider).isHomeCookingCategory;

    if (isHomeCooking) {
      if (_descriptionController.text.trim().length < 3) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('الوصف إلزامي لمطبخ منزلي (ثلاثة أحرف على الأقل)'),
              backgroundColor: SemanticColors.error,
            ),
          );
        }
        return;
      }
      if (_selectedImagePath == null || _selectedImagePath!.trim().isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('صورة الطبق إلزامية لمطبخ منزلي'),
              backgroundColor: SemanticColors.error,
            ),
          );
        }
        return;
      }
    }

    if (_selectedVideoPath == null || _selectedVideoPath!.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('الفيديو مطلوب لإضافة وجبة'),
            backgroundColor: SemanticColors.error,
          ),
        );
      }
      return;
    }

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

    final priceRaw = _priceController.text.trim();
    final double? price = isHomeCooking && priceRaw.isEmpty
        ? null
        : (double.tryParse(priceRaw) ?? (isHomeCooking ? null : 0.0));
    if (!isHomeCooking && (price == null || price < 0.01)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('أدخل سعراً صالحاً (0.01 على الأقل)'),
            backgroundColor: SemanticColors.error,
          ),
        );
      }
      return;
    }
    if (isHomeCooking && priceRaw.isNotEmpty && (price == null || price < 0)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('أدخل سعراً صالحاً أو اترك الحقل فارغاً للتفاوض'),
            backgroundColor: SemanticColors.error,
          ),
        );
      }
      return;
    }
    final item = MenuItem(
      id: '',
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      price: price,
      imageUrl: imageUrl,
      videoUrl: null, // الفيديو يُرفع بعد إنشاء الصنف
      isAvailable: true,
      category: null,
    );

    // 1) إنشاء الصنف أولاً (الباك اند يحفظ الفيديو في video_assets منفصل)
    final createdItem = await ref.read(menuNotifierProvider.notifier).addItemAndReturnCreated(item);
    if (!mounted) return;
    if (createdItem == null) return; // فشل الإنشاء أو حدث خطأ

    // 2) رفع الفيديو للصنف المُنشأ (إن وُجد)
    final videoPath = _selectedVideoPath != null && !_selectedVideoPath!.startsWith('http')
        ? _selectedVideoPath!
        : null;
    if (videoPath != null) {
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
      try {
        final videoResult = await ref.read(videosRepoProvider).uploadVideoForMenuItem(
              createdItem.id,
              videoPath,
              onProgress: (sent, total) {
                progress.value = total > 0 ? sent / total : 0.0;
              },
            );
        if (mounted) Navigator.of(context).pop();
        if (videoResult.isFailure && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(videoResult.errorOrNull?.message ?? 'فشل رفع الفيديو'),
              backgroundColor: SemanticColors.error,
              duration: const Duration(seconds: 5),
            ),
          );
        } else if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم رفع الفيديو بنجاح'), backgroundColor: Colors.green),
          );
        }
      } catch (e) {
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('خطأ في رفع الفيديو: ${e.toString()}'),
              backgroundColor: SemanticColors.error,
              duration: const Duration(seconds: 6),
            ),
          );
        }
      }
    }

    ref.read(menuNotifierProvider.notifier).refresh();
    if (mounted) context.pop();
  }

  bool get _saving {
    final state = ref.watch(menuNotifierProvider);
    return state is MenuSaving;
  }

  @override
  Widget build(BuildContext context) {
    if (_checkingMenuOfferingTerms) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          title: Text(
            AppLocalizations.of(context).addMeal,
            style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
          ),
        ),
        body: const Center(child: LoadingView()),
      );
    }

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
                  validator: (v) {
                    final isHome =
                        ref.read(profileNotifierProvider).isHomeCookingCategory;
                    if (isHome && (v == null || v.trim().length < 3)) {
                      return 'الوصف إلزامي لمطبخ منزلي (٣ أحرف على الأقل)';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'الوصف',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                    filled: true,
                    fillColor: AppColors.surface,
                  ),
                ),
                Gaps.mdV,
                Builder(
                  builder: (context) {
                    final isHome =
                        ref.watch(profileNotifierProvider).isHomeCookingCategory;
                    return AppTextField(
                      controller: _priceController,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (isHome) {
                          if (v == null || v.trim().isEmpty) return null;
                          final n = double.tryParse(v.trim());
                          if (n == null || n < 0) return 'أدخل سعراً صالحاً أو اترك الحقل فارغاً';
                          return null;
                        }
                        if (v == null || v.trim().isEmpty) return 'السعر مطلوب';
                        final n = double.tryParse(v.trim());
                        if (n == null || n < 0.01) return 'أدخل سعراً صالحاً (0.01 على الأقل)';
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: isHome ? 'السعر (ر.س) — اختياري' : 'السعر (ر.س)',
                        helperText: isHome ? 'اتركه فارغاً إذا رغبت بالتفاوض عند الطلب' : null,
                        border: OutlineInputBorder(borderRadius: AppRadius.mdAll),
                        filled: true,
                        fillColor: AppColors.surface,
                      ),
                    );
                  },
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
