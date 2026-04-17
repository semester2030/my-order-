import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/chef_booking_requests_remote_ds.dart';
import '../../data/models/chef_booking_request_dto.dart';
import 'chef_booking_requests_state.dart';

class ChefBookingRequestsNotifier extends StateNotifier<ChefBookingRequestsState> {
  ChefBookingRequestsNotifier(this._ds) : super(ChefBookingRequestsInitial());

  final ChefBookingRequestsRemoteDs _ds;

  Future<void> load() async {
    state = ChefBookingRequestsLoading();
    try {
      final requests = await _ds.getRequests();
      state = ChefBookingRequestsLoaded(requests);
    } catch (e) {
      state = ChefBookingRequestsError(e.toString());
    }
  }

  Future<bool> accept(String requestId) async {
    final prev = state is ChefBookingRequestsLoaded
        ? List<ChefBookingRequestDto>.from((state as ChefBookingRequestsLoaded).requests)
        : null;
    try {
      await _ds.accept(requestId);
      await load();
      return true;
    } catch (e) {
      if (prev != null) {
        state = ChefBookingRequestsLoaded(prev);
      } else {
        state = ChefBookingRequestsError(e.toString());
      }
      return false;
    }
  }

  Future<bool> reject(String requestId) async {
    final prev = state is ChefBookingRequestsLoaded
        ? List<ChefBookingRequestDto>.from((state as ChefBookingRequestsLoaded).requests)
        : null;
    try {
      await _ds.reject(requestId);
      await load();
      return true;
    } catch (e) {
      if (prev != null) {
        state = ChefBookingRequestsLoaded(prev);
      } else {
        state = ChefBookingRequestsError(e.toString());
      }
      return false;
    }
  }
}
