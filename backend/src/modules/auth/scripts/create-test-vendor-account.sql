-- SQL Script to create test vendor account
-- Email: cy-20@outlook.com
-- Password: test123456

-- Step 1: Create User
INSERT INTO users (id, phone, name, email, pin_hash, is_verified, is_active, created_at, updated_at)
VALUES (
  gen_random_uuid(),
  '+966501234567',
  'Test Vendor',
  'cy-20@outlook.com',
  '$2b$10$rQ8K8K8K8K8K8K8K8K8K8O8K8K8K8K8K8K8K8K8K8K8K8K8K8K8K', -- This is a placeholder, use bcrypt to hash 'test123456'
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (email) DO NOTHING
RETURNING id;

-- Step 2: Create Vendor (replace USER_ID with the ID from Step 1)
-- First, get the user_id:
-- SELECT id FROM users WHERE email = 'cy-20@outlook.com';

-- Then create vendor:
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
ON CONFLICT (email) DO NOTHING
RETURNING id;

-- Step 3: Create VendorStaff (link user to vendor)
-- Replace USER_ID and VENDOR_ID with actual IDs from above
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

-- Verify the account was created:
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
