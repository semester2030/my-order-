import 'dart:async';
import 'package:flutter/material.dart';

/// Debounce Utility
/// 
/// Debounces function calls to prevent excessive execution
class Debounce {
  final Duration delay;
  Timer? _timer;

  Debounce({this.delay = const Duration(milliseconds: 500)});

  /// Execute function with debounce
  void call(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(delay, action);
  }

  /// Cancel pending execution
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// Dispose debounce
  void dispose() {
    cancel();
  }
}

/// Debounce extension for functions
extension DebounceExtension on Function {
  /// Create debounced version of function
  Function debounce([Duration delay = const Duration(milliseconds: 500)]) {
    final debouncer = Debounce(delay: delay);
    return () => debouncer.call(() => this());
  }
}
