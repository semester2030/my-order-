import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../domain/repositories/addresses_repo.dart';
import '../../domain/entities/address.dart';
import 'address_state.dart';

final addressNotifierProvider =
    StateNotifierProvider<AddressNotifier, AddressState>((ref) {
  final repository = ref.watch(addressesRepositoryProvider);
  return AddressNotifier(repository);
});

class AddressNotifier extends StateNotifier<AddressState> {
  final AddressesRepository repository;

  AddressNotifier(this.repository) : super(const AddressState.initial()) {
    loadAddresses();
  }

  Future<void> loadAddresses() async {
    state = const AddressState.loading();
    try {
      final addresses = await repository.getAddresses();
      state = AddressState.loaded(addresses);
    } catch (e) {
      state = AddressState.error(e.toString());
    }
  }

  Future<void> addAddress(Address address) async {
    state = const AddressState.loading();
    try {
      await repository.addAddress(address);
      await loadAddresses();
    } catch (e) {
      state = AddressState.error(e.toString());
      rethrow;
    }
  }

  Future<void> updateAddress(String id, Address address) async {
    state = const AddressState.loading();
    try {
      await repository.updateAddress(id, address);
      await loadAddresses();
    } catch (e) {
      state = AddressState.error(e.toString());
      rethrow;
    }
  }

  Future<void> deleteAddress(String id) async {
    state = const AddressState.loading();
    try {
      await repository.deleteAddress(id);
      await loadAddresses();
    } catch (e) {
      state = AddressState.error(e.toString());
      rethrow;
    }
  }

  Future<void> setDefaultAddress(String id) async {
    state = const AddressState.loading();
    try {
      await repository.setDefaultAddress(id);
      await loadAddresses();
    } catch (e) {
      state = AddressState.error(e.toString());
      rethrow;
    }
  }

  Future<void> refresh() async {
    await loadAddresses();
  }
}
