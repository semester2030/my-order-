import 'package:equatable/equatable.dart';

import 'package:vendor_app/shared/models/paged_result.dart';

import '../../domain/entities/service_item.dart';

/// حالة قائمة الخدمات — Phase 11.
sealed class ServicesState with EquatableMixin {
  const ServicesState();

  @override
  List<Object?> get props => [];
}

final class ServicesInitial extends ServicesState {
  const ServicesInitial();
}

final class ServicesLoading extends ServicesState {
  const ServicesLoading();
}

final class ServicesLoaded extends ServicesState {
  const ServicesLoaded(this.result);
  final PagedResult<ServiceItem> result;

  @override
  List<Object?> get props => [result];
}

final class ServicesError extends ServicesState {
  const ServicesError(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

/// أثناء إضافة أو تحديث خدمة.
final class ServicesSaving extends ServicesState {
  const ServicesSaving();
}
