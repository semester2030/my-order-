import '../../domain/entities/profile.dart';
import '../models/profile_dto.dart';

class ProfileMapper {
  static Profile mapProfileFromDto(ProfileDto dto) {
    return Profile(
      id: dto.id,
      phone: dto.phone?.isEmpty == true ? null : dto.phone,
      name: dto.name,
      email: dto.email,
      isVerified: dto.isVerified,
      createdAt: _parseDateTime(dto.createdAt),
    );
  }

  static DateTime _parseDateTime(String? dateString) {
    if (dateString == null || dateString.isEmpty) {
      return DateTime.now();
    }
    try {
      return DateTime.parse(dateString);
    } catch (e) {
      // If date parsing fails, return current time
      return DateTime.now();
    }
  }
}
