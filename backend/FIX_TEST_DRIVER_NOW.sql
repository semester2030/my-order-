-- ✅ FIX TEST DRIVER ACCOUNT - URGENT
-- Phone: 0500756756
-- National ID: 1067895456
--
-- This script will IMMEDIATELY fix the test driver account:
-- 1. Set status to 'approved'
-- 2. Set full_name to a proper value
-- 3. Enable all verifications
-- 4. Make driver ready to receive jobs

-- ============================================
-- STEP 1: FIND THE DRIVER FIRST
-- ============================================
-- Let's see what we have:
SELECT 
  '🔍 Current Driver Status:' as info,
  u.id as user_id,
  u.phone as user_phone,
  u.name as user_name,
  d.id as driver_id,
  d.phone_number as driver_phone,
  d.full_name,
  d.national_id,
  d.status,
  d.is_online,
  d.identity_verified,
  d.license_verified,
  d.vehicle_verified,
  d.insurance_verified
FROM users u
LEFT JOIN drivers d ON d.user_id = u.id
WHERE u.phone = '0500756756' 
   OR u.phone = '+966500756756'
   OR d.phone_number = '0500756756'
   OR d.phone_number = '+966500756756'
   OR d.national_id = '1067895456';

-- ============================================
-- STEP 2: UPDATE STATUS TO APPROVED
-- ============================================
UPDATE drivers
SET 
  status = 'approved',
  updated_at = NOW()
WHERE phone_number = '0500756756' 
   OR phone_number = '+966500756756'
   OR national_id = '1067895456'
   OR user_id IN (
     SELECT id FROM users 
     WHERE phone = '0500756756' 
        OR phone = '+966500756756'
   );

-- ============================================
-- STEP 3: UPDATE FULL NAME
-- ============================================
UPDATE drivers
SET 
  full_name = CASE 
    WHEN full_name IS NULL OR full_name = '' OR full_name = 'N/A' 
    THEN 'Test Driver Account'
    ELSE full_name
  END,
  updated_at = NOW()
WHERE (phone_number = '0500756756' 
   OR phone_number = '+966500756756'
   OR national_id = '1067895456')
  AND status = 'approved';

-- ============================================
-- STEP 4: ENABLE ALL VERIFICATIONS
-- ============================================
UPDATE drivers
SET 
  identity_verified = true,
  identity_verified_at = COALESCE(identity_verified_at, NOW()),
  license_verified = true,
  license_verified_at = COALESCE(license_verified_at, NOW()),
  vehicle_verified = true,
  vehicle_verified_at = COALESCE(vehicle_verified_at, NOW()),
  insurance_verified = true,
  insurance_verified_at = COALESCE(insurance_verified_at, NOW()),
  background_check_passed = true,
  background_check_date = COALESCE(background_check_date, NOW()),
  updated_at = NOW()
WHERE (phone_number = '0500756756' 
   OR phone_number = '+966500756756'
   OR national_id = '1067895456')
  AND status = 'approved';

-- ============================================
-- STEP 5: VERIFY THE FIX
-- ============================================
SELECT 
  '✅ FIXED - Driver Status:' as result,
  u.phone as user_phone,
  d.full_name,
  d.national_id,
  d.status as driver_status,
  CASE 
    WHEN d.status = 'approved' THEN '✅ APPROVED - Can receive jobs'
    ELSE '❌ NOT APPROVED - Cannot receive jobs'
  END as job_eligibility,
  d.is_online,
  CASE 
    WHEN d.is_online = true THEN '✅ ONLINE'
    ELSE '⚠️ OFFLINE - Toggle online in app'
  END as online_status,
  d.identity_verified,
  d.license_verified,
  d.vehicle_verified,
  d.insurance_verified
FROM users u
LEFT JOIN drivers d ON d.user_id = u.id
WHERE u.phone = '0500756756' 
   OR u.phone = '+966500756756'
   OR d.phone_number = '0500756756'
   OR d.phone_number = '+966500756756'
   OR d.national_id = '1067895456';

-- ============================================
-- FINAL CHECK: Can driver receive jobs?
-- ============================================
SELECT 
  CASE 
    WHEN d.status = 'approved' AND d.identity_verified = true 
    THEN '✅✅✅ DRIVER IS READY TO RECEIVE JOBS! ✅✅✅'
    ELSE '❌ Driver still has issues - check above'
  END as final_status
FROM users u
LEFT JOIN drivers d ON d.user_id = u.id
WHERE u.phone = '0500756756' 
   OR u.phone = '+966500756756'
   OR d.phone_number = '0500756756'
   OR d.phone_number = '+966500756756'
   OR d.national_id = '1067895456';
