import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:vendor_app/core/localization/app_localizations.dart';
import 'package:vendor_app/core/theme/design_system.dart';
import 'package:vendor_app/core/utils/result.dart';
import 'package:vendor_app/core/di/providers.dart';
import 'package:vendor_app/modules/videos/data/datasources/videos_remote_ds.dart';

/// حد أقصى 20 مقطع فيديو لكل حساب طباخ — نفس الحجم والإطار والتصميم.
const int kMaxVideosPerVendor = 20;

/// شاشة مقاطع الفيديو — عرض موحد (نفس الحجم والإطار)، حد 20، حذف لتحرير مكان.
class VideosScreen extends ConsumerStatefulWidget {
  const VideosScreen({super.key});

  @override
  ConsumerState<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends ConsumerState<VideosScreen> {
  List<VendorVideoItemDto> _list = [];
  int _count = 0;
  bool _loading = true;
  String? _error;

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    final countResult = await ref.read(videosRepoProvider).getVendorVideoCount();
    final listResult = await ref.read(videosRepoProvider).getVendorVideos();
    if (!mounted) return;
    countResult.when(
      success: (c) => _count = c,
      failure: (f) => _error = f.message,
    );
    listResult.when(
      success: (l) => _list = l,
      failure: (f) {
        if (_error == null) _error = f.message;
      },
    );
    setState(() => _loading = false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _deleteVideo(VendorVideoItemDto item) async {
    final l10n = AppLocalizations.of(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.videosDeleteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(backgroundColor: SemanticColors.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    final result = await ref.read(videosRepoProvider).deleteVideo(item.id);
    if (!mounted) return;
    result.when(
      success: (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.videosDeleted), backgroundColor: AppColors.primary),
        );
        _load();
      },
      failure: (f) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(f.message), backgroundColor: SemanticColors.error),
        );
      },
    );
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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              l10n.videos,
              style: TextStyles.headlineSmall.copyWith(color: AppColors.textPrimary),
            ),
            if (!_loading)
              Text(
                '$_count ${l10n.videosCountOfMax}',
                style: TextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(Insets.lg),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(_error!, textAlign: TextAlign.center),
                        Gaps.mdV,
                        FilledButton(
                          onPressed: _load,
                          child: Text(l10n.retry),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: CustomScrollView(
                    slivers: [
                      if (_count >= kMaxVideosPerVendor)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(Insets.lg, 0, Insets.lg, Insets.sm),
                            child: Text(
                              l10n.videosMaxReached,
                              style: TextStyles.bodyMedium.copyWith(
                                color: SemanticColors.warning,
                              ),
                            ),
                          ),
                        ),
                      SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: Insets.lg),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.85,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = _list[index];
                              return _VideoCard(
                                item: item,
                                onDelete: () => _deleteVideo(item),
                                mealLabel: l10n.videoMealLabel,
                              );
                            },
                            childCount: _list.length,
                          ),
                        ),
                      ),
                      if (_list.isEmpty)
                        SliverFillRemaining(
                          child: Center(
                            child: Text(
                              l10n.noMeals,
                              style: TextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
    );
  }
}

/// بطاقة فيديو واحدة — نفس الحجم والإطار لجميع المقاطع.
class _VideoCard extends StatelessWidget {
  const _VideoCard({
    required this.item,
    required this.onDelete,
    required this.mealLabel,
  });

  final VendorVideoItemDto item;
  final VoidCallback onDelete;
  final String mealLabel;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (item.thumbnailUrl != null && item.thumbnailUrl!.isNotEmpty)
                  Image.network(
                    item.thumbnailUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _placeholder(),
                  )
                else
                  _placeholder(),
                Positioned(
                  top: 4,
                  right: 4,
                  child: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: onDelete,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.black54,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(4),
                      minimumSize: const Size(32, 32),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(Insets.sm),
            child: Text(
              item.menuItemName?.isNotEmpty == true
                  ? item.menuItemName!
                  : '$mealLabel: ${item.menuItemId.substring(0, 8)}...',
              style: TextStyles.bodySmall.copyWith(color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: AppColors.surface,
      child: Icon(Icons.videocam_off, size: 40, color: AppColors.textSecondary),
    );
  }
}
