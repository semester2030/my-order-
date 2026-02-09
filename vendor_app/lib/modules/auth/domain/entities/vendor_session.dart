import 'package:equatable/equatable.dart';

/// Domain entity: vendor session after successful login.
/// Holds access token, refresh token, and optional expiry/user id.
class VendorSession with EquatableMixin {
  const VendorSession({
    required this.accessToken,
    required this.refreshToken,
    this.expiresAt,
    this.userId,
  });

  final String accessToken;
  final String refreshToken;
  final DateTime? expiresAt;
  final String? userId;

  @override
  List<Object?> get props => [accessToken, refreshToken, expiresAt, userId];
}
