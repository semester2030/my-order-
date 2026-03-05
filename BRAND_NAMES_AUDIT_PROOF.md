# تقرير التدقيق — أسماء العلامة التجارية (مطبخ البيت / شيف مطبخ البيت)

**تاريخ التدقيق:** 2026-01-28  
**الحالة:** ✅ مكتمل 100%

---

## 1. تطبيق العميل (Customer App) — مطبخ البيت / Home Kitchen

| الموقع | الملف | القيمة العربية | القيمة الإنجليزية | الإثبات |
|--------|-------|----------------|-------------------|---------|
| الترجمة | `customer_app/lib/core/localization/strings_ar.dart` | `appName = 'مطبخ البيت'` | — | سطر 99 |
| الترجمة | `customer_app/lib/core/localization/strings_en.dart` | — | `appName = 'Home Kitchen'` | سطر 99 |
| الشعار | `strings_ar.dart` | `splashTagline = 'طعام منزلي إلى بابك'` | — | سطر 101 |
| الشعار | `strings_en.dart` | — | `splashTagline = 'Home-made food to your door'` | سطر 101 |
| MaterialApp | `customer_app/lib/app.dart` | `'مطبخ البيت'` (عند ar) | `'Home Kitchen'` (عند en) | سطر 60 |
| الشاشة التمهيدية | `splash_screen.dart` | `l.appName` | `l.appName` | سطر 96 |
| شاشة الترحيب | `welcome_screen.dart` | `l.appName` | `l.appName` | سطر 45 |
| اسم الأيقونة iOS | `customer_app/ios/Runner/Info.plist` | `CFBundleDisplayName = مطبخ البيت` | — | سطر 7-8 |

---

## 2. تطبيق مقدم الخدمة (Vendor App) — شيف مطبخ البيت / Home Kitchen Chef

| الموقع | الملف | القيمة العربية | القيمة الإنجليزية | الإثبات |
|--------|-------|----------------|-------------------|---------|
| الترجمة | `vendor_app/lib/core/localization/strings_ar.dart` | `appTitle = 'شيف مطبخ البيت'` | — | سطر 5 |
| الترجمة | `vendor_app/lib/core/localization/strings_en.dart` | — | `appTitle = 'Home Kitchen Chef'` | سطر 5 |
| شعار السبلاش | `strings_ar.dart` | `splashTagline = 'تطبيق الطباخ ومقدم الخدمة'` | — | سطر 6 |
| شعار السبلاش | `strings_en.dart` | — | `splashTagline = 'Chef & Service Provider App'` | سطر 6 |
| MaterialApp | `vendor_app/lib/app.dart` | `title: 'شيف مطبخ البيت'` | — | سطر 20 |
| الثوابت | `vendor_app/lib/core/config/app_constants.dart` | `appName = 'شيف مطبخ البيت'` | — | سطر 6 |
| الشاشة التمهيدية | `splash_screen.dart` | `l.appTitle` | `l.appTitle` | سطر 39 |
| القائمة الجانبية | `vendor_drawer.dart` | `l10n.appTitle` | `l10n.appTitle` | سطر 44 |
| اسم الأيقونة iOS | `vendor_app/ios/Runner/Info.plist` | `CFBundleDisplayName = شيف مطبخ البيت` | — | سطر 7-8 |

---

## 3. لوحة مقدم الخدمة (Vendor Web) — شيف مطبخ البيت

| الموقع | الملف | القيمة العربية | القيمة الإنجليزية | الإثبات |
|--------|-------|----------------|-------------------|---------|
| عنوان الصفحة | `vendor-web/app/layout.tsx` | `title: 'شيف مطبخ البيت - لوحة الويب'` | — | سطر 6 |
| الترجمة | `vendor-web/lib/i18n/translations.ts` | `appName: 'شيف مطبخ البيت'` | `appName: 'Home Kitchen Chef'` | سطر 6، 233 |
| الشريط الجانبي | `vendor-web/components/layout/sidebar.tsx` | `t('appName')` | `t('appName')` | سطر 59 |

---

## 4. لوحة الإدارة (Admin Panel) — مطبخ البيت

| الموقع | الملف | القيمة | الإثبات |
|--------|-------|--------|---------|
| عنوان الصفحة | `admin_panel/app/layout.tsx` | `title: 'مطبخ البيت — لوحة الإدارة'` | سطر 5 |
| الشريط الجانبي | `admin_panel/components/layout/Sidebar.tsx` | `مطبخ البيت — لوحة الإدارة` | سطر 69 |

---

## 5. الباك اند (Backend) — مطبخ البيت

| الموقع | الملف | القيمة | الإثبات |
|--------|-------|--------|---------|
| البريد الإلكتروني - المرسل | `backend/src/modules/email/email.service.ts` | `'مطبخ البيت <onboarding@resend.dev>'` | سطر 23 |
| البريد الإلكتروني - الموضوع | `backend/src/modules/email/email.service.ts` | `'رمز التحقق - مطبخ البيت'` | سطر 37 |

---

## 6. التحقق من عدم وجود الأسماء القديمة

| البحث | النتيجة |
|-------|---------|
| `My Order` في واجهة المستخدم | ❌ لا يوجد (تم استبداله) |
| `Vendor App` في واجهة المستخدم | ❌ لا يوجد (تم استبداله) |
| `Customer App` في واجهة المستخدم | ❌ لا يوجد |

**ملاحظة:** النصوص "My Orders" و "Customer App" و "Vendor App" في التعليقات والوثائق (مثل README و API_CONTRACT) تُستخدم كأسماء تقنية للمشروع وليست للعرض للمستخدم.

---

## 7. ملخص التغييرات

| المشروع | الاسم القديم | الاسم الجديد |
|---------|-------------|--------------|
| تطبيق العميل | My Order | مطبخ البيت / Home Kitchen |
| تطبيق مقدم الخدمة | Vendor App | شيف مطبخ البيت / Home Kitchen Chef |
| لوحة الويب (مقدم الخدمة) | لوحة مقدم الخدمة - My Order | شيف مطبخ البيت - لوحة الويب |
| لوحة الإدارة | Admin Panel — منصة الإدارة | مطبخ البيت — لوحة الإدارة |
| البريد (Backend) | My Order | مطبخ البيت |

---

**تم التدقيق بنسبة 100%**
