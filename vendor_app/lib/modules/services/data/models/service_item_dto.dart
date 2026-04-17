/// DTO للخدمة — Phase 11 (متوافق مع API_CONTRACT).
class ServiceItemDto {
  const ServiceItemDto({
    required this.id,
    required this.name,
    this.description,
    this.price,
    this.imageUrl,
    this.isActive = true,
    this.category,
  });

  final String id;
  final String name;
  final String? description;
  final double? price;
  final String? imageUrl;
  final bool isActive;
  final String? category;

  factory ServiceItemDto.fromJson(Map<String, dynamic> json) {
    final dynamic img = json['imageUrl'] ?? json['image'];
    final dynamic avail = json['isActive'] ?? json['isAvailable'];
    final bool active = avail is bool
        ? avail
        : avail == true || avail == 'true' || avail == 1;
    return ServiceItemDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      imageUrl: img is String ? img : null,
      isActive: active,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isActive': isActive,
      'category': category,
    };
  }
}
