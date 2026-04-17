import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/home_cooking_requests_remote_ds.dart';
import '../../data/models/home_cooking_request_dto.dart';
import 'home_cooking_requests_state.dart';

class HomeCookingRequestsNotifier extends StateNotifier<HomeCookingRequestsState> {
  HomeCookingRequestsNotifier(this._ds) : super(HomeCookingRequestsInitial());

  final HomeCookingRequestsRemoteDs _ds;

  Future<void> load() async {
    state = HomeCookingRequestsLoading();
    try {
      final requests = await _ds.getRequests();
      state = HomeCookingRequestsLoaded(requests);
    } catch (e) {
      state = HomeCookingRequestsError(e.toString());
    }
  }

  Future<bool> quote(
    String requestId, {
    required double quotedAmount,
    String? quoteNotes,
  }) async {
    final prev = state is HomeCookingRequestsLoaded
        ? List<HomeCookingRequestDto>.from((state as HomeCookingRequestsLoaded).requests)
        : null;
    try {
      await _ds.quote(requestId, quotedAmount: quotedAmount, quoteNotes: quoteNotes);
      await load();
      return true;
    } catch (e) {
      if (prev != null) {
        state = HomeCookingRequestsLoaded(prev);
      } else {
        state = HomeCookingRequestsError(e.toString());
      }
      return false;
    }
  }

  Future<bool> reject(String requestId) async {
    final prev = state is HomeCookingRequestsLoaded
        ? List<HomeCookingRequestDto>.from((state as HomeCookingRequestsLoaded).requests)
        : null;
    try {
      await _ds.reject(requestId);
      await load();
      return true;
    } catch (e) {
      if (prev != null) {
        state = HomeCookingRequestsLoaded(prev);
      } else {
        state = HomeCookingRequestsError(e.toString());
      }
      return false;
    }
  }

  Future<bool> markReady(String requestId) async {
    final prev = state is HomeCookingRequestsLoaded
        ? List<HomeCookingRequestDto>.from((state as HomeCookingRequestsLoaded).requests)
        : null;
    try {
      await _ds.markReady(requestId);
      await load();
      return true;
    } catch (e) {
      if (prev != null) {
        state = HomeCookingRequestsLoaded(prev);
      } else {
        state = HomeCookingRequestsError(e.toString());
      }
      return false;
    }
  }

  Future<bool> markHandedOver(
    String requestId, {
    String? handoverNotes,
  }) async {
    final prev = state is HomeCookingRequestsLoaded
        ? List<HomeCookingRequestDto>.from((state as HomeCookingRequestsLoaded).requests)
        : null;
    try {
      await _ds.markHandedOver(requestId, handoverNotes: handoverNotes);
      await load();
      return true;
    } catch (e) {
      if (prev != null) {
        state = HomeCookingRequestsLoaded(prev);
      } else {
        state = HomeCookingRequestsError(e.toString());
      }
      return false;
    }
  }
}
