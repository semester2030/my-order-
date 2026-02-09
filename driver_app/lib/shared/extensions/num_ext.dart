import '../models/money.dart';

/// Number Extensions
/// 
/// Useful extensions for numeric types
extension NumExtensions on num {
  /// Convert to Money (SAR by default)
  Money toMoney({String currency = 'SAR'}) {
    return Money(amount: toDouble(), currency: currency);
  }

  /// Format as currency string
  String toCurrencyString({String currency = 'SAR'}) {
    return Money(amount: toDouble(), currency: currency).format();
  }

  /// Format as compact currency string
  String toCompactCurrencyString({String currency = 'SAR'}) {
    return Money(amount: toDouble(), currency: currency).formatCompact();
  }

  /// Format distance in km
  String toDistanceString() {
    if (this < 1) {
      return '${(this * 1000).toStringAsFixed(0)} m';
    }
    return '${toStringAsFixed(1)} km';
  }

  /// Format duration in minutes
  String toDurationString() {
    if (this < 60) {
      return '${toStringAsFixed(0)} min';
    }
    final hours = (this / 60).floor();
    final minutes = (this % 60).round();
    if (minutes == 0) {
      return '$hours hr';
    }
    return '$hours hr $minutes min';
  }

  /// Clamp between min and max
  num clampBetween(num min, num max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}
