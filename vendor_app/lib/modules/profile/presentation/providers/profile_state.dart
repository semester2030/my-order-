import 'package:equatable/equatable.dart';

import '../../domain/entities/vendor_profile.dart';

/// Profile UI state (Phase 6: أساس).
sealed class ProfileState with EquatableMixin {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded(this.profile);
  final VendorProfile profile;

  @override
  List<Object?> get props => [profile];
}

final class ProfileError extends ProfileState {
  const ProfileError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// عرض أثناء حفظ التعديلات (تعديل بروفايل أو تغيير كلمة المرور).
final class ProfileSaving extends ProfileState {
  const ProfileSaving();
}

final class ProfileSaveError extends ProfileState {
  const ProfileSaveError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}
