# إعادة تشغيل PostgreSQL

## ⚠️ المشكلة:

PostgreSQL توقف عن العمل. هذا يفسر لماذا Migration generate يستغرق وقتاً طويلاً - يحاول الاتصال لكن لا يجد الخادم.

---

## ✅ الحل:

### إعادة تشغيل PostgreSQL:

```bash
brew services start postgresql@14
```

### التحقق:

```bash
pg_isready
```

**النتيجة المتوقعة:**
```
/tmp:5432 - accepting connections
```

---

## 🚀 بعد إعادة التشغيل:

### 1. تحقق من الاتصال:

```bash
psql -d customer_app -c "SELECT 1;"
```

### 2. أعد محاولة Migration:

```bash
cd "/Users/fayez/Desktop/my order/backend"
npm run migration:generate -- src/migrations/InitialMigration
```

**الآن يجب أن يعمل بسرعة (20-60 ثانية)**

---

## 📝 ملاحظة:

إذا توقف PostgreSQL مرة أخرى، يمكنك:
- إضافته كـ service تلقائي: `brew services start postgresql@14`
- أو تشغيله يدوياً كل مرة تحتاجه
