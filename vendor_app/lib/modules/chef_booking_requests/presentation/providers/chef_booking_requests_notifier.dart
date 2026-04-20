import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../data/datasources/chef_booking_requests_remote_ds.dart';
import '../../data/models/chef_booking_request_dto.dart';
import 'chef_booking_requests_state.dart';

class ChefBookingRequestsNotifier extends StateNotifier<ChefBookingRequestsState> {
  ChefBookingRequestsNotifier(this._ds) : super(ChefBookingRequestsInitial());

  final ChefBookingRequestsRemoteDs _ds;

  /// آخر رسالة خطأ من إجراء (عرض سعر / رفض / جاهز / تسليم) عندما تبقى القائمة [Loaded].
  String? lastMutationMessage;

  Future<void> load() async {
    lastMutationMessage = null;
    state = ChefBookingRequestsLoading();
    try {
      final requests = await _ds.getRequests();
      state = ChefBookingRequestsLoaded(requests);
    } catch (e) {
      state = ChefBookingRequestsError(ErrorMapper.toFailure(e).message);
    }
  }

  Future<bool> quote(
    String requestId, {
    required double quotedAmount,
    String? quoteNotes,
  }) async {
    lastMutationMessage = null;
    final prev = state is ChefBookingRequestsLoaded
        ? List<ChefBookingRequestDto>.from((state as ChefBookingRequestsLoaded).requests)
        : null;
    try {
      await _ds.quote(requestId, quotedAmount: quotedAmount, quoteNotes: quoteNotes);
      await load();
      return true;
    } catch (e) {
      lastMutationMessage = ErrorMapper.toFailure(e).message;
      if (prev != null) {
        state = ChefBookingRequestsLoaded(prev);
      } else {
        state = ChefBookingRequestsError(lastMutationMessage!);
      }
      return false;
    }
  }

  Future<bool> reject(String requestId) async {
    lastMutationMessage = null;
    final prev = state is ChefBookingRequestsLoaded
        ? List<ChefBookingRequestDto>.from((state as ChefBookingRequestsLoaded).requests)
        : null;
    try {
      await _ds.reject(requestId);
      await load();
      return true;
    } catch (e) {
      lastMutationMessage = ErrorMapper.toFailure(e).message;
      if (prev != null) {
        state = ChefBookingRequestsLoaded(prev);
      } else {
        state = ChefBookingRequestsError(lastMutationMessage!);
      }
      return false;
    }
  }

  Future<bool> markReady(String requestId) async {
    lastMutationMessage = null;
    final prev = state is ChefBookingRequestsLoaded
        ? List<ChefBookingRequestDto>.from((state as ChefBookingRequestsLoaded).requests)
        : null;
    try {
      await _ds.markReady(requestId);
      await load();
      return true;
    } catch (e) {
      lastMutationMessage = ErrorMapper.toFailure(e).message;
      if (prev != null) {
        state = ChefBookingRequestsLoaded(prev);
      } else {
        state = ChefBookingRequestsError(lastMutationMessage!);
      }
      return false;
    }
  }

  Future<bool> markHandedOver(
    String requestId, {
    String? handoverNotes,
  }) async {
    lastMutationMessage = null;
    final prev = state is ChefBookingRequestsLoaded
        ? List<ChefBookingRequestDto>.from((state as ChefBookingRequestsLoaded).requests)
        : null;
    try {
      await _ds.markHandedOver(requestId, handoverNotes: handoverNotes);
      await load();
      return true;
    } catch (e) {
      lastMutationMessage = ErrorMapper.toFailure(e).message;
      if (prev != null) {
        state = ChefBookingRequestsLoaded(prev);
      } else {
        state = ChefBookingRequestsError(lastMutationMessage!);
      }
      return false;
    }
  }
}
