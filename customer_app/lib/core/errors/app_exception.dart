import 'package:equatable/equatable.dart';
import 'network_exceptions.dart';

/// App exception wrapper
class AppException extends Equatable implements Exception {
  final String message;
  final int? code;
  final NetworkException? networkException;

  const AppException({
    required this.message,
    this.code,
    this.networkException,
  });

  factory AppException.fromNetworkException(NetworkException exception) {
    return AppException(
      message: exception.message,
      code: exception.statusCode,
      networkException: exception,
    );
  }

  @override
  List<Object?> get props => [message, code, networkException];

  @override
  String toString() => message;
}
