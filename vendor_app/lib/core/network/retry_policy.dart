/// سياسة إعادة المحاولة — Phase 7.
/// عمليات حساسة (قبول/رفض/تحديث حالة طلب) = retry + idempotency key؛
/// غير حساسة (مثل تحديث التحليلات) = retry بسيط؛
/// رفع ملفات = retry with backoff.
enum RetryOperationType {
  /// عمليات حساسة: retry مع idempotency key عند التوفر.
  sensitive,

  /// عمليات غير حساسة: retry بسيط.
  nonSensitive,

  /// رفع ملفات: retry مع exponential backoff.
  fileUpload,
}

/// إعدادات إعادة المحاولة.
class RetryPolicy {
  const RetryPolicy({
    this.maxAttempts = 3,
    this.initialDelayMs = 500,
    this.maxDelayMs = 10000,
    this.backoffMultiplier = 2.0,
  });

  final int maxAttempts;
  final int initialDelayMs;
  final int maxDelayMs;
  final double backoffMultiplier;

  /// تأخير قبل المحاولة [attempt] (0-based).
  Duration delayForAttempt(int attempt) {
    if (attempt <= 0) return Duration.zero;
    final delay = initialDelayMs * (backoffMultiplier * attempt);
    final capped = delay > maxDelayMs ? maxDelayMs : delay.toInt();
    return Duration(milliseconds: capped);
  }

  static const RetryPolicy defaultPolicy = RetryPolicy();
}
