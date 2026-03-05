/// روابط الموقع الإلكتروني — سياسة الخصوصية والشروط.
/// ⚠️ مهم: حدّث [websiteBaseUrl] عند نشر الموقع على Netlify.
/// مثال: إذا كان الرابط https://my-order-site.netlify.app فغيّر القيمة أدناه.
class AppUrls {
  AppUrls._();

  /// الرابط الأساسي للموقع — حدّثه بعد النشر على Netlify
  static const String websiteBaseUrl = 'https://homekitchen-app.netlify.app';

  static String get privacyPolicyUrl => '$websiteBaseUrl/privacy.html';
  static String get termsUrl => '$websiteBaseUrl/terms.html';
}
