import '../../data/models/job_offer_dto.dart';
import '../../data/models/active_job_dto.dart';

/// Jobs Inbox State
sealed class JobsInboxState {
  const JobsInboxState();
}

class JobsInboxInitial extends JobsInboxState {
  const JobsInboxInitial();
}

class JobsInboxLoading extends JobsInboxState {
  const JobsInboxLoading();
}

class JobsInboxLoaded extends JobsInboxState {
  final List<JobOfferDto> jobs;

  const JobsInboxLoaded(this.jobs);
}

class JobsInboxError extends JobsInboxState {
  final String message;

  const JobsInboxError(this.message);
}

/// Active Job State
sealed class ActiveJobState {
  const ActiveJobState();
}

class ActiveJobInitial extends ActiveJobState {
  const ActiveJobInitial();
}

class ActiveJobLoading extends ActiveJobState {
  const ActiveJobLoading();
}

class ActiveJobLoaded extends ActiveJobState {
  final ActiveJobDto job;

  const ActiveJobLoaded(this.job);
}

class ActiveJobEmpty extends ActiveJobState {
  const ActiveJobEmpty();
}

class ActiveJobError extends ActiveJobState {
  final String message;

  const ActiveJobError(this.message);
}

/// Accept Job State
sealed class AcceptJobState {
  const AcceptJobState();
}

class AcceptJobInitial extends AcceptJobState {
  const AcceptJobInitial();
}

class AcceptJobLoading extends AcceptJobState {
  const AcceptJobLoading();
}

class AcceptJobSuccess extends AcceptJobState {
  final String jobId;
  final String orderId;

  const AcceptJobSuccess({
    required this.jobId,
    required this.orderId,
  });
}

class AcceptJobError extends AcceptJobState {
  final String message;

  const AcceptJobError(this.message);
}
