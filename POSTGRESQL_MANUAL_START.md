# ⚠️ تشغيل PostgreSQL يدوياً

## المشكلة:
PostgreSQL غير مشغل حالياً. يجب تشغيله يدوياً.

---

## ✅ الحل السريع:

### الطريقة 1: عبر Terminal (الأسهل)

```bash
# افتح Terminal جديد واكتب:
pg_ctl -D /opt/homebrew/var/postgresql@14 start

# أو
brew services start postgresql@14
```

### الطريقة 2: عبر System Preferences

1. افتح **System Preferences**
2. ابحث عن **PostgreSQL**
3. اضغط **Start**

### الطريقة 3: عبر pgAdmin (إن كان مثبت)

1. افتح **pgAdmin**
2. اضغط **Start Server**

---

## ✅ بعد تشغيل PostgreSQL:

### 1. التحقق:
```bash
pg_isready
```

**النتيجة المتوقعة:**
```
/var/run/postgresql:5432 - accepting connections
```

### 2. إنشاء قاعدة البيانات:
```bash
createdb customer_app
```

### 3. التحقق من قاعدة البيانات:
```bash
psql -l | grep customer_app
```

---

## 🚀 بعد ذلك:

```bash
cd "/Users/fayez/Desktop/my order/backend"
npm run migration:generate -- src/migrations/InitialMigration
npm run migration:run
```

---

## 📝 ملاحظة:

**جميع الملفات جاهزة:**
- ✅ `.env` - جاهز
- ✅ `data-source.ts` - جاهز
- ✅ `package.json` scripts - جاهزة

**فقط يحتاج:** تشغيل PostgreSQL وإنشاء قاعدة البيانات
