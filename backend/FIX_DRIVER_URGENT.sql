-- ⚡ URGENT FIX - Test Driver Account
-- Phone: 0500756756
-- National ID: 1067895456
--
-- This will IMMEDIATELY fix the account

-- ============================================
-- STEP 1: UPDATE STATUS TO APPROVED
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
     WHERE phone = '0500756756' OR phone = '+966500756756'
   );

-- ============================================
-- STEP 2: UPDATE FULL NAME
-- ============================================
UPDATE drivers
SET 
  full_name = 'Test Driver',
  updated_at = NOW()
WHERE (phone_number = '0500756756' 
   OR phone_number = '+966500756756'
   OR national_id = '1067895456')
  AND (full_name IS NULL OR full_name = '' OR full_name = 'N/A');

-- ============================================
-- STEP 3: ENABLE ALL VERIFICATIONS
-- ============================================
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
WHERE (phone_number = '0500756756' 
   OR phone_number = '+966500756756'
   OR national_id = '1067895456')
  AND status = 'approved';

-- ============================================
-- VERIFY RESULT
-- ============================================
SELECT 
  '✅ FIXED!' as status,
  u.phone,
  d.full_name,
  d.status,
  d.is_online
FROM users u
LEFT JOIN drivers d ON d.user_id = u.id
WHERE u.phone = '0500756756' OR u.phone = '+966500756756';
