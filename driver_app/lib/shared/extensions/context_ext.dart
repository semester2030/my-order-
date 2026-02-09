import 'package:flutter/material.dart';

/// Context Extensions
/// 
/// Useful extensions for BuildContext
extension ContextExtensions on BuildContext {
  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Check if screen is small (mobile)
  bool get isSmallScreen => screenWidth < 600;

  /// Check if screen is medium (tablet)
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;

  /// Check if screen is large (desktop)
  bool get isLargeScreen => screenWidth >= 1200;

  /// Get safe area padding
  EdgeInsets get safeAreaPadding => MediaQuery.of(this).padding;

  /// Get text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Show snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Show dialog
  Future<T?> showAppDialog<T>(Widget dialog) {
    return showDialog<T>(
      context: this,
      builder: (context) => dialog,
    );
  }

  /// Show bottom sheet
  Future<T?> showAppBottomSheet<T>(Widget bottomSheet) {
    return showModalBottomSheet<T>(
      context: this,
      builder: (context) => bottomSheet,
    );
  }

  /// Navigate back
  void pop<T>([T? result]) {
    Navigator.of(this).pop(result);
  }

  /// Check if can pop
  bool get canPop => Navigator.of(this).canPop();
}
