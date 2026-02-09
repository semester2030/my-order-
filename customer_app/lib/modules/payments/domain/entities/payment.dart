import 'package:equatable/equatable.dart';

enum PaymentMethod {
  applePay('apple_pay'),
  mada('mada'),
  stcPay('stc_pay'),
  cash('cash');

  final String value;
  const PaymentMethod(this.value);
}

enum PaymentStatus {
  pending('pending'),
  processing('processing'),
  completed('completed'),
  failed('failed'),
  refunded('refunded');

  final String value;
  const PaymentStatus(this.value);
}

class Payment extends Equatable {
  final String id;
  final String orderId;
  final PaymentMethod method;
  final PaymentStatus status;
  final double amount;
  final String? transactionId;
  final String? gatewayResponse;
  final String? failureReason;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Payment({
    required this.id,
    required this.orderId,
    required this.method,
    required this.status,
    required this.amount,
    this.transactionId,
    this.gatewayResponse,
    this.failureReason,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        orderId,
        method,
        status,
        amount,
        transactionId,
        gatewayResponse,
        failureReason,
        createdAt,
        updatedAt,
      ];
}
