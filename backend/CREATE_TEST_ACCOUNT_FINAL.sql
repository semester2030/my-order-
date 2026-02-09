-- ✅ SQL Script to create test vendor account (FINAL - FIXED)
-- Email: cy-20@outlook.com
-- Password: test123456

-- Step 1: Create or Update User
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
    is_active = true,
    updated_at = NOW();

-- Step 2: Create Vendor with ALL required fields
INSERT INTO vendors (
  id, name, trade_name, type, email, phone_number,
  latitude, longitude, address, city, district,
  owner_name, owner_phone, owner_email, owner_id_number, owner_id_image,
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
  'Test Owner',           -- owner_name (required)
  '+966501234567',        -- owner_phone (required)
  'cy-20@outlook.com',    -- owner_email (required)
  '1234567890',           -- owner_id_number (required)
  'test-id-image.jpg',    -- owner_id_image (required)
  true,
  true,
  'approved',
  NOW(),
  NOW()
)
ON CONFLICT (email) DO UPDATE
SET name = 'Test Restaurant',
    trade_name = 'Test Restaurant',
    owner_name = COALESCE(EXCLUDED.owner_name, vendors.owner_name, 'Test Owner'),
    owner_phone = COALESCE(EXCLUDED.owner_phone, vendors.owner_phone, '+966501234567'),
    owner_email = COALESCE(EXCLUDED.owner_email, vendors.owner_email, 'cy-20@outlook.com'),
    owner_id_number = COALESCE(EXCLUDED.owner_id_number, vendors.owner_id_number, '1234567890'),
    owner_id_image = COALESCE(EXCLUDED.owner_id_image, vendors.owner_id_image, 'test-id-image.jpg'),
    is_active = true,
    is_accepting_orders = true,
    registration_status = 'approved',
    updated_at = NOW();

-- Step 3: Link User to Vendor (VendorStaff)
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
ON CONFLICT (user_id) DO UPDATE
SET is_active = true,
    updated_at = NOW();

-- Step 4: Verify the account was created successfully
SELECT 
  u.id as user_id,
  u.email,
  u.name as user_name,
  v.id as vendor_id,
  v.name as vendor_name,
  vs.role,
  v.is_active,
  v.is_accepting_orders,
  v.registration_status
FROM users u
JOIN vendor_staff vs ON vs.user_id = u.id
JOIN vendors v ON v.id = vs.vendor_id
WHERE u.email = 'cy-20@outlook.com';

-- ✅ If you see the result above, the account is ready!
-- Now you can login with:
-- Email: cy-20@outlook.com
-- Password: test123456
