# ✅ تطبيق Enums يدوياً (بدون migration:run)

**التاريخ:** 25 يناير 2026  
**الحالة:** ✅ **ملف SQL جاهز للتطبيق**

---

## 🎯 **المشكلة:**

TypeORM يبحث عن Enums غير موجودة في قاعدة البيانات:
- `vendor_status_enum`
- `verification_status_enum`
- `certificate_type_enum`
- `staff_role_enum`

---

## ✅ **الحل:**

### **الطريقة 1: تشغيل SQL مباشرة (الأسهل)**

```bash
cd "/Users/fayez/Desktop/my order/backend"
psql -d customer_app -f src/migrations/create-enums.sql
```

**أو:**

```bash
psql -U postgres -d customer_app -f "/Users/fayez/Desktop/my order/backend/src/migrations/create-enums.sql"
```

---

### **الطريقة 2: نسخ ولصق SQL مباشرة في psql**

```bash
psql -d customer_app
```

ثم انسخ والصق:

```sql
-- Vendor Status Enum
DO $$ BEGIN
    CREATE TYPE vendor_status_enum AS ENUM('pending_approval', 'under_review', 'approved', 'rejected', 'suspended');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Verification Status Enum
DO $$ BEGIN
    CREATE TYPE verification_status_enum AS ENUM('pending', 'verified', 'rejected', 'expired');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Certificate Type Enum
DO $$ BEGIN
    CREATE TYPE certificate_type_enum AS ENUM('health', 'municipal', 'food_safety', 'other');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Staff Role Enum
DO $$ BEGIN
    CREATE TYPE staff_role_enum AS ENUM('owner', 'manager', 'chef', 'waiter', 'cashier', 'viewer');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;
```

---

## 🔄 **بعد تطبيق Enums:**

1. **أعد تشغيل التطبيق:**
   ```bash
   npm run start:dev
   ```

2. **TypeORM سينشئ الجداول والأعمدة تلقائياً** (synchronize: true)

---

## ✅ **النتيجة المتوقعة:**

بعد تطبيق Enums:
- ✅ TypeORM سيجد Enums
- ✅ سينشئ الجداول الجديدة (`vendor_certificates`, `vendor_staff`)
- ✅ سيضيف الأعمدة الجديدة لجدول `vendors`
- ✅ التطبيق سيعمل بدون أخطاء

---

**التاريخ:** 25 يناير 2026  
**الحالة:** ✅ **SQL FILE READY - APPLY MANUALLY**
