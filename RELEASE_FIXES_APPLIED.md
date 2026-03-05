# الإصلاحات المُنفّذة — جاهزية النشر

**التاريخ:** 28 يناير 2026

---

## ١. أذونات الكاميرا والمعرض (vendor_app)

**الملف:** `vendor_app/ios/Runner/Info.plist`

**ما تم إضافته:**
- `NSCameraUsageDescription` — للكاميرا لالتقاط صور الوجبات
- `NSPhotoLibraryUsageDescription` — للمعرض لاختيار الصور
- `NSPhotoLibraryAddUsageDescription` — لحفظ الصور في المعرض

---

## ٢. صور شاشة الإقلاع (Launch Screen)

**المشكلة:** صور Launch كانت 68 bytes (placeholders).

**ما تم:**
- **customer_app:** إنشاء صور من `assets/images/icons/logo.jpeg` بأحجام 168×168، 336×336، 504×504
- **vendor_app:** نفس العملية من `assets/images/logo.jpeg`
- تغيير خلفية LaunchScreen إلى داكن (#0f0f0f) ليتناسق مع التطبيق

**الملفات المُحدّثة:**
- `customer_app/ios/Runner/Assets.xcassets/LaunchImage.imageset/*.png`
- `vendor_app/ios/Runner/Assets.xcassets/LaunchImage.imageset/*.png`
- `customer_app/ios/Runner/Base.lproj/LaunchScreen.storyboard`
- `vendor_app/ios/Runner/Base.lproj/LaunchScreen.storyboard`

---

## ٣. سياسة الخصوصية والشروط

**ما تم:**
- إنشاء `website/privacy.html` — سياسة الخصوصية (عربي/إنجليزي)
- إنشاء `website/terms.html` — الشروط والأحكام (عربي/إنجليزي)
- إضافة روابط في footer الموقع (`index.html`)
- إنشاء `customer_app/lib/core/config/app_urls.dart` — روابط الثوابت
- تحديث `settings_screen.dart` — فتح الروابط في المتصفح بدلاً من "قريباً"

**مهم:** حدّث `websiteBaseUrl` في `app_urls.dart` عند نشر الموقع على Netlify:
```dart
// الملف: customer_app/lib/core/config/app_urls.dart
static const String websiteBaseUrl = 'https://YOUR-SITE.netlify.app';
```

---

## ٤. دعم Android

**ما تم:**
- إضافة منصة Android لتطبيق العميل (`customer_app`)
- إضافة منصة Android لتطبيق المورد (`vendor_app`)
- إعداد `AndroidManifest.xml` — الأذونات، أسماء التطبيق
- تفعيل `flutter_launcher_icons` لـ Android
- إنشاء أيقونات Android من اللوقو

**التطبيق** | **applicationId** | **label**
---|---|---
customer_app | sa.myorder.customer_app | مطبخ البيت
vendor_app | sa.vendorapp.vendor_app | شيف مطبخ البيت

**الأذونات المضافة:**
- customer_app: INTERNET, ACCESS_FINE_LOCATION, ACCESS_COARSE_LOCATION
- vendor_app: INTERNET, CAMERA, READ_EXTERNAL_STORAGE, WRITE_EXTERNAL_STORAGE, READ_MEDIA_IMAGES

---

## ٥. خطوات التوقيع للنشر (Android)

لنشر على Google Play تحتاج:

1. **إنشاء keystore:**
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. **إنشاء `key.properties`** (لا ترفعه في Git):
```properties
storePassword=***
keyPassword=***
keyAlias=upload
storeFile=../upload-keystore.jks
```

3. **تحديث `android/app/build.gradle.kts`** لاستخدام التوقيع في release.

---

## ٦. ملخص الحالة

| البند | قبل | بعد |
|-------|-----|-----|
| أذونات الكاميرا (vendor) | ❌ | ✅ |
| صور Launch | ❌ 68 bytes | ✅ صور حقيقية |
| سياسة الخصوصية | ❌ "قريباً" | ✅ صفحات + روابط |
| دعم Android | ❌ | ✅ |
| أيقونات Android | ❌ | ✅ من اللوقو |

---

**ملاحظة:** تأكد من نشر الموقع على Netlify وتحديث `websiteBaseUrl` قبل رفع التطبيق إلى المتاجر.
