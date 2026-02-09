import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/repositories/jobs_repo.dart';
import '../../data/repositories/jobs_repo_impl.dart';
import '../../data/datasources/jobs_remote_ds.dart';
import '../../data/models/delivery_history_dto.dart';
import '../../../../core/di/providers.dart';
import '../../../../shared/utils/json_parse.dart';
import '../../data/models/accept_job_dto.dart';
import 'jobs_state.dart';

/// Jobs Repository Provider
final jobsRepositoryProvider = Provider<JobsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final remoteDataSource = JobsRemoteDataSourceImpl(apiClient: apiClient);
  return JobsRepositoryImpl(remoteDataSource: remoteDataSource);
});

/// Jobs Inbox Notifier Provider
final jobsInboxNotifierProvider =
    StateNotifierProvider<JobsInboxNotifier, JobsInboxState>((ref) {
  final repository = ref.watch(jobsRepositoryProvider);
  return JobsInboxNotifier(repository);
});

/// Active Job Notifier Provider
final activeJobNotifierProvider =
    StateNotifierProvider<ActiveJobNotifier, ActiveJobState>((ref) {
  final repository = ref.watch(jobsRepositoryProvider);
  return ActiveJobNotifier(repository);
});

/// Accept Job Notifier Provider
final acceptJobNotifierProvider =
    StateNotifierProvider<AcceptJobNotifier, AcceptJobState>((ref) {
  final repository = ref.watch(jobsRepositoryProvider);
  return AcceptJobNotifier(repository);
});

/// Delivery History Notifier Provider
final deliveryHistoryNotifierProvider =
    StateNotifierProvider<DeliveryHistoryNotifier, DeliveryHistoryState>((ref) {
  final repository = ref.watch(jobsRepositoryProvider);
  return DeliveryHistoryNotifier(repository);
});

/// Jobs Inbox Notifier
class JobsInboxNotifier extends StateNotifier<JobsInboxState> {
  final JobsRepository repository;

  JobsInboxNotifier(this.repository) : super(const JobsInboxInitial());

  Future<void> getInbox() async {
    state = const JobsInboxLoading();
    try {
      final jobs = await repository.getInbox();
      state = JobsInboxLoaded(jobs);
    } catch (e) {
      state = JobsInboxError(e.toString());
    }
  }
}

/// Active Job Notifier
class ActiveJobNotifier extends StateNotifier<ActiveJobState> {
  final JobsRepository repository;

  ActiveJobNotifier(this.repository) : super(const ActiveJobInitial());

  Future<void> getActiveJob() async {
    state = const ActiveJobLoading();
    try {
      final job = await repository.getActiveJob();
      if (job != null) {
        state = ActiveJobLoaded(job);
      } else {
        state = const ActiveJobEmpty();
      }
    } catch (e) {
      state = ActiveJobError(e.toString());
    }
  }

  /// Call after driver marks order as delivered so UI shows no active delivery.
  void clearActiveJob() {
    state = const ActiveJobEmpty();
  }
}

/// Accept Job Notifier
class AcceptJobNotifier extends StateNotifier<AcceptJobState> {
  final JobsRepository repository;

  AcceptJobNotifier(this.repository) : super(const AcceptJobInitial());

  Future<void> acceptJob(String jobOfferId) async {
    state = const AcceptJobLoading();
    try {
      final dto = AcceptJobDto(jobOfferId: jobOfferId);
      final response = await repository.acceptJob(dto);
      state = AcceptJobSuccess(
        jobId: safeString(response['jobId']),
        orderId: safeString(response['orderId']),
      );
    } catch (e) {
      state = AcceptJobError(e.toString());
    }
  }

  Future<void> rejectJob(String jobOfferId) async {
    try {
      await repository.rejectJob(jobOfferId);
      // Reset state after rejection
      state = const AcceptJobInitial();
    } catch (e) {
      state = AcceptJobError(e.toString());
    }
  }
}

/// Delivery History State
sealed class DeliveryHistoryState {
  const DeliveryHistoryState();
}

class DeliveryHistoryInitial extends DeliveryHistoryState {
  const DeliveryHistoryInitial();
}

class DeliveryHistoryLoading extends DeliveryHistoryState {
  const DeliveryHistoryLoading();
}

class DeliveryHistoryLoaded extends DeliveryHistoryState {
  final DeliveryHistoryDto data;

  const DeliveryHistoryLoaded(this.data);
}

class DeliveryHistoryError extends DeliveryHistoryState {
  final String message;

  const DeliveryHistoryError(this.message);
}

/// Delivery History Notifier
class DeliveryHistoryNotifier extends StateNotifier<DeliveryHistoryState> {
  final JobsRepository repository;

  DeliveryHistoryNotifier(this.repository) : super(const DeliveryHistoryInitial());

  Future<void> loadHistory() async {
    state = const DeliveryHistoryLoading();
    try {
      final data = await repository.getDeliveryHistory();
      state = DeliveryHistoryLoaded(data);
    } catch (e) {
      state = DeliveryHistoryError(e.toString());
    }
  }
}
