-- ✅ Verify Test Driver Account
-- This script helps diagnose issues with the test driver account

-- ============================================
-- 1. CHECK USER
-- ============================================
SELECT 
  'USER CHECK' as check_type,
  id, 
  phone, 
  name, 
  email, 
  pin_hash IS NOT NULL as has_pin,
  CASE 
    WHEN pin_hash IS NULL THEN '❌ PIN NOT SET'
    WHEN pin_hash = '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy' THEN '✅ PIN SET (1234)'
    ELSE '⚠️ PIN SET (different hash)'
  END as pin_status,
  is_verified, 
  is_active,
  created_at,
  updated_at
FROM users
WHERE phone = '0500756756' OR phone = '+966500756756';

-- ============================================
-- 2. CHECK DRIVER
-- ============================================
SELECT 
  'DRIVER CHECK' as check_type,
  d.id,
  d.user_id,
  d.full_name,
  d.national_id,
  d.phone_number,
  d.email,
  d.status,
  CASE 
    WHEN d.status = 'approved' THEN '✅ APPROVED'
    WHEN d.status = 'pending' THEN '⚠️ PENDING'
    WHEN d.status = 'under_review' THEN '⚠️ UNDER REVIEW'
    WHEN d.status = 'rejected' THEN '❌ REJECTED'
    ELSE '❓ ' || d.status
  END as status_display,
  d.is_online,
  d.current_latitude,
  d.current_longitude,
  d.created_at,
  d.updated_at,
  u.phone as user_phone,
  u.name as user_name,
  u.pin_hash IS NOT NULL as user_has_pin
FROM drivers d
JOIN users u ON d.user_id = u.id
WHERE u.phone = '0500756756' OR u.phone = '+966500756756';

-- ============================================
-- 3. CHECK FOR DUPLICATES
-- ============================================
SELECT 
  'DUPLICATE CHECK' as check_type,
  'National ID duplicates' as check_name,
  national_id,
  COUNT(*) as count
FROM drivers
WHERE national_id = '1067895456'
GROUP BY national_id
HAVING COUNT(*) > 1;

SELECT 
  'DUPLICATE CHECK' as check_type,
  'Phone duplicates' as check_name,
  phone_number,
  COUNT(*) as count
FROM drivers
WHERE phone_number = '0500756756' OR phone_number = '+966500756756'
GROUP BY phone_number
HAVING COUNT(*) > 1;

-- ============================================
-- 4. CHECK USER-DRIVER LINK
-- ============================================
SELECT 
  'LINK CHECK' as check_type,
  u.id as user_id,
  u.phone as user_phone,
  d.id as driver_id,
  d.national_id as driver_national_id,
  CASE 
    WHEN d.id IS NULL THEN '❌ NO DRIVER LINKED'
    ELSE '✅ DRIVER LINKED'
  END as link_status
FROM users u
LEFT JOIN drivers d ON d.user_id = u.id
WHERE u.phone = '0500756756' OR u.phone = '+966500756756';
