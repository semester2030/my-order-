# ✅ كيفية قبول الحساب التجريبي للسائق

## 📋 المشكلة

الحساب التجريبي للسائق:
- **Phone**: `0500756756`
- **National ID**: `1067895456`
- **Status**: `pending` (يجب أن يكون `approved`)
- **Full Name**: `N/A` (يجب أن يكون موجود)

## 🔧 الحل

### **الخطوة 1: تشغيل SQL Script**

قم بتشغيل الملف:
```bash
backend/APPROVE_TEST_DRIVER_COMPLETE.sql
```

أو نفذ الأوامر التالية مباشرة في قاعدة البيانات:

```sql
-- 1. تحديث Status إلى Approved
UPDATE drivers
SET 
  status = 'approved',
  updated_at = NOW()
WHERE phone_number = '0500756756' 
   OR phone_number = '+966500756756'
   OR user_id IN (
     SELECT id FROM users 
     WHERE phone = '0500756756' OR phone = '+966500756756'
   );

-- 2. تحديث Full Name
UPDATE drivers
SET 
  full_name = COALESCE(
    NULLIF(full_name, 'N/A'),
    NULLIF(full_name, ''),
    'Test Driver'  -- أو أي اسم تريده
  ),
  updated_at = NOW()
WHERE (phone_number = '0500756756' OR phone_number = '+966500756756')
  AND (full_name IS NULL OR full_name = 'N/A' OR full_name = '');

-- 3. تفعيل جميع التحققيات
UPDATE drivers
SET 
  identity_verified = true,
  identity_verified_at = NOW(),
  license_verified = true,
  license_verified_at = NOW(),
  vehicle_verified = true,
  vehicle_verified_at = NOW(),
  insurance_verified = true,
  insurance_verified_at = NOW(),
  background_check_passed = true,
  background_check_date = NOW(),
  updated_at = NOW()
WHERE (phone_number = '0500756756' OR phone_number = '+966500756756')
  AND status = 'approved';
```

### **الخطوة 2: التحقق من النتيجة**

```sql
SELECT 
  u.phone,
  u.name as user_name,
  d.full_name,
  d.national_id,
  d.status,
  d.is_online,
  d.identity_verified,
  d.license_verified,
  d.vehicle_verified
FROM users u
LEFT JOIN drivers d ON d.user_id = u.id
WHERE u.phone = '0500756756' OR u.phone = '+966500756756';
```

**يجب أن ترى:**
- ✅ `status = 'approved'`
- ✅ `full_name` ليس `NULL` أو `'N/A'`
- ✅ جميع التحققيات = `true`

### **الخطوة 3: إعادة تشغيل التطبيق**

1. أغلق تطبيق السائق تماماً
2. أعد فتح التطبيق
3. اذهب إلى Profile
4. يجب أن ترى:
   - ✅ Status: **Approved** (بدلاً من Pending)
   - ✅ Full Name: **Test Driver** (بدلاً من N/A)
   - ✅ يمكنك تفعيل Online Toggle

### **الخطوة 4: تفعيل Online**

1. في شاشة Profile
2. فعّل **Online Toggle**
3. يجب أن تصبح **Online**
4. الآن يمكنك استقبال Job Offers

---

## 🎯 النتيجة المتوقعة

بعد تنفيذ الخطوات:

1. ✅ **Profile Screen**:
   - Status Badge: **"Approved"** (أخضر)
   - Full Name: **"Test Driver"** (بدلاً من N/A)
   - Online Toggle: **يعمل** (يمكن تفعيله)

2. ✅ **Jobs Screen**:
   - لا يوجد خطأ "Driver not approved"
   - يمكن رؤية Job Offers المتاحة

3. ✅ **يمكن قبول الطلبات**:
   - السائق يمكنه قبول Job Offers
   - يمكنه الذهاب Online
   - يمكنه استقبال الطلبات

---

## ⚠️ ملاحظات مهمة

1. **Full Name**: إذا أردت تغيير الاسم من "Test Driver" إلى اسم آخر، غيّر القيمة في SQL:
   ```sql
   full_name = 'اسم السائق هنا'
   ```

2. **Phone Number**: تأكد من أن رقم الهاتف في قاعدة البيانات يطابق `0500756756` أو `+966500756756`

3. **User ID**: إذا كان `user_id` مختلف، استخدم:
   ```sql
   WHERE user_id = 'user-id-here'
   ```

---

## 🔍 التحقق من الأخطاء

إذا لم يعمل:

1. **تحقق من Phone Number**:
   ```sql
   SELECT phone FROM users WHERE phone LIKE '%500756756%';
   ```

2. **تحقق من Driver Status**:
   ```sql
   SELECT status FROM drivers WHERE phone_number LIKE '%500756756%';
   ```

3. **تحقق من Full Name**:
   ```sql
   SELECT full_name FROM drivers WHERE phone_number LIKE '%500756756%';
   ```

---

**تاريخ**: 28 يناير 2026  
**الحالة**: ✅ جاهز للاستخدام
