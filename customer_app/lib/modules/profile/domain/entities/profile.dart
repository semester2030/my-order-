import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String id;
  final String? phone;
  final String? name;
  final String? email;
  final bool isVerified;
  final DateTime createdAt;

  const Profile({
    required this.id,
    this.phone,
    this.name,
    this.email,
    required this.isVerified,
    required this.createdAt,
  });

  /// Phone or email for display (login identifier).
  String get contact => phone ?? email ?? '';

  @override
  List<Object?> get props => [id, phone, name, email, isVerified, createdAt];
}
