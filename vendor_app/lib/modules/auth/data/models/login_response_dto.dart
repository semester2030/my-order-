/// Response DTO for POST /auth/vendor/login.
/// Aligned with API contract: accessToken, refreshToken, expiresIn.
class LoginResponseDto {
  const LoginResponseDto({
    required this.accessToken,
    required this.refreshToken,
    this.expiresIn,
  });

  final String accessToken;
  final String refreshToken;
  /// Token expiry in seconds (optional).
  final int? expiresIn;

  factory LoginResponseDto.fromJson(Map<String, dynamic> json) {
    return LoginResponseDto(
      accessToken: json['accessToken'] as String? ?? '',
      refreshToken: json['refreshToken'] as String? ?? '',
      expiresIn: json['expiresIn'] as int?,
    );
  }
}
