import 'package:equatable/equatable.dart';

class VideoAsset extends Equatable {
  final String id;
  final String playbackUrl;
  final String? thumbnailUrl;
  final int duration; // in seconds

  const VideoAsset({
    required this.id,
    required this.playbackUrl,
    this.thumbnailUrl,
    required this.duration,
  });

  @override
  List<Object?> get props => [id, playbackUrl, thumbnailUrl, duration];
}
