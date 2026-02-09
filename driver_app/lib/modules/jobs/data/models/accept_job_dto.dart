/// Accept Job DTO
class AcceptJobDto {
  final String jobOfferId;

  AcceptJobDto({required this.jobOfferId});

  Map<String, dynamic> toJson() => {
        'jobOfferId': jobOfferId,
      };
}
