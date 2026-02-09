/// User Entity
class UserEntity {
  final String id;
  final String phone;
  final String? name;
  final String? email;
  final bool isVerified;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.phone,
    this.name,
    this.email,
    required this.isVerified,
    required this.createdAt,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.phone == phone &&
        other.name == name &&
        other.email == email &&
        other.isVerified == isVerified;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        phone.hashCode ^
        name.hashCode ^
        email.hashCode ^
        isVerified.hashCode;
  }
}
