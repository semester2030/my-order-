import '../repositories/jobs_repo.dart';

/// Reject Job Use Case
/// 
/// Handles rejecting a job offer:
/// - Validates job offer ID
/// - Calls repository to reject job
/// - Returns rejection result
class RejectJobUseCase {
  final JobsRepository repository;

  RejectJobUseCase(this.repository);

  /// Execute reject job
  /// 
  /// [jobOfferId] - Job offer ID to reject
  Future<Map<String, dynamic>> call(String jobOfferId) async {
    if (jobOfferId.isEmpty) {
      throw ArgumentError('Job offer ID is required');
    }
    return await repository.rejectJob(jobOfferId);
  }
}
