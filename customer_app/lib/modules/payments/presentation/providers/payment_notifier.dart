import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/providers.dart';
import '../../domain/repositories/payments_repo.dart';
import 'payment_state.dart';

final paymentNotifierProvider =
    StateNotifierProvider.family<PaymentNotifier, PaymentState, String>(
  (ref, orderId) {
    final repository = ref.watch(paymentsRepositoryProvider);
    return PaymentNotifier(repository, orderId);
  },
);

class PaymentNotifier extends StateNotifier<PaymentState> {
  final PaymentsRepository repository;
  final String orderId;

  PaymentNotifier(this.repository, this.orderId)
      : super(const PaymentState.initial());

  Future<void> initiatePayment(String method) async {
    state = const PaymentState.initiating();
    try {
      final payment = await repository.initiatePayment(orderId, method);
      state = PaymentState.initiated(payment);
    } catch (e) {
      state = PaymentState.error(e.toString());
      rethrow;
    }
  }

  Future<void> confirmPayment(String paymentId, String transactionId) async {
    state = const PaymentState.confirming();
    try {
      final payment = await repository.confirmPayment(paymentId, transactionId);
      state = PaymentState.confirmed(payment);
    } catch (e) {
      state = PaymentState.error(e.toString());
      rethrow;
    }
  }

  void reset() {
    state = const PaymentState.initial();
  }
}
