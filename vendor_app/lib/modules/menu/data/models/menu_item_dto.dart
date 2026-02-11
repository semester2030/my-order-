/// DTO للوجبة — Phase 10 (متوافق مع API_CONTRACT).
class MenuItemDto {
  const MenuItemDto({
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
  final String? videoUrl;
  final String? videoThumbnailUrl;
  final bool isAvailable;
  final String? category;

  factory MenuItemDto.fromJson(Map<String, dynamic> json) {
    return MenuItemDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] as String?,
      videoUrl: json['videoUrl'] as String?,
      videoThumbnailUrl: json['videoThumbnailUrl'] as String?,
      isAvailable: _toBool(json['isAvailable'] ?? json['is_available']),
      category: json['category'] as String?,
    );
  }

  static bool _toBool(dynamic value) {
    if (value == null) return true;
    if (value is bool) return value;
    if (value is String) return value.toLowerCase() == 'true' || value == '1';
    return true;
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
      'videoThumbnailUrl': videoThumbnailUrl,
      'isAvailable': isAvailable,
      'category': category,
    };
  }
}
