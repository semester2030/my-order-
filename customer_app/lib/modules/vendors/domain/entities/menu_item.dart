import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double? price;
  /// صورة الوجبة فقط — الفيديو الإعلاني في شاشة الاستريمنغ منفصل.
  final String? image;
  final bool isSignature;
  final bool isAvailable;

  const MenuItem({
    required this.id,
    required this.name,
    this.description,
    this.price,
    this.image,
    required this.isSignature,
    required this.isAvailable,
  });

  String? get dishPhotoUrl {
    final url = image?.trim();
    if (url == null || url.isEmpty) return null;
    return url;
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        image,
        isSignature,
        isAvailable,
      ];
}
