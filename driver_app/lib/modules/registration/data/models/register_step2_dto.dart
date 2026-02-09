import '../../../shared/enums/license_type.dart';
import '../../../shared/enums/vehicle_type.dart';

/// Register Driver Step 2 DTO
class RegisterStep2Dto {
  // Personal Identity
  final String fullName;
  final String dateOfBirth;
  final String gender;
  final String nationality;

  // Driver License
  final String licenseNumber;
  final LicenseType licenseType;
  final String licenseIssueDate;
  final String licenseExpiryDate;
  final String licenseIssuingAuthority;
  final String licensePhotoFront;
  final String licensePhotoBack;

  // Vehicle Information
  final VehicleType vehicleType;
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleYear;
  final String vehicleColor;
  final String plateNumber;
  final String plateRegion;
  final String vehicleRegistrationNumber;
  final String vehicleRegistrationExpiry;
  final String vehiclePhoto;
  final String? vehicleAuthorizationPhoto;

  // Contact
  final String? email;
  final String emergencyContactName;
  final String emergencyContactPhone;
  final Address address;

  // Legal Consents
  final bool termsAndConditionsAccepted;
  final bool privacyPolicyAccepted;
  final bool backgroundCheckConsent;
  final bool locationTrackingConsent;
  final bool dataProcessingConsent;

  RegisterStep2Dto({
    required this.fullName,
    required this.dateOfBirth,
    required this.gender,
    required this.nationality,
    required this.licenseNumber,
    required this.licenseType,
    required this.licenseIssueDate,
    required this.licenseExpiryDate,
    required this.licenseIssuingAuthority,
    required this.licensePhotoFront,
    required this.licensePhotoBack,
    required this.vehicleType,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleYear,
    required this.vehicleColor,
    required this.plateNumber,
    required this.plateRegion,
    required this.vehicleRegistrationNumber,
    required this.vehicleRegistrationExpiry,
    required this.vehiclePhoto,
    this.vehicleAuthorizationPhoto,
    this.email,
    required this.emergencyContactName,
    required this.emergencyContactPhone,
    required this.address,
    required this.termsAndConditionsAccepted,
    required this.privacyPolicyAccepted,
    required this.backgroundCheckConsent,
    required this.locationTrackingConsent,
    required this.dataProcessingConsent,
  });

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'dateOfBirth': dateOfBirth,
        'gender': gender,
        'nationality': nationality,
        'licenseNumber': licenseNumber,
        'licenseType': licenseType.name,
        'licenseIssueDate': licenseIssueDate,
        'licenseExpiryDate': licenseExpiryDate,
        'licenseIssuingAuthority': licenseIssuingAuthority,
        'licensePhotoFront': licensePhotoFront,
        'licensePhotoBack': licensePhotoBack,
        'vehicleType': vehicleType.name,
        'vehicleMake': vehicleMake,
        'vehicleModel': vehicleModel,
        'vehicleYear': vehicleYear,
        'vehicleColor': vehicleColor,
        'plateNumber': plateNumber,
        'plateRegion': plateRegion,
        'vehicleRegistrationNumber': vehicleRegistrationNumber,
        'vehicleRegistrationExpiry': vehicleRegistrationExpiry,
        'vehiclePhoto': vehiclePhoto,
        if (vehicleAuthorizationPhoto != null)
          'vehicleAuthorizationPhoto': vehicleAuthorizationPhoto,
        if (email != null) 'email': email,
        'emergencyContactName': emergencyContactName,
        'emergencyContactPhone': emergencyContactPhone,
        'address': {
          'street': address.street,
          'city': address.city,
          'region': address.region,
          if (address.postalCode != null) 'postalCode': address.postalCode,
        },
        'termsAndConditionsAccepted': termsAndConditionsAccepted,
        'privacyPolicyAccepted': privacyPolicyAccepted,
        'backgroundCheckConsent': backgroundCheckConsent,
        'locationTrackingConsent': locationTrackingConsent,
        'dataProcessingConsent': dataProcessingConsent,
      };
}

/// Address model
class Address {
  final String street;
  final String city;
  final String region;
  final String? postalCode;

  Address({
    required this.street,
    required this.city,
    required this.region,
    this.postalCode,
  });
}
