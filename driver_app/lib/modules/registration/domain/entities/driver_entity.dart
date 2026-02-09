import '../../../shared/enums/driver_status.dart';

/// Driver Entity
class DriverEntity {
  final String id;
  final String userId;
  final String fullName;
  final String nationalId;
  final DriverStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  DriverEntity({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.nationalId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DriverEntity.fromJson(Map<String, dynamic> json) {
    return DriverEntity(
      id: json['id'] as String,
      userId: json['userId'] as String,
      fullName: json['fullName'] as String,
      nationalId: json['nationalId'] as String,
      status: DriverStatus.values.firstWhere(
        (e) => e.name == json['status'] as String,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'fullName': fullName,
        'nationalId': nationalId,
        'status': status.name,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };
}
