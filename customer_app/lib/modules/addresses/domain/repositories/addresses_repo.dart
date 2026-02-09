import '../entities/address.dart';

abstract class AddressesRepository {
  Future<List<Address>> getAddresses();
  Future<Address?> getDefaultAddress();
  Future<Address> addAddress(Address address);
  Future<Address> updateAddress(String id, Address address);
  Future<void> deleteAddress(String id);
  Future<void> setDefaultAddress(String id);
}
