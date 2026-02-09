# كيفية الحصول على معلومات Android Restrictions
## API Key: `AIzaSyDfZA_yeWps0ACO_ITJvVFwjKQAjofu2ww`

---

## 📋 ما تحتاج إضافته في Google Cloud Console

في شاشة **Application restrictions** > **Android apps**، تحتاج إضافة:

1. ✅ **Package name** (اسم الحزمة)
2. ✅ **SHA-1 certificate fingerprint** (بصمة الشهادة)

---

## 1️⃣ Package Name (اسم الحزمة)

### من أين تحصل عليه؟

#### الطريقة 1: من ملف `build.gradle`
```
1. افتح الملف: driver_app/android/app/build.gradle
2. ابحث عن السطر: applicationId
3. انسخ القيمة الموجودة
```

#### الطريقة 2: من AndroidManifest.xml
```
1. افتح الملف: driver_app/android/app/src/main/AndroidManifest.xml
2. ابحث عن: package="..."
3. انسخ القيمة الموجودة
```

### مثال:
```gradle
applicationId "com.myorder.driverapp"
```

**هذه القيمة هي التي ستضعها في حقل "Package name" في Google Cloud Console.**

---

## 2️⃣ SHA-1 Certificate Fingerprint (بصمة الشهادة)

### هناك نوعان من الشهادات:

#### A. Debug Certificate (للتطوير والاختبار) 🔴 مهم للتطوير

**من أين تحصل عليه؟**

##### على macOS أو Linux:
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

##### على Windows:
```cmd
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

**ماذا تفعل:**
1. افتح Terminal (macOS/Linux) أو Command Prompt (Windows)
2. انسخ الأمر أعلاه والصقه
3. اضغط Enter
4. ابحث عن السطر: `SHA1: XX:XX:XX:XX:...`
5. انسخ القيمة الكاملة (مثلاً: `A1:B2:C3:D4:E5:F6:...`)

**مثال على المخرجات:**
```
Certificate fingerprints:
     SHA1: A1:B2:C3:D4:E5:F6:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB
     SHA256: ...
```

**انسخ القيمة بعد `SHA1:` (A1:B2:C3:...)**

---

#### B. Release Certificate (للإصدار النهائي) 🟡 مهم للنشر

**ملاحظة**: إذا لم تكن قد أنشأت Release keystore بعد، يمكنك تخطي هذا الآن وإضافته لاحقاً.

**من أين تحصل عليه؟**

##### إذا كان لديك Release keystore:
```bash
keytool -list -v -keystore /path/to/your/release.keystore -alias your_alias_name
```

**مثال:**
```bash
keytool -list -v -keystore ~/Documents/my-release-key.keystore -alias my-key-alias
```

**ماذا تفعل:**
1. استبدل `/path/to/your/release.keystore` بمسار ملف keystore الخاص بك
2. استبدل `your_alias_name` باسم الـ alias الذي استخدمته عند إنشاء الـ keystore
3. سيطلب منك كلمة المرور (التي وضعتها عند إنشاء الـ keystore)
4. ابحث عن `SHA1: XX:XX:XX:...` وانسخ القيمة

---

## 📝 خطوات إضافة القيود في Google Cloud Console

### الخطوة 1: الحصول على Package Name
```
1. افتح: driver_app/android/app/build.gradle
2. ابحث عن: applicationId
3. انسخ القيمة (مثلاً: com.myorder.driverapp)
```

### الخطوة 2: الحصول على Debug SHA-1
```bash
# على macOS/Linux:
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# على Windows:
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android
```

### الخطوة 3: إضافة القيود في Google Cloud Console
```
1. اذهب إلى: APIs & Services > Credentials
2. اضغط على API Key: AIzaSyDfZA_yeWps0ACO_ITJvVFwjKQAjofu2ww
3. في "Application restrictions":
   - اختر: Android apps
   - اضغط: "Add Android app"
   - Package name: الصق Package Name من build.gradle
   - SHA-1 certificate fingerprint: الصق SHA-1 من keytool
4. اضغط: "Done"
```

---

## ⚠️ ملاحظات مهمة

### 1. Debug vs Release
- ✅ **Debug SHA-1**: استخدمه للتطوير والاختبار (الآن)
- ✅ **Release SHA-1**: أضفه لاحقاً عند النشر على Google Play

### 2. يمكن إضافة أكثر من SHA-1
- يمكنك إضافة Debug SHA-1 و Release SHA-1 في نفس الوقت
- كلاهما سيعمل مع نفس API Key

### 3. إذا لم تجد applicationId في build.gradle
- ابحث في `AndroidManifest.xml` عن `package="..."`
- أو أنشئ applicationId جديد في `build.gradle`

---

## 🔍 التحقق من Package Name

دعني أتحقق من Package Name في مشروعك:

```bash
# في Terminal، من مجلد driver_app:
grep -r "applicationId" android/app/build.gradle
```

أو افتح الملف مباشرة:
```
driver_app/android/app/build.gradle
```

---

## ✅ مثال كامل

لنفترض أن Package Name هو `com.myorder.driverapp` و SHA-1 هو `A1:B2:C3:D4:E5:F6:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB`

**في Google Cloud Console:**
```
Application restrictions: Android apps
  └─ Add Android app
      ├─ Package name: com.myorder.driverapp
      └─ SHA-1 certificate fingerprint: A1:B2:C3:D4:E5:F6:12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB
```

---

## 🚀 الخطوات السريعة

1. ✅ افتح `driver_app/android/app/build.gradle` وابحث عن `applicationId`
2. ✅ شغل أمر `keytool` للحصول على Debug SHA-1
3. ✅ اذهب إلى Google Cloud Console > Credentials > API Key
4. ✅ أضف Package Name و SHA-1
5. ✅ احفظ التغييرات

---

**تم إعداد الدليل بواسطة**: AI Code Assistant  
**التاريخ**: 28 يناير 2026
