import '../../domain/repositories/jobs_repo.dart';
import '../../data/models/job_offer_dto.dart';
import '../../data/models/active_job_dto.dart';
import '../../data/models/accept_job_dto.dart';
import '../../data/models/delivery_history_dto.dart';
import '../datasources/jobs_remote_ds.dart';

/// Jobs Repository Implementation
class JobsRepositoryImpl implements JobsRepository {
  final JobsRemoteDataSource remoteDataSource;

  JobsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<JobOfferDto>> getInbox() async {
    return await remoteDataSource.getInbox();
  }

  @override
  Future<ActiveJobDto?> getActiveJob() async {
    return await remoteDataSource.getActiveJob();
  }

  @override
  Future<DeliveryHistoryDto> getDeliveryHistory() async {
    return await remoteDataSource.getDeliveryHistory();
  }

  @override
  Future<Map<String, dynamic>> acceptJob(AcceptJobDto dto) async {
    return await remoteDataSource.acceptJob(dto);
  }

  @override
  Future<Map<String, dynamic>> rejectJob(String jobOfferId) async {
    return await remoteDataSource.rejectJob(jobOfferId);
  }
}
