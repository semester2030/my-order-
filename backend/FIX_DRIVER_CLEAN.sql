-- Step 1: Update status to approved
UPDATE drivers
SET status = 'approved', updated_at = NOW()
WHERE phone_number = '0500756756' 
   OR national_id = '1067895456';

-- Step 2: Update full name
UPDATE drivers
SET full_name = 'Test Driver', updated_at = NOW()
WHERE phone_number = '0500756756' 
  AND (full_name IS NULL OR full_name = '' OR full_name = 'N/A');

-- Step 3: Enable all verifications
UPDATE drivers
SET 
  identity_verified = true,
  license_verified = true,
  vehicle_verified = true,
  insurance_verified = true,
  background_check_passed = true,
  updated_at = NOW()
WHERE phone_number = '0500756756' AND status = 'approved';

-- Step 4: Verify result
SELECT 
  u.phone,
  d.full_name,
  d.status,
  d.is_online
FROM users u
LEFT JOIN drivers d ON d.user_id = u.id
WHERE u.phone = '0500756756';
