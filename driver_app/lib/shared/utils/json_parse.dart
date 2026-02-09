/// Safe JSON parsing for API responses (handles String, num, null from backend).

double safeDouble(dynamic v) {
  if (v == null) return 0.0;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString()) ?? 0.0;
}

int safeInt(dynamic v) {
  if (v == null) return 0;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString()) ?? 0;
}

/// Returns non-null String; null or invalid becomes ''.
String safeString(dynamic v) {
  if (v == null) return '';
  if (v is String) return v;
  return v.toString();
}

/// Returns null if v is null, otherwise String.
String? safeStringNullable(dynamic v) {
  if (v == null) return null;
  if (v is String) return v.isEmpty ? null : v;
  final s = v.toString();
  return s.isEmpty ? null : s;
}
