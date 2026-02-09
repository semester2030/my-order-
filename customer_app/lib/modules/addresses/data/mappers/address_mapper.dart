import '../../domain/entities/address.dart';
import '../models/address_dto.dart';

class AddressMapper {
  static Address mapAddressFromDto(AddressDto dto) {
    return Address(
      id: dto.id,
      label: dto.label,
      streetAddress: dto.streetAddress,
      building: dto.building,
      floor: dto.floor,
      apartment: dto.apartment,
      city: dto.city,
      district: dto.district,
      postalCode: dto.postalCode,
      latitude: dto.latitude,
      longitude: dto.longitude,
      isDefault: dto.isDefault,
      isActive: dto.isActive,
    );
  }

  static List<Address> mapAddressesFromDto(List<AddressDto> dtos) {
    return dtos.map((dto) => mapAddressFromDto(dto)).toList();
  }
}
