import 'package:equatable/equatable.dart';

/// وجبة في القائمة — Phase 10.
class MenuItem with EquatableMixin {
  const MenuItem({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.videoUrl,
    this.videoThumbnailUrl,
    this.isAvailable = true,
    this.category,
  });

  final String id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  /// رابط الفيديو (مثل الويب).
  final String? videoUrl;
  /// رابط صورة مصغرة للفيديو (من الباك اند videoAssets.thumbnailUrl).
  final String? videoThumbnailUrl;
  final bool isAvailable;
  final String? category;

  @override
  List<Object?> get props => [id, name, description, price, imageUrl, videoUrl, videoThumbnailUrl, isAvailable, category];
}
