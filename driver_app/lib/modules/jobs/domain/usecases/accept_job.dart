import '../repositories/jobs_repo.dart';
import '../../data/models/accept_job_dto.dart';

/// Accept Job Use Case
/// 
/// Handles accepting a job offer:
/// - Validates DTO
/// - Calls repository to accept job
/// - Returns acceptance result
class AcceptJobUseCase {
  final JobsRepository repository;

  AcceptJobUseCase(this.repository);

  /// Execute accept job
  /// 
  /// [dto] - Accept job data
  Future<Map<String, dynamic>> call(AcceptJobDto dto) async {
    if (dto.jobOfferId.isEmpty) {
      throw ArgumentError('Job offer ID is required');
    }
    return await repository.acceptJob(dto);
  }
}
