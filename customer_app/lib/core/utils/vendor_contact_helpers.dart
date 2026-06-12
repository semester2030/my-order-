/// استخراج رقم جوال مقدّم الخدمة من استجابة الطلب.
String? vendorMobileFromRow(Map<String, dynamic> row) {
  final vendor = row['vendor'];
  if (vendor is! Map<String, dynamic>) return null;
  final raw = vendor['phoneNumber'] ??
      vendor['phone_number'] ??
      vendor['mobile'] ??
      vendor['phone'];
  if (raw == null) return null;
  final s = raw.toString().trim();
  return s.isEmpty ? null : s;
}

String? vendorNameFromRow(Map<String, dynamic> row) {
  final vendor = row['vendor'];
  if (vendor is! Map<String, dynamic>) return null;
  final raw = vendor['name'] ?? vendor['tradeName'] ?? vendor['trade_name'];
  if (raw == null) return null;
  final s = raw.toString().trim();
  return s.isEmpty ? null : s;
}
