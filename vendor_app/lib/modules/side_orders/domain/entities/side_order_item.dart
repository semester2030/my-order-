import 'package:equatable/equatable.dart';

/// عنصر طلب جانبي (إضافة للطبخ الشعبي: جريش، قرصان، إدامات…) — Phase 12.
class SideOrderItem with EquatableMixin {
  const SideOrderItem({
    required this.id,
    required this.name,
    required this.price,
  });

  final String id;
  final String name;
  final double price;

  @override
  List<Object?> get props => [id, name, price];
}
