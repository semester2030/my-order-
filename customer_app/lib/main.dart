import 'dart:async';
import 'package:flutter/foundation.dart';
import 'bootstrap.dart';

void main() {
  runZonedGuarded(() async {
    FlutterError.onError = (details) {
      FlutterError.presentError(details);
      if (kDebugMode) {
        // في التطوير: طباعة الخطأ
        debugPrint('FlutterError: ${details.exception}');
      }
    };
    await bootstrap();
  }, (error, stack) {
    if (kDebugMode) {
      debugPrint('Uncaught error: $error\n$stack');
    }
  });
}
