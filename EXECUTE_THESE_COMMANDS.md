# 🚀 نفذ هذه الأوامر في Terminal الخاص بك

## ✅ الوضع الحالي:

- ✅ PostgreSQL يعمل (أنت أكدت)
- ✅ جميع الملفات جاهزة
- ⚠️ مشكلة صلاحيات تمنعني من إنشاء قاعدة البيانات
- ⚠️ تحتاج تنفيذ الأوامر يدوياً

---

## 📋 الأوامر (نسخ ولصق بالترتيب):

### 1. إنشاء قاعدة البيانات

```bash
createdb customer_app
```

**التحقق:**
```bash
psql -l | grep customer_app
```

---

### 2. الانتقال لمجلد المشروع

```bash
cd "/Users/fayez/Desktop/my order/backend"
```

---

### 3. توليد Migration

```bash
npm run migration:generate -- src/migrations/InitialMigration
```

**النتيجة المتوقعة:**
```
Migration src/migrations/InitialMigration[timestamp].ts has been generated successfully.
```

---

### 4. تشغيل Migration

```bash
npm run migration:run
```

**النتيجة المتوقعة:**
```
Migration InitialMigration[timestamp] has been executed successfully.
```

---

## 📋 جميع الأوامر معاً (نسخ ولصق):

```bash
# 1. إنشاء قاعدة البيانات
createdb customer_app

# 2. التحقق
psql -l | grep customer_app

# 3. الانتقال لمجلد المشروع
cd "/Users/fayez/Desktop/my order/backend"

# 4. توليد Migration
npm run migration:generate -- src/migrations/InitialMigration

# 5. تشغيل Migration
npm run migration:run
```

---

## ✅ بعد التنفيذ:

**أرسل لي:**
1. مخرجات كل أمر
2. أي أخطاء إن ظهرت
3. تأكيد أن Migration تم بنجاح

**وسأكمل باقي الخطوات!**

---

## 📝 ملاحظات:

- جميع الملفات جاهزة (`.env`, `data-source.ts`, etc.)
- فقط تحتاج تنفيذ الأوامر
- PostgreSQL يعمل ✅
- المشروع جاهز ✅
