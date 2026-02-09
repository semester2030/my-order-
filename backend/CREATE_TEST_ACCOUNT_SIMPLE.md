# إنشاء حساب تجريبي - طريقة بسيطة

## 📧 معلومات الحساب:

**Email:** `cy-20@outlook.com`  
**Password:** `test123456`

---

## ✅ الحل السريع:

### **الطريقة 1: استخدام SQL مباشرة**

قم بتشغيل هذا في `psql`:

```sql
-- 1. إنشاء أو تحديث User
INSERT INTO users (id, phone, name, email, is_verified, is_active, created_at, updated_at)
VALUES (
  gen_random_uuid(),
  '+966501234567',
  'Test Vendor',
  'cy-20@outlook.com',
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (phone) DO UPDATE 
SET email = 'cy-20@outlook.com', 
    name = 'Test Vendor',
    is_verified = true,
    is_active = true;

-- 2. إنشاء Vendor
INSERT INTO vendors (
  id, name, trade_name, type, email, phone_number,
  latitude, longitude, address, city, district,
  is_active, is_accepting_orders, registration_status,
  created_at, updated_at
)
VALUES (
  gen_random_uuid(),
  'Test Restaurant',
  'Test Restaurant',
  'premium_casual',
  'cy-20@outlook.com',
  '+966501234567',
  24.7136,
  46.6753,
  'Test Address',
  'Riyadh',
  'Test District',
  true,
  true,
  'approved',
  NOW(),
  NOW()
)
ON CONFLICT (email) DO NOTHING;

-- 3. ربط User مع Vendor
INSERT INTO vendor_staff (
  id, vendor_id, user_id, role, permissions, is_active,
  accepted_at, created_at, updated_at
)
SELECT
  gen_random_uuid(),
  v.id,
  u.id,
  'owner',
  ARRAY['*'],
  true,
  NOW(),
  NOW(),
  NOW()
FROM users u, vendors v
WHERE u.email = 'cy-20@outlook.com'
  AND v.email = 'cy-20@outlook.com'
ON CONFLICT (user_id) DO NOTHING;
```

---

## 🎯 **ملاحظة مهمة:**

الكود الحالي في `auth.service.ts` يدعم الحساب التجريبي **بدون password hash**:

- إذا كان الإيميل `cy-20@outlook.com` والـ password `test123456`
- سيعمل مباشرة بدون الحاجة لـ password hash في قاعدة البيانات

---

## ✅ **بعد إنشاء الحساب:**

1. تأكد من أن Backend يعمل: `npm run start:dev`
2. افتح Frontend: `http://localhost:3001/login`
3. أدخل:
   - Email: `cy-20@outlook.com`
   - Password: `test123456`
4. اضغط "Sign In"

---

## 🔍 **التحقق من الحساب:**

```sql
SELECT 
  u.id as user_id,
  u.email,
  u.name,
  v.id as vendor_id,
  v.name as vendor_name,
  vs.role
FROM users u
JOIN vendor_staff vs ON vs.user_id = u.id
JOIN vendors v ON v.id = vs.vendor_id
WHERE u.email = 'cy-20@outlook.com';
```

إذا ظهرت النتيجة، الحساب جاهز! ✅
