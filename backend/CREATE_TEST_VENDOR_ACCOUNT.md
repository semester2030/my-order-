# إنشاء حساب تجريبي للـ Vendor

## 📧 معلومات الحساب:

**Email:** `cy-20@outlook.com`  
**Password:** `test123456`

---

## 🚀 الطريقة السريعة (SQL):

قم بتشغيل هذا SQL في `psql`:

```sql
-- 1. إنشاء User
INSERT INTO users (id, phone, name, email, pin_hash, is_verified, is_active, created_at, updated_at)
VALUES (
  gen_random_uuid(),
  '+966501234567',
  'Test Vendor',
  'cy-20@outlook.com',
  '$2b$10$rQ8K8K8K8K8K8K8K8K8K8O8K8K8K8K8K8K8K8K8K8K8K8K8K8K8K',
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (phone) DO UPDATE SET email = 'cy-20@outlook.com', pin_hash = '$2b$10$rQ8K8K8K8K8K8K8K8K8K8O8K8K8K8K8K8K8K8K8K8K8K8K8K8K8K8K';

-- 2. الحصول على User ID
-- SELECT id FROM users WHERE email = 'cy-20@outlook.com';

-- 3. إنشاء Vendor
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

-- 4. ربط User مع Vendor (VendorStaff)
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

**ملاحظة:** يجب استبدال `$2b$10$rQ8K8K8K8K8K8K8K8K8K8O8K8K8K8K8K8K8K8K8K8K8K8K8K8K8K8K` بـ hash فعلي لـ `test123456`

---

## 🔧 الطريقة الأفضل (TypeScript Script):

استخدم الـ script في:
`backend/src/modules/auth/scripts/create-test-vendor-simple.ts`

أو أنشئ ملف جديد في Backend:

```typescript
// create-test-account.ts
import { DataSource } from 'typeorm';
import * as bcrypt from 'bcrypt';
// ... imports

async function createTestAccount() {
  const dataSource = new DataSource(/* your config */);
  await dataSource.initialize();
  
  // Use the script function
  await createTestVendor(dataSource);
  
  await dataSource.destroy();
}
```

---

## ✅ التحقق:

بعد إنشاء الحساب، جرب تسجيل الدخول في Frontend:

1. افتح `http://localhost:3001/login`
2. أدخل:
   - Email: `cy-20@outlook.com`
   - Password: `test123456`
3. اضغط "Sign In"

---

## 🔐 Password Hash:

لإنشاء hash للـ password `test123456`:

```typescript
import * as bcrypt from 'bcrypt';
const hash = await bcrypt.hash('test123456', 10);
console.log(hash);
```

---

## 📝 ملاحظات:

- الحساب التجريبي يعمل مباشرة بدون password hash في الكود الحالي
- في production، يجب hash passwords بشكل صحيح
- تأكد من أن User و Vendor و VendorStaff مرتبطين بشكل صحيح
