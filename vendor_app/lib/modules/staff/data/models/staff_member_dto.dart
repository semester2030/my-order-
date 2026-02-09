/// DTO للموظف — Phase 13 (متوافق مع API_CONTRACT).
class StaffMemberDto {
  const StaffMemberDto({
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

  factory StaffMemberDto.fromJson(Map<String, dynamic> json) {
    return StaffMemberDto(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      role: json['role'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'role': role,
      'email': email,
      'phone': phone,
      'isActive': isActive,
    };
  }
}
