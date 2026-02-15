/// Form validators
class AppValidators {
  AppValidators._();

  /// Phone number validator
  static String? phone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    if (value.length != 10) {
      return 'Phone number must be 10 digits';
    }

    if (!value.startsWith('05')) {
      return 'Phone number must start with 05';
    }

    return null;
  }

  /// OTP code validator
  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP code is required';
    }

    if (value.length != 6) {
      return 'OTP code must be 6 digits';
    }

    return null;
  }

  /// PIN validator
  static String? pin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN is required';
    }

    if (value.length != 4) {
      return 'PIN must be 4 digits';
    }

    return null;
  }

  /// Email or phone (login identifier) validator
  static String? emailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'أدخل البريد الإلكتروني أو رقم الجوال';
    }
    final v = value.trim();
    if (v.contains('@')) {
      return email(v);
    }
    return phone(v);
  }

  /// Email validator — pass localized messages from AppLocalizations
  static String? email(
    String? value, {
    String? requiredMessage,
    String? invalidMessage,
  }) {
    if (value == null || value.isEmpty) {
      return requiredMessage ?? 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return invalidMessage ?? 'Please enter a valid email';
    }
    return null;
  }

  /// Required field validator — pass localized message
  static String? required(String? value, {String? fieldName, String? message}) {
    if (value == null || value.isEmpty) {
      return message ?? '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Minimum length validator — pass localized messages
  static String? minLength(
    String? value,
    int minLength, {
    String? fieldName,
    String? requiredMessage,
    String? minLengthMessage,
  }) {
    if (value == null || value.isEmpty) {
      return requiredMessage ?? '${fieldName ?? 'This field'} is required';
    }
    if (value.length < minLength) {
      return minLengthMessage ??
          '${fieldName ?? 'This field'} must be at least $minLength characters';
    }
    return null;
  }

  /// Maximum length validator
  static String? maxLength(String? value, int maxLength, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return null; // Let required validator handle empty
    }

    if (value.length > maxLength) {
      return '${fieldName ?? 'This field'} must be at most $maxLength characters';
    }

    return null;
  }
}
