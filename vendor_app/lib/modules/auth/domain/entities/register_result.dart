import 'package:equatable/equatable.dart';

/// Domain result of vendor registration (vendorId, status, message).
class RegisterResult with EquatableMixin {
  const RegisterResult({
    required this.vendorId,
    this.status,
    this.message,
  });

  final String vendorId;
  final String? status;
  final String? message;

  @override
  List<Object?> get props => [vendorId, status, message];
}
