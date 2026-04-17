import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/di/providers.dart';
import '../../domain/repositories/vendors_repo.dart';

/// قائمة طلبات الطبخ المنزلي للعميل.
final myHomeCookingNotifierProvider =
    StateNotifierProvider<MyHomeCookingNotifier, MyHomeCookingState>((ref) {
  final repo = ref.watch(vendorsRepositoryProvider);
  return MyHomeCookingNotifier(repo);
});

sealed class MyHomeCookingState {}

class MyHomeCookingInitial extends MyHomeCookingState {}

class MyHomeCookingLoading extends MyHomeCookingState {}

class MyHomeCookingLoaded extends MyHomeCookingState {
  MyHomeCookingLoaded(this.items);
  final List<Map<String, dynamic>> items;
}

class MyHomeCookingError extends MyHomeCookingState {
  MyHomeCookingError(this.message);
  final String message;
}

class MyHomeCookingNotifier extends StateNotifier<MyHomeCookingState> {
  MyHomeCookingNotifier(this._repository) : super(MyHomeCookingInitial());

  final VendorsRepository _repository;

  Future<void> load() async {
    state = MyHomeCookingLoading();
    try {
      final items = await _repository.getMyHomeCookingRequests();
      state = MyHomeCookingLoaded(items);
    } catch (e) {
      state = MyHomeCookingError(e.toString());
    }
  }

  Future<void> refresh() async {
    if (state is MyHomeCookingLoaded) {
      state = MyHomeCookingLoading();
    }
    await load();
  }

  Future<bool> cancelRequest(String requestId) async {
    try {
      await _repository.cancelMyEventRequest(requestId);
      await load();
      return true;
    } catch (e) {
      state = MyHomeCookingError(e.toString());
      return false;
    }
  }
}
