# دليل إعداد PostgreSQL وإنشاء Migration

## 📋 الإجابة على أسئلتك:

### 1. ما هو الأمر بالضبط؟

**الأمر:**
```bash
npm run migration:generate -- src/migrations/InitialMigration
```

**ما يفعله:**
- ✅ يقرأ جميع Entities (User, Address, Vendor, etc.)
- ✅ يتصل بقاعدة البيانات PostgreSQL
- ✅ يقارن Entities مع الجداول الموجودة
- ✅ ينشئ ملف Migration يحتوي على SQL لإنشاء الجداول

**النتيجة:**
- ملف جديد في `src/migrations/InitialMigration[timestamp].ts`
- يحتوي على `up()` لإنشاء الجداول
- يحتوي على `down()` لحذف الجداول

---

### 2. هل هذا الأمر يطول؟

**الوقت الطبيعي:** 2-10 ثوانٍ ⚡

**لكن قد يطول إذا:**
- ❌ PostgreSQL غير مشغل → **يتوقف أو يعطي خطأ**
- ❌ قاعدة البيانات غير موجودة → **يعطي خطأ**
- ❌ بيانات الاتصال خاطئة → **يعطي خطأ**

**من الصورة:** يبدو أن الأمر في انتظار الاتصال بقاعدة البيانات

---

## ✅ الخطوات الصحيحة (ابدأ من هنا):

### الخطوة 1: تشغيل PostgreSQL

**الطريقة 1: عبر Terminal**
```bash
# ابحث عن مسار PostgreSQL
which psql

# عادة يكون في:
/opt/homebrew/bin/postgres -D /opt/homebrew/var/postgres

# أو
pg_ctl -D /usr/local/var/postgres start
```

**الطريقة 2: عبر System Preferences**
1. افتح System Preferences
2. ابحث عن PostgreSQL
3. شغّل Service

**الطريقة 3: عبر pgAdmin (إن كان مثبت)**
- افتح pgAdmin
- شغّل Server

---

### الخطوة 2: التحقق من أن PostgreSQL يعمل

```bash
pg_isready
```

**النتيجة المتوقعة:**
```
/var/run/postgresql:5432 - accepting connections
```

---

### الخطوة 3: إنشاء قاعدة البيانات

```bash
# الطريقة 1: عبر createdb
createdb customer_app

# الطريقة 2: عبر psql
psql -U postgres -c "CREATE DATABASE customer_app;"

# الطريقة 3: عبر psql interactive
psql -U postgres
CREATE DATABASE customer_app;
\q
```

---

### الخطوة 4: تحديث ملف `.env`

افتح `backend/.env` وتأكد من:

```env
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=postgres
DATABASE_PASSWORD=your_actual_password
DATABASE_NAME=customer_app
```

**⚠️ مهم:** استبدل `your_actual_password` بكلمة المرور الصحيحة

---

### الخطوة 5: إنشاء Migration

```bash
cd backend
npm run migration:generate -- src/migrations/InitialMigration
```

**الوقت المتوقع:** 2-10 ثوانٍ ⚡

**النتيجة المتوقعة:**
```
Migration src/migrations/InitialMigration1234567890.ts has been generated successfully.
```

---

### الخطوة 6: تشغيل Migration

```bash
npm run migration:run
```

**النتيجة المتوقعة:**
```
Migration InitialMigration1234567890 has been executed successfully.
```

---

## 🔍 استكشاف الأخطاء:

### خطأ: "connection refused"
**السبب:** PostgreSQL غير مشغل
**الحل:** شغّل PostgreSQL (الخطوة 1)

### خطأ: "database does not exist"
**السبب:** قاعدة البيانات غير موجودة
**الحل:** أنشئ قاعدة البيانات (الخطوة 3)

### خطأ: "password authentication failed"
**السبب:** كلمة المرور خاطئة
**الحل:** حدّث `.env` بكلمة المرور الصحيحة

### خطأ: "permission denied"
**السبب:** المستخدم ليس لديه صلاحيات
**الحل:** استخدم `postgres` user أو أنشئ user جديد

---

## 📊 الخلاصة:

| السؤال | الجواب |
|--------|--------|
| **ما هو الأمر؟** | إنشاء ملف Migration لإنشاء جداول قاعدة البيانات |
| **هل يطول؟** | لا، عادة 2-10 ثوانٍ |
| **المشكلة الحالية؟** | PostgreSQL غير مشغل |
| **الحل؟** | شغّل PostgreSQL أولاً (الخطوة 1) |

---

## 🎯 الخطوات السريعة:

```bash
# 1. شغّل PostgreSQL
pg_ctl -D /opt/homebrew/var/postgres start

# 2. أنشئ قاعدة البيانات
createdb customer_app

# 3. أنشئ Migration
cd backend
npm run migration:generate -- src/migrations/InitialMigration

# 4. شغّل Migration
npm run migration:run
```

---

## ⚠️ ملاحظة مهمة:

**الأمر يحتاج:**
1. ✅ PostgreSQL مشغل
2. ✅ قاعدة البيانات موجودة
3. ✅ بيانات الاتصال صحيحة

**بدون هذه المتطلبات، الأمر لن يعمل!**
