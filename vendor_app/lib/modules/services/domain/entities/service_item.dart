import 'package:equatable/equatable.dart';

/// خدمة "ما أقدمه للزبائن" — Phase 11.
class ServiceItem with EquatableMixin {
  const ServiceItem({
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

  @override
  List<Object?> get props => [id, name, description, price, imageUrl, isActive, category];
}
