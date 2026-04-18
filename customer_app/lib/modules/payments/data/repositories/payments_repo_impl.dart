import '../../domain/repositories/payments_repo.dart';
import '../../domain/entities/payment.dart';
import '../../domain/entities/saved_payment_method.dart';
import '../datasources/payments_remote_ds.dart';
import '../mappers/payments_mapper.dart';
import '../models/saved_payment_method_dto.dart';

class PaymentsRepositoryImpl implements PaymentsRepository {
  final PaymentsRemoteDataSource remoteDataSource;

  PaymentsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Payment> initiatePayment(String orderId, String method) async {
    final dto = await remoteDataSource.initiatePayment(orderId, method);
    return PaymentsMapper.mapPaymentFromDto(dto);
  }

  @override
  Future<Payment> confirmPayment(String paymentId, String transactionId) async {
    final dto = await remoteDataSource.confirmPayment(paymentId, transactionId);
    return PaymentsMapper.mapPaymentFromDto(dto);
  }

  @override
  Future<Payment> getPayment(String paymentId) async {
    final dto = await remoteDataSource.getPayment(paymentId);
    return PaymentsMapper.mapPaymentFromDto(dto);
  }

  @override
  Future<List<Payment>> getOrderPayments(String orderId) async {
    final dtos = await remoteDataSource.getOrderPayments(orderId);
    return dtos.map((dto) => PaymentsMapper.mapPaymentFromDto(dto)).toList();
  }

  @override
  Future<List<SavedPaymentMethod>> listSavedPaymentMethods() async {
    final dtos = await remoteDataSource.listSavedPaymentMethods();
    return dtos.map(PaymentsMapper.mapSavedFromDto).toList();
  }

  @override
  Future<SavedPaymentMethod> createSavedPaymentMethod({
    required String holderName,
    required String last4,
    required int expMonth,
    required int expYear,
  }) async {
    final dto = await remoteDataSource.createSavedPaymentMethod(
      CreateSavedPaymentMethodPayload(
        holderName: holderName,
        last4: last4,
        expMonth: expMonth,
        expYear: expYear,
      ),
    );
    return PaymentsMapper.mapSavedFromDto(dto);
  }

  @override
  Future<void> deleteSavedPaymentMethod(String id) {
    return remoteDataSource.deleteSavedPaymentMethod(id);
  }
}
