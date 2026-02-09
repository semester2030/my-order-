import '../../domain/repositories/addresses_repo.dart';
import '../../domain/entities/address.dart';
import '../datasources/addresses_remote_ds.dart';
import '../mappers/address_mapper.dart';

class AddressesRepositoryImpl implements AddressesRepository {
  final AddressesRemoteDataSource remoteDataSource;

  AddressesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Address>> getAddresses() async {
    final dtos = await remoteDataSource.getAddresses();
    return AddressMapper.mapAddressesFromDto(dtos);
  }

  @override
  Future<Address?> getDefaultAddress() async {
    try {
      final dto = await remoteDataSource.getDefaultAddress();
      return AddressMapper.mapAddressFromDto(dto);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Address> addAddress(Address address) async {
    final dto = await remoteDataSource.addAddress({
      'label': address.label,
      'streetAddress': address.streetAddress,
      'building': address.building,
      'floor': address.floor,
      'apartment': address.apartment,
      'city': address.city,
      'district': address.district,
      'postalCode': address.postalCode,
      'latitude': address.latitude,
      'longitude': address.longitude,
      'isDefault': address.isDefault,
    });
    return AddressMapper.mapAddressFromDto(dto);
  }

  @override
  Future<Address> updateAddress(String id, Address address) async {
    final dto = await remoteDataSource.updateAddress(id, {
      'label': address.label,
      'streetAddress': address.streetAddress,
      'building': address.building,
      'floor': address.floor,
      'apartment': address.apartment,
      'city': address.city,
      'district': address.district,
      'postalCode': address.postalCode,
      'latitude': address.latitude,
      'longitude': address.longitude,
      'isDefault': address.isDefault,
      'isActive': address.isActive,
    });
    return AddressMapper.mapAddressFromDto(dto);
  }

  @override
  Future<void> deleteAddress(String id) async {
    await remoteDataSource.deleteAddress(id);
  }

  @override
  Future<void> setDefaultAddress(String id) async {
    // Update all addresses to set isDefault to false, then set this one to true
    final addresses = await getAddresses();
    for (final address in addresses) {
      if (address.id != id && address.isDefault) {
        await updateAddress(address.id, Address(
          id: address.id,
          label: address.label,
          streetAddress: address.streetAddress,
          building: address.building,
          floor: address.floor,
          apartment: address.apartment,
          city: address.city,
          district: address.district,
          postalCode: address.postalCode,
          latitude: address.latitude,
          longitude: address.longitude,
          isDefault: false,
          isActive: address.isActive,
        ),);
      }
    }
    final targetAddress = addresses.firstWhere((a) => a.id == id);
    await updateAddress(id, Address(
      id: targetAddress.id,
      label: targetAddress.label,
      streetAddress: targetAddress.streetAddress,
      building: targetAddress.building,
      floor: targetAddress.floor,
      apartment: targetAddress.apartment,
      city: targetAddress.city,
      district: targetAddress.district,
      postalCode: targetAddress.postalCode,
      latitude: targetAddress.latitude,
      longitude: targetAddress.longitude,
      isDefault: true,
      isActive: targetAddress.isActive,
    ),);
  }
}
