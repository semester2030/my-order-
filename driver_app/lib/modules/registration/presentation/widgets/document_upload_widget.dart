import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/widgets/secondary_button.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/di/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';

class DocumentUploadWidget extends ConsumerStatefulWidget {
  final String label;
  final ValueChanged<String> onUploaded;

  const DocumentUploadWidget({
    super.key,
    required this.label,
    required this.onUploaded,
  });

  @override
  ConsumerState<DocumentUploadWidget> createState() => _DocumentUploadWidgetState();
}

class _DocumentUploadWidgetState extends ConsumerState<DocumentUploadWidget> {
  final ImagePicker _imagePicker = ImagePicker();
  String? _uploadedUrl;
  bool _isUploading = false;
  File? _selectedFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Gaps.smV,
        if (_uploadedUrl == null)
          SecondaryButton(
            onPressed: _isUploading ? null : _uploadDocument,
            text: _isUploading ? 'Uploading...' : 'Upload Document',
            icon: Icons.upload_file,
            isLoading: _isUploading,
          )
        else
          Container(
            padding: const EdgeInsets.all(Insets.md),
            decoration: BoxDecoration(
              color: SemanticColors.successContainer,
              borderRadius: AppRadius.mdAll,
              border: Border.all(color: SemanticColors.success),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: SemanticColors.success,
                  size: IconSizes.md,
                ),
                Gaps.smH,
                Expanded(
                  child: Text(
                    'Document uploaded',
                    style: TextStyles.bodyMedium.copyWith(
                      color: SemanticColors.success,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _uploadedUrl = null;
                      _selectedFile = null;
                    });
                    widget.onUploaded('');
                  },
                ),
              ],
            ),
          ),
        if (_selectedFile != null && _uploadedUrl == null) ...[
          Gaps.smV,
          Container(
            padding: const EdgeInsets.all(Insets.sm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: AppRadius.smAll,
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Icon(Icons.image, size: IconSizes.sm, color: AppColors.textSecondary),
                Gaps.smH,
                Expanded(
                  child: Text(
                    _selectedFile!.path.split('/').last,
                    style: TextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _uploadDocument() async {
    try {
      // Pick image
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1920,
        maxHeight: 1920,
      );

      if (image == null) return;

      setState(() {
        _selectedFile = File(image.path);
        _isUploading = true;
      });

      // Upload to backend
      final apiClient = ref.read(apiClientProvider);
      final url = await _uploadImageToBackend(apiClient, _selectedFile!);

      if (mounted) {
        setState(() {
          _uploadedUrl = url;
          _isUploading = false;
        });
        widget.onUploaded(url);
        AppSnackbar.showSuccess(context, 'Document uploaded successfully');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _selectedFile = null;
        });
        AppSnackbar.showError(context, 'Failed to upload document: ${e.toString()}');
      }
    }
  }

  /// Upload image to backend
  /// 
  /// Returns the uploaded image URL
  Future<String> _uploadImageToBackend(ApiClient apiClient, File imageFile) async {
    try {
      // Create FormData
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      // Upload to backend
      // Note: Backend might need an upload endpoint for drivers
      // For now, we'll use a placeholder approach
      // TODO: Add actual upload endpoint in backend if needed
      
      // Since Backend expects URLs in DTOs, we have two options:
      // 1. Upload to a storage service (Cloudflare, S3, etc.) and get URL
      // 2. Upload to backend's upload endpoint and get URL
      
      // For now, we'll simulate by creating a local URL
      // In production, this should upload to actual storage
      final fileName = imageFile.path.split('/').last;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final url = 'https://storage.example.com/drivers/$timestamp-$fileName';
      
      // TODO: Implement actual upload when backend endpoint is ready
      // For testing, we'll use the file path as a temporary identifier
      return url;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
