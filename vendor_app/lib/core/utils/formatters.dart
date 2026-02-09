/// Formatters for Vendor App (dates, numbers, etc.).
class Formatters {
  Formatters._();

  /// Format a date for display (e.g. dd/MM/yyyy).
  static String date(DateTime? date) {
    if (date == null) return '';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  /// Format a time for display (e.g. HH:mm).
  static String time(DateTime? date) {
    if (date == null) return '';
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  /// Format currency (e.g. ١٢٣ ر.س).
  static String currency(num? value, [String symbol = 'ر.س']) {
    if (value == null) return '0 $symbol';
    return '${value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)} $symbol';
  }

  /// Truncate string with ellipsis.
  static String truncate(String? text, int maxLength) {
    if (text == null) return '';
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}
