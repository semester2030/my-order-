/// Update Driver Availability DTO
class UpdateAvailabilityDto {
  final bool isOnline;

  UpdateAvailabilityDto({required this.isOnline});

  Map<String, dynamic> toJson() => {
        'isOnline': isOnline,
      };
}
