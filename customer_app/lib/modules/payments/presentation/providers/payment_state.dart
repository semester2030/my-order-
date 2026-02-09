import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/payment.dart';

part 'payment_state.freezed.dart';

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState.initial() = _Initial;
  const factory PaymentState.initiating() = _Initiating;
  const factory PaymentState.initiated(Payment payment) = _Initiated;
  const factory PaymentState.confirming() = _Confirming;
  const factory PaymentState.confirmed(Payment payment) = _Confirmed;
  const factory PaymentState.error(String message) = _Error;
}
