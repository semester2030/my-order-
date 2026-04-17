import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../domain/repositories/vendors_repo.dart';

/// قائمة طلبات حجز الطبّاخ (ذبائح + شوي) للعميل.
final myChefBookingsNotifierProvider =
    StateNotifierProvider<MyChefBookingsNotifier, MyChefBookingsState>((ref) {
  final repo = ref.watch(vendorsRepositoryProvider);
  return MyChefBookingsNotifier(repo);
});

sealed class MyChefBookingsState {}

class MyChefBookingsInitial extends MyChefBookingsState {}

class MyChefBookingsLoading extends MyChefBookingsState {}

class MyChefBookingsLoaded extends MyChefBookingsState {
  MyChefBookingsLoaded(this.items);
  final List<Map<String, dynamic>> items;
}

class MyChefBookingsError extends MyChefBookingsState {
  MyChefBookingsError(this.message);
  final String message;
}

class MyChefBookingsNotifier extends StateNotifier<MyChefBookingsState> {
  MyChefBookingsNotifier(this._repository) : super(MyChefBookingsInitial());

  final VendorsRepository _repository;

  Future<void> load() async {
    state = MyChefBookingsLoading();
    try {
      final items = await _repository.getMyChefBookingRequests();
      state = MyChefBookingsLoaded(items);
    } catch (e) {
      state = MyChefBookingsError(e.toString());
    }
  }

  Future<void> refresh() async {
    if (state is MyChefBookingsLoaded) {
      state = MyChefBookingsLoading();
    }
    await load();
  }

  Future<bool> cancelRequest(String requestId) async {
    try {
      await _repository.cancelMyEventRequest(requestId);
      await load();
      return true;
    } catch (e) {
      state = MyChefBookingsError(e.toString());
      return false;
    }
  }
}
