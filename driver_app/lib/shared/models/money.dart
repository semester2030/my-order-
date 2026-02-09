/// Money Model
/// 
/// Represents monetary values with currency
class Money {
  final double amount;
  final String currency;

  Money({
    required this.amount,
    this.currency = 'SAR',
  });

  /// Create Money from cents (for integer storage)
  factory Money.fromCents(int cents, {String currency = 'SAR'}) {
    return Money(amount: cents / 100, currency: currency);
  }

  /// Convert to cents (for integer storage)
  int toCents() {
    return (amount * 100).round();
  }

  /// Format as string with currency symbol
  String format() {
    return '${amount.toStringAsFixed(2)} $currency';
  }

  /// Format as string with currency symbol (compact)
  String formatCompact() {
    if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K $currency';
    }
    return format();
  }

  /// Add two Money values
  Money operator +(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot add different currencies');
    }
    return Money(amount: amount + other.amount, currency: currency);
  }

  /// Subtract two Money values
  Money operator -(Money other) {
    if (currency != other.currency) {
      throw ArgumentError('Cannot subtract different currencies');
    }
    return Money(amount: amount - other.amount, currency: currency);
  }

  /// Multiply Money by a number
  Money operator *(double multiplier) {
    return Money(amount: amount * multiplier, currency: currency);
  }

  /// Divide Money by a number
  Money operator /(double divisor) {
    if (divisor == 0) {
      throw ArgumentError('Cannot divide by zero');
    }
    return Money(amount: amount / divisor, currency: currency);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Money &&
        other.amount == amount &&
        other.currency == currency;
  }

  @override
  int get hashCode => amount.hashCode ^ currency.hashCode;

  @override
  String toString() => format();
}
