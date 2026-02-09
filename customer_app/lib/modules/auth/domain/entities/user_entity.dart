import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String? phone;
  final String? name;
  final String? email;
  final bool isVerified;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    this.phone,
    this.name,
    this.email,
    required this.isVerified,
    required this.createdAt,
  });

  /// Login identifier: phone or email (for OTP/PIN flow).
  String get loginIdentifier => phone ?? email ?? '';

  @override
  List<Object?> get props => [id, phone, name, email, isVerified, createdAt];
}
