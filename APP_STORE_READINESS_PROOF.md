# تقرير إثباتات جاهزية النشر — App Store & Google Play

**التاريخ:** 28 يناير 2026  
**الغرض:** إثباتات دقيقة من الأكواد لمعرفة ما إذا كان التطبيق جاهزاً للنشر

---

## ملخص تنفيذي

| المنصة | تطبيق العميل (مطبخ البيت) | تطبيق المورد (شيف مطبخ البيت) |
|-------|---------------------------|--------------------------------|
| **App Store (iOS)** | ⚠️ جاهز مع تحفظات | ⚠️ يحتاج إصلاحات |
| **Google Play (Android)** | ❌ غير مدعوم | ❌ غير مدعوم |

---

## ١. إثباتات iOS (App Store)

### ١.١ Bundle ID و Display Name

**تطبيق العميل (customer_app):**

| العنصر | القيمة | الدليل (المسار + السطر) |
|--------|--------|-------------------------|
| Bundle ID | `sa.myorder.customer` | `customer_app/ios/Runner.xcodeproj/project.pbxproj` سطور 500, 687, 710 |
| Display Name | مطبخ البيت | `customer_app/ios/Runner/Info.plist` سطور 7-8 |
| Version | 1.0.0 | `customer_app/pubspec.yaml` سطر 4: `version: 1.0.0+1` |
| Build Number | 1 | نفس السطر: `+1` |

**تطبيق المورد (vendor_app):**

| العنصر | القيمة | الدليل (المسار + السطر) |
|--------|--------|-------------------------|
| Bundle ID | `sa.vendorapp.vendor` | `vendor_app/ios/Runner.xcodeproj/project.pbxproj` سطور 482, 669, 692 |
| Display Name | شيف مطبخ البيت | `vendor_app/ios/Runner/Info.plist` سطور 7-8 |
| Version | 1.0.0 | `vendor_app/pubspec.yaml` سطر 6: `version: 1.0.0+2` |
| Build Number | 2 | نفس السطر: `+2` |

---

### ١.٢ أيقونة التطبيق (App Icons)

**تطبيق العميل — جميع الأحجام موجودة وصالحة:**

```
customer_app/ios/Runner/Assets.xcassets/AppIcon.appiconset/
├── Icon-App-1024x1024@1x.png  → 1.1 MB، PNG 1024×1024 صالح
├── Icon-App-20x20@1x.png ... Icon-App-83.5x83.5@2x.png
└── Contents.json → 23 حجم (iPhone + iPad + Marketing)
```

**الدليل:** `file` على `Icon-App-1024x1024@1x.png` يُرجع: `PNG image data, 1024 x 1024, 8-bit/color RGB`

**تطبيق المورد:** نفس الهيكل (يستخدم `flutter_launcher_icons`).

---

### ١.٣ شاشة الإقلاع (Launch Screen)

**المشكلة الحرجة:**

| الملف | الحجم | الحالة |
|------|-------|--------|
| `LaunchImage.png` | **68 bytes** | ❌ placeholder — غير صالح |
| `LaunchImage@2x.png` | **68 bytes** | ❌ placeholder |
| `LaunchImage@3x.png` | **68 bytes** | ❌ placeholder |

**الدليل:**
```bash
$ ls -la customer_app/ios/Runner/Assets.xcassets/LaunchImage.imageset/
-rw-r--r--  68 Dec  9 23:12 LaunchImage.png
-rw-r--r--  68 Dec  9 23:12 LaunchImage@2x.png
-rw-r--r--  68 Dec  9 23:12 LaunchImage@3x.png
```

**المطلوب:** استبدال هذه الملفات بصور Launch حقيقية (مثلاً 1x: 168×185، 2x: 336×370، 3x: 504×555).

---

### ١.٤ أذونات الخصوصية (Privacy Usage Descriptions)

**تطبيق العميل — ✅ مكتمل:**
- `NSLocationWhenInUseUsageDescription` — سطر 47-48 في `Info.plist`
- `NSLocationAlwaysAndWhenInUseUsageDescription` — سطر 49-50

**تطبيق المورد — ❌ ناقص:**
- يستخدم `image_picker` (الكاميرا والمعرض) — `vendor_app/pubspec.yaml` سطر 23
- **لا يوجد** `NSCameraUsageDescription`
- **لا يوجد** `NSPhotoLibraryUsageDescription`
- **لا يوجد** `NSPhotoLibraryAddUsageDescription`

**الدليل:** `vendor_app/ios/Runner/Info.plist` — لا يحتوي على أي من المفاتيح أعلاه.  
**النتيجة:** Apple سترفض التطبيق إذا طلب الكاميرا/المعرض دون وصف الاستخدام.

