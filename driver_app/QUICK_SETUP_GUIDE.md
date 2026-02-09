# دليل سريع: إعداد Android Restrictions
## API Key: `AIzaSyDfZA_yeWps0ACO_ITJvVFwjKQAjofu2ww`

---

## ✅ المعلومات التي تحتاجها (جاهزة!)

### 1. SHA-1 Certificate Fingerprint (Debug)
```
3B:D0:08:CC:55:06:89:02:4C:5C:1F:59:CD:56:04:38:DD:C8:21:1C
```

**✅ هذا هو SHA-1 الخاص بك - انسخه كما هو!**

---

### 2. Package Name (اسم الحزمة)

من الصورة التي أرسلتها، يبدو أن Package Name هو:
```
com.myorder.driver_app
```

**لكن دعني أتحقق من القيمة الكاملة...**

---

## 🔍 كيفية الحصول على Package Name الكامل

### الطريقة 1: من Flutter (الأسهل)
```bash
cd "/Users/fayez/Desktop/my order/driver_app"
flutter build apk --debug 2>&1 | grep -i "package\|applicationId" | head -3
```

### الطريقة 2: إنشاء build.gradle
إذا لم يكن الملف موجوداً، قم بإنشائه:

```bash
cd "/Users/fayez/Desktop/my order/driver_app"
flutter create --platforms=android .
```

ثم افتح:
```
android/app/build.gradle
```

وابحث عن:
```gradle
android {
    ...
    defaultConfig {
        applicationId "com.myorder.driver_app"  // <-- هذا هو Package Name
        ...
    }
}
```

### الطريقة 3: من pubspec.yaml (افتراضي)
إذا لم تجد `applicationId` في `build.gradle`، Flutter يستخدم:
```
com.example.driver_app
```

**لكن يجب تغييره إلى:**
```
com.myorder.driver_app
```

---

## 📝 ما يجب إضافته في Google Cloud Console

### في شاشة "Android restrictions":

1. **Package name**: 
   ```
   com.myorder.driver_app
   ```
   (أو القيمة الكاملة التي تراها في الصورة)

2. **SHA-1 certificate fingerprint**:
   ```
   3B:D0:08:CC:55:06:89:02:4C:5C:1F:59:CD:56:04:38:DD:C8:21:1C
   ```

---

## ✅ التحقق من Package Name

من الصورة التي أرسلتها، Package Name يظهر مختصراً:
```
com.myorder.drive...
```

**القيمة الكاملة على الأرجح هي:**
- `com.myorder.driver_app` ✅ (الأكثر احتمالاً)
- `com.myorder.driverapp` 
- `com.myorder.driver`

**للتحقق:**
1. في Google Cloud Console، اضغط على Package Name الموجود
2. ستظهر القيمة الكاملة
3. أو انسخها من هناك

---

## 🚀 الخطوات النهائية

### إذا كان Package Name موجود بالفعل في Google Cloud Console:

1. ✅ **SHA-1 موجود**: `3B:D0:08:CC:55:06:89:02:4C:5C:1F:59:CD:56:04:38:DD:C8:21:1C`
2. ✅ **Package Name موجود**: (من الصورة: `com.myorder.drive...`)
3. ✅ **API Restrictions مفعلة**: (32 APIs)

**كل شيء جاهز! ✅**

---

## 📋 ملخص المعلومات

| المعلومة | القيمة |
|---------|--------|
| **API Key** | `AIzaSyDfZA_yeWps0ACO_ITJvVFwjKQAjofu2ww` |
| **Package Name** | `com.myorder.driver_app` (تحقق من القيمة الكاملة) |
| **SHA-1 (Debug)** | `3B:D0:08:CC:55:06:89:02:4C:5C:1F:59:CD:56:04:38:DD:C8:21:1C` |
| **SHA-1 (Release)** | (أضفه لاحقاً عند النشر) |

---

## ⚠️ ملاحظة مهمة

من الصورة، يبدو أنك **أضفت المعلومات بالفعل**! ✅

إذا كان كل شيء موجود في Google Cloud Console:
- ✅ Package Name: موجود
- ✅ SHA-1: موجود
- ✅ API Restrictions: مفعلة (32 APIs)

**إذاً أنت جاهز! 🎉**

---

## 🔧 إذا أردت التحقق من Package Name الكامل

في Terminal:
```bash
cd "/Users/fayez/Desktop/my order/driver_app"

# محاولة 1: من build.gradle (إذا كان موجوداً)
grep -r "applicationId" android/app/build.gradle 2>/dev/null

# محاولة 2: إنشاء build.gradle
flutter create --platforms=android .

# محاولة 3: من pubspec.yaml (افتراضي)
# Flutter يستخدم: com.example.driver_app (يجب تغييره)
```

---

**تم إعداد الدليل بواسطة**: AI Code Assistant  
**التاريخ**: 28 يناير 2026
