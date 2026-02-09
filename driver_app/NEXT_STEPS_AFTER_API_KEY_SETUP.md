# الخطوات التالية بعد إعداد API Key
## API Key: `AIzaSyDfZA_yeWps0ACO_ITJvVFwjKQAjofu2ww`

---

## ✅ ما تم إنجازه

1. ✅ **API Key تم إضافته** في `Info.plist` (iOS)
2. ✅ **API Key تم إضافته** في `AndroidManifest.xml` (Android)
3. ✅ **Android Restrictions تم إعدادها** في Google Cloud Console
   - Package Name: `com.myorder.driver_app`
   - SHA-1: `3B:D0:08:CC:55:06:89:02:4C:5C:1F:59:CD:56:04:38:DD:C8:21:1C`

---

## 📋 الخطوات التالية (يجب إكمالها)

### 1. ✅ تفعيل Google Maps APIs المطلوبة 🔴 حرج

**يجب تفعيل هذه APIs في Google Cloud Console:**

#### APIs الأساسية (يجب تفعيلها فوراً):

1. ✅ **Maps SDK for Android**
   ```
   Google Cloud Console > APIs & Services > Library
   ابحث عن: "Maps SDK for Android"
   اضغط: Enable
   ```

2. ✅ **Maps SDK for iOS**
   ```
   Google Cloud Console > APIs & Services > Library
   ابحث عن: "Maps SDK for iOS"
   اضغط: Enable
   ```

3. ✅ **Directions API** 🔴 حرج جداً
   ```
   Google Cloud Console > APIs & Services > Library
   ابحث عن: "Directions API"
   اضغط: Enable
   ```

4. ✅ **Geocoding API** 🟡 مهم
   ```
   Google Cloud Console > APIs & Services > Library
   ابحث عن: "Geocoding API"
   اضغط: Enable
   ```

#### APIs الموصى بها (اختياري):

5. 🟡 **Places API** (إذا أردنا معلومات تفصيلية عن الأماكن)
6. 🟡 **Distance Matrix API** (إذا أردنا تحسين التوزيع)

---

### 2. ✅ إعداد iOS Restrictions 🟡 مهم

**يجب إضافة iOS Bundle Identifier أيضاً:**

#### كيفية الحصول على Bundle Identifier:

**الطريقة 1: من Info.plist**
```
1. افتح: driver_app/ios/Runner/Info.plist
2. ابحث عن: CFBundleIdentifier
3. انسخ القيمة (مثلاً: com.myorder.driverapp)
```

**الطريقة 2: من Xcode**
```
1. افتح المشروع في Xcode
2. اختر Target: Runner
3. اذهب إلى: General > Bundle Identifier
4. انسخ القيمة
```

#### إضافة iOS Restrictions في Google Cloud Console:

```
1. اذهب إلى: APIs & Services > Credentials
2. اضغط على API Key: AIzaSyDfZA_yeWps0ACO_ITJvVFwjKQAjofu2ww
3. في "Application restrictions":
   - اختر: iOS apps
   - اضغط: "Add iOS app"
   - Bundle ID: الصق Bundle Identifier
4. اضغط: "Done"
```

---

### 3. ✅ تطبيق API Restrictions (مهم للأمان)

**تأكد من أن API Restrictions مفعلة:**

```
1. في نفس صفحة API Key
2. في "API restrictions":
   - تأكد من اختيار: "Restrict key"
   - تأكد من تفعيل APIs التالية فقط:
     ✅ Maps SDK for Android
     ✅ Maps SDK for iOS
     ✅ Directions API
     ✅ Geocoding API
     (و أي APIs أخرى تريدها)
3. اضغط: "Save"
```

**⚠️ مهم**: لا تترك "Don't restrict key" مفعل - هذا خطر أمني!

---

### 4. ✅ اختبار التطبيق

#### اختبار على Android:

```bash
cd "/Users/fayez/Desktop/my order/driver_app"
flutter run
```