---

### ١.٥ التوقيع (Signing)

| التطبيق | DEVELOPMENT_TEAM | الدليل |
|---------|-----------------|--------|
| customer_app | `4V76CT5N9T` | `project.pbxproj` سطور 493, 680, 703 |
| vendor_app | (نفس الفريق) | `project.pbxproj` |

---

## ٢. إثباتات Android (Google Play)

### ٢.١ عدم وجود دعم Android

**الدليل المباشر:**
```bash
$ ls customer_app/
# لا يوجد مجلد android
$ ls vendor_app/
# لا يوجد مجلد android
```

**النتيجة:** كلا التطبيقين **لا يدعمان Android**. لا يوجد:
- `android/app/build.gradle`
- `android/app/src/main/AndroidManifest.xml`
- `android/app/src/main/res/` (أيقونات، شاشة إقلاع)

**لتفعيل Android:** تشغيل `flutter create . --platforms=android` داخل مجلد كل تطبيق، ثم إعداد `applicationId` و `versionCode` وملفات التوقيع.

---

## ٣. إثباتات عامة

### ٣.١ رابط الـ API (Production)

| التطبيق | الرابط الافتراضي | الدليل |
|---------|------------------|--------|
| customer_app | `https://my-order.onrender.com/api` | `lib/core/network/endpoints.dart` سطور 8-12 |
| vendor_app | `https://my-order.onrender.com/api` | `lib/core/config/env.dart` سطر 15 |

---

### ٣.٢ سياسة الخصوصية والشروط

**الحالة:** ❌ غير مُنفّذة

**الدليل:** `customer_app/lib/modules/profile/presentation/screens/settings_screen.dart` سطور 94-108:

```dart
// Terms & Conditions
onTap: () {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.comingSoon), ...),
  );
},
// Privacy Policy
onTap: () {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(l10n.comingSoon), ...),
  );
},
```

**المطلوب لـ App Store Connect:**
- **Privacy Policy URL** — مطلوب إذا جمعت بيانات المستخدم
- **Support URL** — مطلوب
- ربط الروابط في التطبيق (بدلاً من "قريباً")

---

## ٤. قائمة الإجراءات قبل النشر

### إلزامي لـ App Store (iOS)

| # | الإجراء | التطبيق | الأولوية |
|---|---------|---------|----------|
| 1 | إضافة `NSCameraUsageDescription` و `NSPhotoLibraryUsageDescription` في `Info.plist` | vendor_app | عالية |
| 2 | استبدال صور LaunchImage (68 bytes) بصور حقيقية | كلا التطبيقين | عالية |
| 3 | إنشاء ورابط سياسة الخصوصية والشروط | كلا التطبيقين | عالية |

### لإطلاق Google Play (Android)

| # | الإجراء | الأولوية |
|---|---------|----------|
| 1 | إضافة منصة Android: `flutter create . --platforms=android` | عالية |
| 2 | إعداد `applicationId` و `versionCode` في `build.gradle` | عالية |
| 3 | إعداد مفتاح التوقيع (keystore) للإصدار | عالية |
| 4 | أيقونات Android و adaptive icon | متوسطة |
| 5 | شاشة Splash لـ Android 12+ | متوسطة |

---

## ٥. ما هو جاهز فعلياً (إثباتات إيجابية)

| العنصر | الدليل |
|--------|--------|
| Bundle IDs فريدة | `sa.myorder.customer` و `sa.vendorapp.vendor` |
| أسماء العرض العربية | مطبخ البيت، شيف مطبخ البيت |
| أيقونات iOS كاملة | 23 حجم، 1024×1024 صالح |
| أذونات الموقع (customer) | مُعرّفة في Info.plist |
| API Production | `https://my-order.onrender.com/api` |
| التوقيع (Signing) | DEVELOPMENT_TEAM مُعدّ |
| الإصدار | 1.0.0+1 و 1.0.0+2 |

---

## ٦. الخلاصة

**هل التطبيق جاهز للنشر الآن؟**

- **App Store (iOS):** ✅ **جاهز** بعد إصلاحات 28 يناير 2026 (راجع `RELEASE_FIXES_APPLIED.md`).
- **Google Play (Android):** ✅ **مدعوم** — تم إضافة منصة Android لكلا التطبيقين.

**بعد تنفيذ الإجراءات الإلزامية أعلاه، يمكن رفع بناء iOS إلى App Store Connect.**

---

**تحديث 28 يناير 2026:** تم تنفيذ جميع الإصلاحات. راجع `RELEASE_FIXES_APPLIED.md` للتفاصيل.
