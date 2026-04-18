/// Input validators for Vendor App.
class Validators {
  Validators._();

  /// Returns error message if invalid, null if valid.
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'البريد مطلوب';
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) return 'بريد غير صالح';
    return null;
  }

  /// Returns error message if invalid, null if valid.
  static String? required(String? value, [String fieldName = 'الحقل']) {
    if (value == null || value.trim().isEmpty) return '$fieldName مطلوب';
    return null;
  }

  /// Returns error message if invalid, null if valid.
  static String? minLength(String? value, int min, [String fieldName = 'الحقل']) {
    if (value == null) return '$fieldName مطلوب';
    if (value.length < min) return '$fieldName يجب أن يكون $min أحرف على الأقل';
    return null;
  }

  /// Returns error message if invalid, null if valid (e.g. password).
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'كلمة المرور مطلوبة';
    if (value.length < 6) return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
    return null;
  }

  /// Returns error message if invalid, null if valid.
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 9) return 'رقم الهاتف غير صالح';
    return null;
  }

  static String? latitude(String? value) {
    if (value == null || value.trim().isEmpty) return 'خط العرض مطلوب';
    final n = double.tryParse(value.trim().replaceAll(',', '.'));
    if (n == null) return 'خط العرض غير صالح';
    if (n < -90 || n > 90) return 'خط العرض يجب أن يكون بين -90 و 90';
    return null;
  }

  static String? longitude(String? value) {
    if (value == null || value.trim().isEmpty) return 'خط الطول مطلوب';
    final n = double.tryParse(value.trim().replaceAll(',', '.'));
    if (n == null) return 'خط الطول غير صالح';
    if (n < -180 || n > 180) return 'خط الطول يجب أن يكون بين -180 و 180';
    return null;
  }

  /// آيبان سعودي: SA + 22 رقماً (بدون مسافات). فارغ = صالح (اختياري).
  static String? saIbanOptional(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final t = value.trim().replaceAll(RegExp(r'\s'), '').toUpperCase();
    if (!RegExp(r'^SA\d{22}$').hasMatch(t)) {
      return 'آيبان غير صالح — يجب أن يبدأ بـ SA متبوعاً بـ 22 رقماً';
    }
    return null;
  }
}
