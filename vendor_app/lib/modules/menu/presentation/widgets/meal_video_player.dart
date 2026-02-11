import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'package:vendor_app/core/theme/design_system.dart';

/// نافذة تشغيل فيديو الوجبة — تظهر فوق الشاشة وتُغلق بزر.
class MealVideoPlayer extends StatefulWidget {
  const MealVideoPlayer({
    super.key,
    required this.videoUrl,
    this.mealName,
  });

  final String videoUrl;
  final String? mealName;

  @override
  State<MealVideoPlayer> createState() => _MealVideoPlayerState();
}

class _MealVideoPlayerState extends State<MealVideoPlayer> {
  late VideoPlayerController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _controller.initialize().then((_) {
      if (mounted) {
        setState(() {});
        _controller.play();
      }
    }).catchError((e) {
      if (mounted) setState(() => _error = e.toString());
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: _error != null
                  ? Padding(
                      padding: EdgeInsets.all(Insets.lg),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: AppColors.textTertiary),
                          Gaps.mdV,
                          Text(
                            'لا يمكن تشغيل الفيديو',
                            style: TextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    )
                  : _controller.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: _controller.value.aspectRatio,
                          child: VideoPlayer(_controller),
                        )
                      : const Center(child: CircularProgressIndicator()),
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            if (widget.mealName != null && widget.mealName!.isNotEmpty)
              Positioned(
                bottom: 16,
                left: 16,
                right: 60,
                child: Text(
                  widget.mealName!,
                  style: TextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
