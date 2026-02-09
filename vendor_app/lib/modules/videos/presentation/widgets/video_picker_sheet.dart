import 'package:flutter/material.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/media/image_picker_service.dart';

/// Bottom sheet لاختيار صورة أو فيديو من المعرض/الكاميرا — Phase 15.
class VideoPickerSheet extends StatelessWidget {
  const VideoPickerSheet({
    super.key,
    required this.onImagePicked,
    this.onVideoPicked,
    this.uploadAfterPick = false,
  });

  /// Callback عند اختيار صورة: مسار الملف المحلي (أو الرابط بعد الرفع إن كان uploadAfterPick).
  final void Function(String path) onImagePicked;

  /// Callback عند اختيار فيديو (اختياري).
  final void Function(String path)? onVideoPicked;

  /// إن true، يرفع الملف بعد الاختيار ويُرجع الرابط (يتطلب ربط VideosRepo/FileUploader لاحقاً).
  final bool uploadAfterPick;

  static Future<void> show(
    BuildContext context, {
    required void Function(String path) onImagePicked,
    void Function(String path)? onVideoPicked,
    bool uploadAfterPick = false,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.topLG),
      builder: (ctx) => VideoPickerSheet(
        onImagePicked: onImagePicked,
        onVideoPicked: onVideoPicked,
        uploadAfterPick: uploadAfterPick,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final picker = ImagePickerService();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(Insets.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'اختر صورة أو فيديو',
              style: TextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.lgV,
            ListTile(
              leading: Icon(Icons.photo_library, color: AppColors.primary, size: IconSizes.lg),
              title: Text(
                'صورة من المعرض',
                style: TextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                final file = await picker.pickImageFromGallery();
                if (file != null && context.mounted) {
                  onImagePicked(file.path);
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppColors.primary, size: IconSizes.lg),
              title: Text(
                'صورة من الكاميرا',
                style: TextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
              ),
              onTap: () async {
                Navigator.of(context).pop();
                final file = await picker.pickImageFromCamera();
                if (file != null && context.mounted) {
                  onImagePicked(file.path);
                }
              },
            ),
            if (onVideoPicked != null) ...[
              ListTile(
                leading: Icon(Icons.video_library, color: AppColors.primary, size: IconSizes.lg),
                title: Text(
                  'فيديو من المعرض',
                  style: TextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  final file = await picker.pickVideoFromGallery();
                  if (file != null && context.mounted) {
                    onVideoPicked!(file.path);
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.videocam, color: AppColors.primary, size: IconSizes.lg),
                title: Text(
                  'تسجيل فيديو',
                  style: TextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
                ),
                onTap: () async {
                  Navigator.of(context).pop();
                  final file = await picker.pickVideoFromCamera();
                  if (file != null && context.mounted) {
                    onVideoPicked!(file.path);
                  }
                },
              ),
            ],
            Gaps.mdV,
          ],
        ),
      ),
    );
  }
}
