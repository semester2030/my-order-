import 'package:equatable/equatable.dart';

class MenuItem extends Equatable {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? image;
  final bool isSignature;
  final bool isAvailable;

  const MenuItem({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.image,
    required this.isSignature,
    required this.isAvailable,
  });

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
