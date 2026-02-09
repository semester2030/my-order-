/// Job Status Enum
/// 
/// Represents the status of a job offer or active job
enum JobStatus {
  pending('pending', 'Pending'),
  accepted('accepted', 'Accepted'),
  rejected('rejected', 'Rejected'),
  expired('expired', 'Expired'),
  cancelled('cancelled', 'Cancelled');

  final String value;
  final String displayName;

  const JobStatus(this.value, this.displayName);

  /// Get status from string value
  static JobStatus? fromString(String value) {
    try {
      return JobStatus.values.firstWhere((e) => e.value == value);
    } catch (e) {
      return null;
    }
  }

  /// Check if status is active (pending or accepted)
  bool get isActive => this == pending || this == accepted;

  /// Check if status is completed (rejected, expired, or cancelled)
  bool get isCompleted => this == rejected || this == expired || this == cancelled;
}
