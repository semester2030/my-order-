import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/event_requests_remote_ds.dart';
import 'event_requests_state.dart';

class EventRequestsNotifier extends StateNotifier<EventRequestsState> {
  EventRequestsNotifier(this._ds) : super(EventRequestsInitial());

  final EventRequestsRemoteDs _ds;

  Future<void> load() async {
    state = EventRequestsLoading();
    try {
      final requests = await _ds.getRequests();
      state = EventRequestsLoaded(requests);
    } catch (e) {
      state = EventRequestsError(e.toString());
    }
  }

  Future<bool> accept(String requestId) async {
    state = EventRequestsActioning();
    try {
      final updated = await _ds.accept(requestId);
      if (state is EventRequestsLoaded) {
        final list = (state as EventRequestsLoaded).requests;
        final idx = list.indexWhere((r) => r.id == requestId);
        final newList = [...list];
        if (idx >= 0) {
          newList[idx] = updated;
        }
        state = EventRequestsLoaded(newList);
      }
      return true;
    } catch (e) {
      state = EventRequestsError(e.toString());
      return false;
    }
  }

  Future<bool> reject(String requestId) async {
    state = EventRequestsActioning();
    try {
      final updated = await _ds.reject(requestId);
      if (state is EventRequestsLoaded) {
        final list = (state as EventRequestsLoaded).requests;
        final idx = list.indexWhere((r) => r.id == requestId);
        final newList = [...list];
        if (idx >= 0) {
          newList[idx] = updated;
        }
        state = EventRequestsLoaded(newList);
      }
      return true;
    } catch (e) {
      state = EventRequestsError(e.toString());
      return false;
    }
  }
}
