import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../domain/repositories/vendors_repo.dart';
import 'vendor_state.dart';

final vendorNotifierProvider =
    StateNotifierProvider.family<VendorNotifier, VendorState, String>(
  (ref, vendorId) {
    final repository = ref.watch(vendorsRepositoryProvider);
    return VendorNotifier(repository, vendorId);
  },
);

class VendorNotifier extends StateNotifier<VendorState> {
  final VendorsRepository repository;
  final String vendorId;

  VendorNotifier(this.repository, this.vendorId)
      : super(const VendorState.initial()) {
    loadVendor();
  }

  Future<void> loadVendor() async {
    state = const VendorState.loading();
    try {
      final vendor = await repository.getVendor(vendorId);
      final menuItems = await repository.getVendorMenu(vendorId);
      state = VendorState.loaded(vendor, menuItems);
    } catch (e) {
      state = VendorState.error(e.toString());
    }
  }

  Future<void> refresh() async {
    await loadVendor();
  }
}
