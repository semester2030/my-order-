/// Driver Status Enum
enum DriverStatus {
  pending,
  underReview,
  approved,
  rejected,
  suspended,
  inactive,
}

extension DriverStatusExtension on DriverStatus {
  String get displayName {
    switch (this) {
      case DriverStatus.pending:
        return 'Pending';
      case DriverStatus.underReview:
        return 'Under Review';
      case DriverStatus.approved:
        return 'Approved';
      case DriverStatus.rejected:
        return 'Rejected';
      case DriverStatus.suspended:
        return 'Suspended';
      case DriverStatus.inactive:
        return 'Inactive';
    }
  }
}
