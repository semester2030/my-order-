/// Register Driver Step 1 DTO
class RegisterStep1Dto {
  final String nationalId;
  final String phoneNumber;

  RegisterStep1Dto({
    required this.nationalId,
    required this.phoneNumber,
  });

  Map<String, dynamic> toJson() => {
        'nationalId': nationalId,
        'phoneNumber': phoneNumber,
      };
}
