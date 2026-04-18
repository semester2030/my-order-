import '../../domain/entities/payment.dart';
import '../../domain/entities/saved_payment_method.dart';
import '../models/payment_dto.dart';
import '../models/saved_payment_method_dto.dart';

class PaymentsMapper {
  static Payment mapPaymentFromDto(PaymentDto dto) {
    return Payment(
      id: dto.id,
      orderId: dto.orderId,
      method: _mapPaymentMethod(dto.method),
      status: _mapPaymentStatus(dto.status),
      amount: dto.amount,
      transactionId: dto.transactionId,
      gatewayResponse: dto.gatewayResponse,
      failureReason: dto.failureReason,
      createdAt: DateTime.parse(dto.createdAt),
      updatedAt: DateTime.parse(dto.updatedAt),
    );
  }

  static PaymentMethod _mapPaymentMethod(String method) {
    switch (method) {
      case 'apple_pay':
        return PaymentMethod.applePay;
      case 'mada':
        return PaymentMethod.mada;
      case 'stc_pay':
        return PaymentMethod.stcPay;
      default:
        throw Exception('Unknown payment method: $method');
    }
  }

  static PaymentStatus _mapPaymentStatus(String status) {
    switch (status) {
      case 'pending':
        return PaymentStatus.pending;
      case 'processing':
        return PaymentStatus.processing;
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        throw Exception('Unknown payment status: $status');
    }
  }

  static SavedPaymentMethod mapSavedFromDto(SavedPaymentMethodDto dto) {
    return SavedPaymentMethod(
      id: dto.id,
      brand: dto.brand,
      last4: dto.last4,
      expMonth: dto.expMonth,
      expYear: dto.expYear,
      holderName: dto.holderName,
      createdAt: dto.createdAt != null ? DateTime.tryParse(dto.createdAt!) : null,
    );
  }
}
