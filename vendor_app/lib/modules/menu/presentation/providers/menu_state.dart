import 'package:equatable/equatable.dart';

import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/menu_item.dart';

/// حالة قائمة الوجبات — Phase 10.
sealed class MenuState with EquatableMixin {
  const MenuState();

  @override
  List<Object?> get props => [];
}

final class MenuInitial extends MenuState {
  const MenuInitial();
}

final class MenuLoading extends MenuState {
  const MenuLoading();
}

final class MenuLoaded extends MenuState {
  const MenuLoaded(this.result);
  final PagedResult<MenuItem> result;

  @override
  List<Object?> get props => [result];
}

final class MenuError extends MenuState {
  const MenuError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// أثناء إضافة أو تحديث وجبة.
final class MenuSaving extends MenuState {
  const MenuSaving();
}
