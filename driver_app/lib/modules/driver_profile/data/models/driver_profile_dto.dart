import '../../../shared/enums/driver_status.dart';
import '../../../shared/enums/license_type.dart';
import '../../../shared/enums/vehicle_type.dart';

/// Driver Profile DTO
class DriverProfileDto {
  final String id;
  final String userId;
  final String fullName;
  final String nationalId;
  final String? phoneNumber;
  final String? email;
  final DriverStatus status;
  final bool isOnline;
  final String? licenseNumber;
  final LicenseType? licenseType;
  final DateTime? licenseExpiryDate;
  final VehicleType? vehicleType;
  final String? plateNumber;
  final String? plateRegion;
  final String? insuranceCompany;
  final DateTime? insuranceExpiryDate;
  final double? currentLatitude;
  final double? currentLongitude;
  final DateTime? lastOnlineAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  DriverProfileDto({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.nationalId,
    this.phoneNumber,
    this.email,
    required this.status,
    required this.isOnline,
    this.licenseNumber,
    this.licenseType,
    this.licenseExpiryDate,
    this.vehicleType,
    this.plateNumber,
    this.plateRegion,
    this.insuranceCompany,
    this.insuranceExpiryDate,
    this.currentLatitude,
    this.currentLongitude,
    this.lastOnlineAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriverProfileDto.fromJson(Map<String, dynamic> json) {
    return DriverProfileDto(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fullName: json['fullName'] as String? ?? '',
      nationalId: json['nationalId'] as String? ?? '',
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      status: DriverStatus.values.firstWhere(
        (e) => e.name == json['status'] as String,
      ),
      isOnline: json['isOnline'] as bool,
      licenseNumber: json['licenseNumber'] as String?,
      licenseType: json['licenseType'] != null
          ? LicenseType.values.firstWhere(
              (e) => e.name == json['licenseType'] as String,
            )
          : null,
      licenseExpiryDate: json['licenseExpiryDate'] != null
          ? DateTime.parse(json['licenseExpiryDate'] as String)
          : null,
      vehicleType: json['vehicleType'] != null
          ? VehicleType.values.firstWhere(
              (e) => e.name == json['vehicleType'] as String,
            )
          : null,
      plateNumber: json['plateNumber'] as String?,
      plateRegion: json['plateRegion'] as String?,
      insuranceCompany: json['insuranceCompany'] as String?,
      insuranceExpiryDate: json['insuranceExpiryDate'] != null
          ? DateTime.parse(json['insuranceExpiryDate'] as String)
          : null,
      currentLatitude: json['currentLatitude'] != null
          ? (json['currentLatitude'] as num).toDouble()
          : null,
      currentLongitude: json['currentLongitude'] != null
          ? (json['currentLongitude'] as num).toDouble()
          : null,
      lastOnlineAt: json['lastOnlineAt'] != null
          ? DateTime.parse(json['lastOnlineAt'] as String)
          : null,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}
