import 'package:equatable/equatable.dart';

import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/staff_member.dart';

/// حالة قائمة الموظفين — Phase 13.
sealed class StaffState with EquatableMixin {
  const StaffState();

  @override
  List<Object?> get props => [];
}

final class StaffInitial extends StaffState {
  const StaffInitial();
}

final class StaffLoading extends StaffState {
  const StaffLoading();
}

final class StaffLoaded extends StaffState {
  const StaffLoaded(this.result);
  final PagedResult<StaffMember> result;

  @override
  List<Object?> get props => [result];
}

final class StaffError extends StaffState {
  const StaffError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

final class StaffSaving extends StaffState {
  const StaffSaving();
}
