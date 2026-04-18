import '../../domain/repositories/service_experience_repo.dart';
import '../datasources/service_experience_remote_ds.dart';

class ServiceExperienceRepositoryImpl implements ServiceExperienceRepository {
  ServiceExperienceRepositoryImpl({required this.remoteDataSource});

  final ServiceExperienceRemoteDataSource remoteDataSource;

  @override
  Future<Map<String, dynamic>> getPublicVendorReviews(
    String vendorId, {
    int page = 1,
    int limit = 20,
  }) {
    return remoteDataSource.getPublicVendorReviews(vendorId, page: page, limit: limit);
  }

  @override
  Future<void> submitReview({
    required String subjectType,
    required String subjectId,
    required int stars,
    String? publicComment,
  }) {
    return remoteDataSource.submitReview(
      subjectType: subjectType,
      subjectId: subjectId,
      stars: stars,
      publicComment: publicComment,
    );
  }

  @override
  Future<void> submitQualityTicket({
    required String subjectType,
    required String subjectId,
    required String category,
    required String privateMessage,
    Map<String, num>? detailScores,
  }) {
    return remoteDataSource.submitQualityTicket(
      subjectType: subjectType,
      subjectId: subjectId,
      category: category,
      privateMessage: privateMessage,
      detailScores: detailScores,
    );
  }
}
