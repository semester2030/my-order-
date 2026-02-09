import '../../data/models/job_offer_dto.dart';
import '../../data/models/active_job_dto.dart';
import '../../data/models/accept_job_dto.dart';
import '../../data/models/delivery_history_dto.dart';

/// Jobs Repository
abstract class JobsRepository {
  Future<List<JobOfferDto>> getInbox();
  Future<ActiveJobDto?> getActiveJob();
  Future<DeliveryHistoryDto> getDeliveryHistory();
  Future<Map<String, dynamic>> acceptJob(AcceptJobDto dto);
  Future<Map<String, dynamic>> rejectJob(String jobOfferId);
}
