abstract class ServiceExperienceRepository {
  Future<Map<String, dynamic>> getPublicVendorReviews(
    String vendorId, {
    int page = 1,
    int limit = 20,
  });

  Future<void> submitReview({
    required String subjectType,
    required String subjectId,
    required int stars,
    String? publicComment,
  });

  Future<void> submitQualityTicket({
    required String subjectType,
    required String subjectId,
    required String category,
    required String privateMessage,
    Map<String, num>? detailScores,
  });
}
