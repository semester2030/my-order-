/// OTP Verify DTO
class OtpVerifyDto {
  final String phone;
  final String code;

  OtpVerifyDto({required this.phone, required this.code});

  Map<String, dynamic> toJson() => {
        'phone': phone,
        'code': code,
      };
}
