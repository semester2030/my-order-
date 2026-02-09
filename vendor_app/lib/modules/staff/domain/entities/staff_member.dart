import 'package:equatable/equatable.dart';

/// موظف — Phase 13.
class StaffMember with EquatableMixin {
  const StaffMember({
    required this.id,
    required this.name,
    this.role,
    this.email,
    this.phone,
    this.isActive = true,
  });

  final String id;
  final String name;
  final String? role;
  final String? email;
  final String? phone;
  final bool isActive;

  @override
  List<Object?> get props => [id, name, role, email, phone, isActive];
}
