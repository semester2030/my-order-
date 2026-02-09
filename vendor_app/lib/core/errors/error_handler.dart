import 'package:flutter/foundation.dart';

import 'app_exception.dart';
import 'failure.dart';
import 'error_mapper.dart';

/// Global error handler: exceptions → user-facing message and optional [Failure].
class ErrorHandler {
  ErrorHandler._();

  /// Convert [Object] (exception or error) to user message.
  static String toMessage(Object error, [StackTrace? stackTrace]) {
    if (error is AppException) return error.message;
    final failure = ErrorMapper.toFailure(error);
    return failure.message;
  }

  /// Convert [Object] to [Failure].
  static Failure toFailure(Object error, [StackTrace? stackTrace]) {
    return ErrorMapper.toFailure(error);
  }

  /// Log error (debug only).
  static void log(Object error, [StackTrace? stackTrace]) {
    if (kDebugMode) {
      // ignore: avoid_print
      debugPrint('ErrorHandler: $error');
      if (stackTrace != null) debugPrint(stackTrace.toString());
    }
  }
}