**ما يجب التحقق منه:**
- ✅ التطبيق يعمل بدون أخطاء
- ✅ الخرائط تظهر (إذا كان هناك Delivery Map View)
- ✅ لا توجد أخطاء في Console عن API Key

#### اختبار على iOS:

```bash
cd "/Users/fayez/Desktop/my order/driver_app"
flutter run -d ios
```

**ما يجب التحقق منه:**
- ✅ التطبيق يعمل بدون أخطاء
- ✅ الخرائط تظهر (إذا كان هناك Delivery Map View)
- ✅ لا توجد أخطاء في Console عن API Key

---

### 5. ✅ مراقبة الاستخدام (اختياري لكن موصى به)

#### إعداد Billing Alerts:

```
1. اذهب إلى: Billing > Budgets & alerts
2. أنشئ Budget جديد
3. حدد ميزانية شهرية (مثلاً: $500)
4. فعّل تنبيهات عند:
   - 50% من الميزانية
   - 75% من الميزانية
   - 90% من الميزانية
```

#### مراقبة API Usage:

```
1. اذهب إلى: APIs & Services > Dashboard
2. راقب الاستخدام اليومي
3. تحقق من أي APIs تستخدم أكثر
```

---

## 📊 قائمة التحقق (Checklist)

### APIs (يجب تفعيلها):
- [ ] Maps SDK for Android
- [ ] Maps SDK for iOS
- [ ] Directions API
- [ ] Geocoding API
- [ ] Places API (اختياري)
- [ ] Distance Matrix API (اختياري)

### Restrictions (يجب إعدادها):
- [x] Android Restrictions (تم ✅)
- [ ] iOS Restrictions (يجب إضافتها)
- [ ] API Restrictions (تأكد من تفعيلها)

### Testing (يجب اختباره):
- [ ] اختبار على Android
- [ ] اختبار على iOS
- [ ] التحقق من عمل الخرائط

### Monitoring (موصى به):
- [ ] إعداد Billing Alerts
- [ ] مراقبة API Usage

---

## 🚀 الخطوات السريعة (Quick Steps)

### الآن (فوراً):
1. ✅ **تفعيل APIs** في Google Cloud Console (4 APIs أساسية)
2. ✅ **إضافة iOS Restrictions** (Bundle Identifier)
3. ✅ **تطبيق API Restrictions** (تأكد من تفعيلها)

### بعد ذلك:
4. ✅ **اختبار التطبيق** على Android و iOS
5. ✅ **مراقبة الاستخدام** (اختياري)

---

## ⚠️ ملاحظات مهمة

### 1. الأمان
- ✅ **لا تشارك API Key**: لا تضع API Key في GitHub أو أي مكان عام
- ✅ **استخدم Restrictions**: تأكد من تفعيل Application و API Restrictions
- ✅ **راقب الاستخدام**: راقب الاستخدام بانتظام

### 2. التكلفة
- **التكلفة المتوقعة**: ~$154-350/شهر (بعد الحدود المجانية)
- **الحدود المجانية**:
  - Maps SDK: أول 28,000 طلب/شهر مجاني
  - Directions API: أول 40,000 طلب/شهر مجاني
  - Geocoding API: أول 40,000 طلب/شهر مجاني

### 3. Release Certificate
- **Debug SHA-1**: تم إضافته ✅
- **Release SHA-1**: أضفه لاحقاً عند النشر على Google Play

---

## 📝 ملخص سريع

**ما تم إنجازه:**
- ✅ API Key في التطبيق
- ✅ Android Restrictions

**ما يجب إنجازه الآن:**
1. ✅ تفعيل 4 APIs أساسية
2. ✅ إضافة iOS Restrictions
3. ✅ تطبيق API Restrictions
4. ✅ اختبار التطبيق

---

**تم إعداد الدليل بواسطة**: AI Code Assistant  
**التاريخ**: 28 يناير 2026
