/// Job Status Enum
enum JobStatus {
  pending,
  accepted,
  rejected,
  expired,
  cancelled,
}

extension JobStatusExtension on JobStatus {
  String get displayName {
    switch (this) {
      case JobStatus.pending:
        return 'Pending';
      case JobStatus.accepted:
        return 'Accepted';
      case JobStatus.rejected:
        return 'Rejected';
      case JobStatus.expired:
        return 'Expired';
      case JobStatus.cancelled:
        return 'Cancelled';
    }
  }
}
