/// OTP Request DTO
class OtpRequestDto {
  final String phone;

  OtpRequestDto({required this.phone});

  Map<String, dynamic> toJson() => {
        'phone': phone,
      };
}
