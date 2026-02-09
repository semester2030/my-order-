# ⚡ حل مشكلة الحساب التجريبي - خطوات سريعة

## 🔴 المشكلة

الحساب التجريبي للسائق:
- **Status**: `pending` ❌ (يجب أن يكون `approved`)
- **Full Name**: `N/A` ❌ (يجب أن يكون موجود)
- **النتيجة**: لا يمكن استقبال Job Offers

---

## ✅ الحل السريع

### **الخطوة 1: شغّل SQL Script**

افتح PostgreSQL و نفّذ:

```sql
-- تحديث Status
UPDATE drivers
SET status = 'approved', updated_at = NOW()
WHERE phone_number = '0500756756' 
   OR national_id = '1067895456';

-- تحديث Full Name
UPDATE drivers
SET full_name = 'Test Driver', updated_at = NOW()
WHERE phone_number = '0500756756' 
  AND (full_name IS NULL OR full_name = '' OR full_name = 'N/A');

-- تفعيل التحققيات
UPDATE drivers
SET 
  identity_verified = true,
  license_verified = true,
  vehicle_verified = true,
  insurance_verified = true,
  background_check_passed = true,
  updated_at = NOW()
WHERE phone_number = '0500756756' AND status = 'approved';
```

**أو شغّل الملف:**
```bash
psql -U your_user -d your_database -f backend/FIX_DRIVER_URGENT.sql
```

---

### **الخطوة 2: التحقق**

```sql
SELECT 
  u.phone,
  d.full_name,
  d.status,
  d.is_online
FROM users u
LEFT JOIN drivers d ON d.user_id = u.id
WHERE u.phone = '0500756756';
```

**يجب أن ترى:**
- ✅ `status = 'approved'`
- ✅ `full_name = 'Test Driver'`

---

### **الخطوة 3: إعادة تشغيل التطبيق**

1. **أغلق التطبيق تماماً** (kill app)
2. **أعد فتحه**
3. **اذهب إلى Profile**
4. **يجب أن ترى:**
   - ✅ Status: **Approved** (أخضر)
   - ✅ Full Name: **Test Driver**
   - ✅ Online Toggle: **يعمل**

---

### **الخطوة 4: تفعيل Online**

1. في **Profile Screen**
2. فعّل **Online Toggle**
3. الآن يمكنك استقبال **Job Offers** ✅

---

## 🎯 النتيجة المتوقعة

بعد التنفيذ:

1. ✅ **Profile Screen**:
   - Status: **Approved** (بدلاً من Pending)
   - Full Name: **Test Driver** (بدلاً من N/A)
   - Online Toggle: **يعمل**

2. ✅ **Jobs Screen**:
   - لا يوجد خطأ "Driver not approved"
   - يمكن رؤية Job Offers

3. ✅ **يمكن قبول الطلبات**:
   - السائق يمكنه قبول Job Offers
   - يمكنه الذهاب Online
   - يمكنه استقبال الطلبات

---

## ⚠️ إذا لم يعمل

### **تحقق من Phone Number:**

```sql
SELECT phone FROM users WHERE phone LIKE '%500756756%';
SELECT phone_number FROM drivers WHERE phone_number LIKE '%500756756%';
```

### **تحقق من Status:**

```sql
SELECT status FROM drivers WHERE phone_number = '0500756756';
```

### **إذا كان Phone مختلف:**

غيّر في SQL:
```sql
WHERE phone_number = 'YOUR_ACTUAL_PHONE_NUMBER'
```

---

**ملاحظة**: بعد تنفيذ SQL، **يجب إعادة تشغيل التطبيق** لرؤية التغييرات!
