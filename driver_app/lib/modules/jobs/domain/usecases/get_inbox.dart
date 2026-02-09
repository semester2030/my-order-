import '../repositories/jobs_repo.dart';
import '../../data/models/job_offer_dto.dart';

/// Get Inbox Use Case
/// 
/// Handles fetching available job offers:
/// - Calls repository to get inbox
/// - Returns list of job offers
class GetInboxUseCase {
  final JobsRepository repository;

  GetInboxUseCase(this.repository);

  /// Execute get inbox
  Future<List<JobOfferDto>> call() async {
    return await repository.getInbox();
  }
}
