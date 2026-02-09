-- ✅ Reset Test Driver Account
-- This script completely resets the test driver account
-- Phone: 0500756756
-- PIN: 1234

-- ============================================
-- 1. DELETE EXISTING DRIVER
-- ============================================
DELETE FROM drivers 
WHERE national_id = '1067895456' 
   OR phone_number = '0500756756' 
   OR phone_number = '+966500756756'
   OR user_id IN (
     SELECT id FROM users 
     WHERE phone = '0500756756' OR phone = '+966500756756'
   );

-- ============================================
-- 2. DELETE EXISTING USER (if you want a clean start)
-- ============================================
-- Uncomment the line below if you want to delete the user completely
-- DELETE FROM users WHERE phone = '0500756756' OR phone = '+966500756756';

-- ============================================
-- 3. CREATE USER
-- ============================================
INSERT INTO users (id, phone, name, email, is_verified, is_active, pin_hash, created_at, updated_at)
VALUES (
  gen_random_uuid(),
  '0500756756',
  'فايز',
  'cy-20@outlook.com',
  true,
  true,
  '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', -- PIN: 1234
  NOW(),
  NOW()
)
ON CONFLICT (phone) DO UPDATE 
SET 
  name = 'فايز',
  email = 'cy-20@outlook.com',
  is_verified = true,
  is_active = true,
  pin_hash = '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
  updated_at = NOW();

-- ============================================
-- 4. CREATE DRIVER
-- ============================================
-- Create driver using DO block to handle conflicts properly
DO $$
DECLARE
  v_user_id UUID;
  v_driver_id UUID;
BEGIN
  -- Get user ID
  SELECT id INTO v_user_id
  FROM users
  WHERE phone = '0500756756' OR phone = '+966500756756'
  LIMIT 1;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'User not found for phone: 0500756756';
  END IF;

  -- Check if driver exists
  SELECT id INTO v_driver_id
  FROM drivers
  WHERE user_id = v_user_id
  LIMIT 1;

  IF v_driver_id IS NOT NULL THEN
    -- Update existing driver
    UPDATE drivers
    SET 
      full_name = 'فايز',
      national_id = '1067895456',
      phone_number = '0500756756',
      email = 'cy-20@outlook.com',
      status = 'approved',
      is_online = false,
      current_latitude = 24.7136,
      current_longitude = 46.6753,
      updated_at = NOW()
    WHERE id = v_driver_id;
  ELSE
    -- Create new driver
    INSERT INTO drivers (
      id, 
      user_id, 
      full_name,
      national_id,
      phone_number,
      email,
      status,
      is_online,
      current_latitude,
      current_longitude,
      created_at,
      updated_at
    )
    VALUES (
      gen_random_uuid(),
      v_user_id,
      'فايز',
      '1067895456',
      '0500756756',
      'cy-20@outlook.com',
      'approved',
      false,
      24.7136,
      46.6753,
      NOW(),
      NOW()
    );
  END IF;
END $$;

-- ============================================
-- 5. VERIFY
-- ============================================
SELECT '✅ Test Driver Account Reset Complete!' as status;

SELECT 
  u.phone,
  u.name,
  u.pin_hash IS NOT NULL as has_pin,
  d.national_id,
  d.status,
  d.is_online
FROM users u
LEFT JOIN drivers d ON d.user_id = u.id
WHERE u.phone = '0500756756' OR u.phone = '+966500756756';
