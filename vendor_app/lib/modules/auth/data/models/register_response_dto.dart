/// Response DTO for POST /vendors/register (201).
/// Aligned with API contract: vendorId, status, message.
class RegisterResponseDto {
  const RegisterResponseDto({
    required this.vendorId,
    this.status,
    this.message,
  });

  final String vendorId;
  final String? status;
  final String? message;

  factory RegisterResponseDto.fromJson(Map<String, dynamic> json) {
    return RegisterResponseDto(
      vendorId: json['vendorId'] as String? ?? '',
      status: json['status'] as String?,
      message: json['message'] as String?,
    );
  }
}
