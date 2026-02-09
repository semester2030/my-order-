# الخطوات المتبقية - تنفيذ يدوي

## ✅ ما تم إنجازه:

- ✅ PostgreSQL يعمل (`pg_isready` يعمل)
- ✅ ملف `.env` جاهز
- ✅ ملف `src/data-source.ts` جاهز
- ✅ `package.json` scripts محدثة
- ✅ مجلد `src/migrations/` موجود

---

## 🚀 الخطوات المتبقية (نفذها في Terminal):

### الخطوة 1: إنشاء قاعدة البيانات

```bash
createdb customer_app
```

**أو:**

```bash
psql -U postgres -c "CREATE DATABASE customer_app;"
```

**التحقق:**
```bash
psql -l | grep customer_app
```

---

### الخطوة 2: توليد Migration

```bash
cd "/Users/fayez/Desktop/my order/backend"
npm run migration:generate -- src/migrations/InitialMigration
```

**النتيجة المتوقعة:**
```
Migration src/migrations/InitialMigration[timestamp].ts has been generated successfully.
```

---

### الخطوة 3: تشغيل Migration

```bash
npm run migration:run
```

**النتيجة المتوقعة:**
```
Migration InitialMigration[timestamp] has been executed successfully.
```

---

## 📋 الأوامر الكاملة (نسخ ولصق):

```bash
# 1. إنشاء قاعدة البيانات
createdb customer_app

# 2. التحقق
psql -l | grep customer_app

# 3. توليد Migration
cd "/Users/fayez/Desktop/my order/backend"
npm run migration:generate -- src/migrations/InitialMigration

# 4. تشغيل Migration
npm run migration:run
```

---

## ⚠️ إذا ظهرت أخطاء:

### خطأ: "database already exists"
```bash
# قاعدة البيانات موجودة - جاهز للمتابعة
```

### خطأ: "connection refused"
```bash
# تأكد أن PostgreSQL يعمل
pg_isready
```

### خطأ: "permission denied"
```bash
# استخدم sudo (إذا لزم)
sudo -u postgres createdb customer_app
```

---

## ✅ بعد إتمام الخطوات:

**أرسل لي:**
1. مخرجات `npm run migration:generate`
2. مخرجات `npm run migration:run`
3. أي أخطاء إن ظهرت

**وسأكمل باقي الخطوات!**
