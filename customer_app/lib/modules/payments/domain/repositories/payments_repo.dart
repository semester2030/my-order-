import '../entities/payment.dart';

abstract class PaymentsRepository {
  Future<Payment> initiatePayment(String orderId, String method);
  Future<Payment> confirmPayment(String paymentId, String transactionId);
  Future<Payment> getPayment(String paymentId);
  Future<List<Payment>> getOrderPayments(String orderId);
}
