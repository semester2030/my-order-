# كيفية تشغيل SQL Scripts

## ⚠️ مهم جداً: الطريقة الصحيحة

### الطريقة 1: من Terminal العادي (الأفضل)

```bash
# 1. اخرج من psql إذا كنت داخله
# اضغط Ctrl+D أو اكتب: \q

# 2. من Terminal العادي، شغّل:
psql -d your_database_name -f backend/RESET_TEST_DRIVER_ACCOUNT.sql

# 3. للتحقق:
psql -d your_database_name -f backend/VERIFY_TEST_DRIVER.sql
```

### الطريقة 2: من داخل psql

إذا كنت داخل `psql` بالفعل:

```sql
-- استخدم \i بدلاً من psql
\i backend/RESET_TEST_DRIVER_ACCOUNT.sql

-- للتحقق:
\i backend/VERIFY_TEST_DRIVER.sql
```

## 🔧 استبدال `your_database_name`

استبدل `your_database_name` باسم قاعدة البيانات الفعلي، مثلاً:
- `myorder_db`
- `my_order`
- `customer_app`
- أو أي اسم آخر

مثال:
```bash
psql -d myorder_db -f backend/RESET_TEST_DRIVER_ACCOUNT.sql
```

## 📝 خطوات كاملة

### الخطوة 1: تأكد أنك خارج psql
```bash
# إذا رأيت prompt مثل: customer_app=# أو customer_app-#
# اكتب:
\q
# أو اضغط Ctrl+D
```

### الخطوة 2: اذهب إلى مجلد المشروع
```bash
cd "/Users/fayez/Desktop/my order"
```

### الخطوة 3: شغّل Script إعادة التعيين
```bash
psql -d your_database_name -f backend/RESET_TEST_DRIVER_ACCOUNT.sql
```

### الخطوة 4: شغّل Script التحقق
```bash
psql -d your_database_name -f backend/VERIFY_TEST_DRIVER.sql
```

## ✅ التحقق من النجاح

بعد تشغيل `VERIFY_TEST_DRIVER.sql`، يجب أن ترى:
- ✅ USER CHECK: User موجود مع PIN SET (1234)
- ✅ DRIVER CHECK: Driver موجود مع status = APPROVED
- ✅ LINK CHECK: DRIVER LINKED

## 🚨 إذا ظهرت أخطاء

### خطأ: "database does not exist"
```bash
# ابحث عن اسم قاعدة البيانات الصحيح:
psql -l
# أو
\l
```

### خطأ: "permission denied"
```bash
# تأكد من الصلاحيات أو استخدم:
psql -U postgres -d your_database_name -f backend/RESET_TEST_DRIVER_ACCOUNT.sql
```

### خطأ: "could not connect to server"
```bash
# تأكد أن PostgreSQL يعمل:
# macOS:
brew services list | grep postgresql

# أو ابدأ PostgreSQL:
brew services start postgresql
```
