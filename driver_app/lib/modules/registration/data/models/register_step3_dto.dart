/// Register Driver Step 3 DTO
class RegisterStep3Dto {
  // Insurance
  final String insuranceCompany;
  final String insurancePolicyNumber;
  final String insuranceStartDate;
  final String insuranceExpiryDate;
  final String insuranceCoverageType;
  final String insurancePhoto;

  // Banking
  final String bankName;
  final String accountNumber;
  final String accountHolderName;
  final String? iban;
  final String? swiftCode;

  // Optional: Health
  final bool? hasMedicalConditions;
  final List<String>? medicalConditions;
  final String? bloodType;
  final List<String>? allergies;

  // Optional: Additional
  final String? profilePhoto;
  final List<String>? languages;
  final int? experienceYears;

  RegisterStep3Dto({
    required this.insuranceCompany,
    required this.insurancePolicyNumber,
    required this.insuranceStartDate,
    required this.insuranceExpiryDate,
    required this.insuranceCoverageType,
    required this.insurancePhoto,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolderName,
    this.iban,
    this.swiftCode,
    this.hasMedicalConditions,
    this.medicalConditions,
    this.bloodType,
    this.allergies,
    this.profilePhoto,
    this.languages,
    this.experienceYears,
  });

  Map<String, dynamic> toJson() => {
        'insuranceCompany': insuranceCompany,
        'insurancePolicyNumber': insurancePolicyNumber,
        'insuranceStartDate': insuranceStartDate,
        'insuranceExpiryDate': insuranceExpiryDate,
        'insuranceCoverageType': insuranceCoverageType,
        'insurancePhoto': insurancePhoto,
        'bankName': bankName,
        'accountNumber': accountNumber,
        'accountHolderName': accountHolderName,
        if (iban != null) 'iban': iban,
        if (swiftCode != null) 'swiftCode': swiftCode,
        if (hasMedicalConditions != null)
          'hasMedicalConditions': hasMedicalConditions,
        if (medicalConditions != null) 'medicalConditions': medicalConditions,
        if (bloodType != null) 'bloodType': bloodType,
        if (allergies != null) 'allergies': allergies,
        if (profilePhoto != null) 'profilePhoto': profilePhoto,
        if (languages != null) 'languages': languages,
        if (experienceYears != null) 'experienceYears': experienceYears,
      };
}
