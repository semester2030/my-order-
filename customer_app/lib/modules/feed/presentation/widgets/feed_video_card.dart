import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../../core/theme/design_system.dart';
import '../../../../core/video/video_controller_pool.dart';
import '../../domain/entities/feed_item.dart';
import 'dish_overlay.dart';
import 'feed_video_side_actions.dart';

class FeedVideoCard extends StatefulWidget {
  final FeedItem item;
  final bool isPlaying;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  /// إن كانت الطباخة تقبل "خدمات عند الطلب" (من الـ Backend لاحقاً).
  final bool acceptsCustomRequests;

  const FeedVideoCard({
    super.key,
    required this.item,
    this.isPlaying = false,
    this.onTap,
    this.onAddToCart,
    this.acceptsCustomRequests = true,
  });

  @override
  State<FeedVideoCard> createState() => _FeedVideoCardState();
}

class _FeedVideoCardState extends State<FeedVideoCard> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    if (widget.item.video != null) {
      _initializeVideo();
    }
  }

  Future<void> _initializeVideo() async {
    if (widget.item.video == null) return;

    try {
      final controller = await VideoControllerPool.getController(
        widget.item.video!.playbackUrl,
      );

      if (controller != null && mounted) {
        setState(() {
          _controller = controller;
          _isInitialized = true;
        });

        if (widget.isPlaying) {
          _controller?.play();
        }
      }
    } catch (e) {
      // Error handled by showing placeholder
    }
  }

  @override
  void didUpdateWidget(FeedVideoCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying && _isInitialized) {
        _controller?.play();
      } else {
        _controller?.pause();
      }
    }
  }

  @override
  void dispose() {
    // Don't dispose here, let pool manage it
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        color: AppColors.videoBackground,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Video player or thumbnail
            if (_isInitialized && _controller != null)
              _buildVideoPlayer()
            else if (widget.item.video?.thumbnailUrl != null)
              _buildThumbnail()
            else
              _buildPlaceholder(),

            // Overlay gradient
            _buildOverlay(),

            // Content overlay (bottom: chef + dish, price, عرض الطباخ + أضف للسلة)
            DishOverlay(
              item: widget.item,
              onAddToCart: widget.onAddToCart,
              acceptsCustomRequests: widget.acceptsCustomRequests,
            ),
            // TikTok-style right side: وجبات جاهزة + خدمات عند الطلب
            FeedVideoSideActions(
              item: widget.item,
              acceptsCustomRequests: widget.acceptsCustomRequests,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (_controller == null) return _buildPlaceholder();

    return AspectRatio(
      aspectRatio: _controller!.value.aspectRatio,
      child: VideoPlayer(_controller!),
    );
  }

  Widget _buildThumbnail() {
    return Image.network(
      widget.item.video!.thumbnailUrl!,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: AppColors.secondary,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.restaurant,
              size: 64,
              color: AppColors.textTertiary,
            ),
            Gaps.mdV,
            Text(
              widget.item.menuItem.name,
              style: TextStyles.headlineMedium.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverlay() {
    return Container(
      decoration: const BoxDecoration(
        gradient: GradientColors.videoOverlayGradient,
      ),
    );
  }
}
