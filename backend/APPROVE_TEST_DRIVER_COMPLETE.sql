-- ✅ Approve Test Driver Account and Complete Profile Data
-- Phone: 0500756756
-- National ID: 1067895456
-- 
-- This script will:
-- 1. Update driver status to 'approved'
-- 2. Set full_name (currently N/A)
-- 3. Verify all required fields
-- 4. Enable driver to receive job offers

-- ============================================
-- STEP 1: UPDATE DRIVER STATUS TO APPROVED
-- ============================================
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

-- ============================================
-- STEP 2: UPDATE FULL NAME (if N/A or NULL)
-- ============================================
UPDATE drivers
SET 
  full_name = COALESCE(
    NULLIF(full_name, 'N/A'),
    NULLIF(full_name, ''),
    'Test Driver'  -- Default name for testing
  ),
  updated_at = NOW()
WHERE (phone_number = '0500756756' OR phone_number = '+966500756756')
  AND (full_name IS NULL OR full_name = 'N/A' OR full_name = '');

-- ============================================
-- STEP 3: VERIFY ALL REQUIRED VERIFICATION FIELDS
-- ============================================
UPDATE drivers
SET 
  identity_verified = COALESCE(identity_verified, true),
  identity_verified_at = COALESCE(identity_verified_at, NOW()),
  license_verified = COALESCE(license_verified, true),
  license_verified_at = COALESCE(license_verified_at, NOW()),
  vehicle_verified = COALESCE(vehicle_verified, true),
  vehicle_verified_at = COALESCE(vehicle_verified_at, NOW()),
  insurance_verified = COALESCE(insurance_verified, true),
  insurance_verified_at = COALESCE(insurance_verified_at, NOW()),
  background_check_passed = COALESCE(background_check_passed, true),
  background_check_date = COALESCE(background_check_date, NOW()),
  updated_at = NOW()
WHERE (phone_number = '0500756756' OR phone_number = '+966500756756')
  AND status = 'approved';

-- ============================================
-- STEP 4: VERIFY RESULT
-- ============================================
SELECT 
  '✅ Test Driver Account Updated!' as status,
  u.phone as user_phone,
  u.name as user_name,
  d.full_name as driver_full_name,
  d.national_id,
  d.status as driver_status,
  d.is_online,
  d.identity_verified,
  d.license_verified,
  d.vehicle_verified,
  d.insurance_verified,
  d.background_check_passed,
  d.email,
  d.created_at,
  d.updated_at
FROM users u
LEFT JOIN drivers d ON d.user_id = u.id
WHERE u.phone = '0500756756' OR u.phone = '+966500756756';

-- ============================================
-- STEP 5: CHECK IF DRIVER CAN RECEIVE JOBS
-- ============================================
SELECT 
  CASE 
    WHEN d.status = 'approved' THEN '✅ Driver is APPROVED - Can receive jobs'
    ELSE '❌ Driver is NOT approved - Cannot receive jobs'
  END as job_eligibility,
  CASE 
    WHEN d.is_online = true THEN '✅ Driver is ONLINE'
    ELSE '⚠️ Driver is OFFLINE - Must go online to receive jobs'
  END as online_status,
  CASE 
    WHEN d.full_name IS NULL OR d.full_name = 'N/A' OR d.full_name = '' THEN '⚠️ Full Name is missing'
    ELSE '✅ Full Name: ' || d.full_name
  END as name_status
FROM users u
LEFT JOIN drivers d ON d.user_id = u.id
WHERE u.phone = '0500756756' OR u.phone = '+966500756756';
