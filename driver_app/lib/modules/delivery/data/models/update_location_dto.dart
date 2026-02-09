/// Update Location DTO
class UpdateLocationDto {
  final double latitude;
  final double longitude;

  UpdateLocationDto({
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
        'latitude': latitude,
        'longitude': longitude,
      };
}
