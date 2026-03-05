# تشغيل الطلب المسبق على Render — خطوة بخطوة

## الخطوة ١: رفع الكود إلى Git

```bash
cd "/Users/fayez/Desktop/my order"
git add .
git status   # راجع الملفات المضافة
git commit -m "Add scheduled order feature"
git push origin main
```

بعد الـ push، Render يعيد النشر تلقائياً (إن كان المشروع مربوطاً بـ GitHub).

---

## الخطوة ٢: تشغيل الـ SQL على قاعدة بيانات Render

### الطريقة أ: من جهازك باستخدام psql

1. ادخل إلى [Render Dashboard](https://dashboard.render.com)
2. اختر **PostgreSQL** (قاعدة البيانات)
3. انسخ **External Database URL** (رابط الاتصال الخارجي)

4. من الطرفية على جهازك:

```bash
cd "/Users/fayez/Desktop/my order/backend"
psql "الصق_رابط_External_Database_URL_هنا" -f src/migrations/manual-add-scheduled-order-columns.sql
```

**مثال** (لا تستخدمه — استبدله برابطك):
```bash
psql "postgresql://user:pass@dpg-xxxxx-a.oregon-postgres.render.com/mydb?sslmode=require" -f src/migrations/manual-add-scheduled-order-columns.sql
```

---

### الطريقة ب: من واجهة Render (Shell)

1. من Render Dashboard → اختر **Web Service** (الباك اند)
2. اضغط **Shell** (أعلى الصفحة)
3. في الـ Shell اكتب:

```bash
# الاتصال بقاعدة البيانات وتشغيل الـ SQL
# (يحتاج أن يكون psql متوفراً — قد لا يكون في Shell الـ Web Service)
```

**ملاحظة:** Shell الـ Web Service قد لا يحتوي على `psql`. استخدم الطريقة أ أو ج.

---

### الطريقة ج: من pgAdmin أو TablePlus

1. انسخ **External Database URL** من Render
2. افتح pgAdmin أو TablePlus
3. أنشئ اتصالاً جديداً باستخدام الرابط
4. افتح **Query Tool** وانسخ والصق محتوى الملف التالي ثم نفّذ:

```sql
ALTER TABLE "orders" ADD COLUMN IF NOT EXISTS "requested_ready_at" timestamp with time zone;
ALTER TABLE "orders" ADD COLUMN IF NOT EXISTS "order_type" character varying DEFAULT 'ready_now';
ALTER TABLE "vendors" ADD COLUMN IF NOT EXISTS "min_preparation_minutes" integer;
```

---

## التحقق من النجاح

بعد تشغيل الـ SQL:

1. تأكد أن الـ Deploy على Render اكتمل (من لوحة الخدمة)
2. جرّب إنشاء طلب مسبق من التطبيق (مع ربط التطبيق بـ Render)
3. تحقق أن الطباخ يرى "مطلوب الساعة X:XX" في الطلبات
