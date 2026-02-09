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
}
