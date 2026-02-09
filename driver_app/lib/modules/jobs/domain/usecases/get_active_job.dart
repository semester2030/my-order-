import '../repositories/jobs_repo.dart';
import '../../data/models/active_job_dto.dart';

/// Get Active Job Use Case
/// 
/// Handles fetching active job:
/// - Calls repository to get active job
/// - Returns active job or null
class GetActiveJobUseCase {
  final JobsRepository repository;

  GetActiveJobUseCase(this.repository);

  /// Execute get active job
  Future<ActiveJobDto?> call() async {
    return await repository.getActiveJob();
  }
}
