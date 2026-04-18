import '../entities/payment.dart';
import '../entities/saved_payment_method.dart';

abstract class PaymentsRepository {
  Future<Payment> initiatePayment(String orderId, String method);
  Future<Payment> confirmPayment(String paymentId, String transactionId);
  Future<Payment> getPayment(String paymentId);
  Future<List<Payment>> getOrderPayments(String orderId);
  Future<List<SavedPaymentMethod>> listSavedPaymentMethods();
  Future<SavedPaymentMethod> createSavedPaymentMethod({
    required String holderName,
    required String last4,
    required int expMonth,
    required int expYear,
  });
  Future<void> deleteSavedPaymentMethod(String id);
}
