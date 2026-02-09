-- ✅ Create Test Driver Account
-- Phone: 0500756756
-- Name: فايز
-- Email: cy-20@outlook.com
-- National ID: 1067895456 (example - use actual if available)
-- Location: Riyadh, Al-Qadisiyah
-- Car: كامري 2022
-- Plate: ن ر س - 2230
-- PIN: 1234

-- ============================================
-- 1. DELETE EXISTING TEST DRIVER (if exists)
-- ============================================
-- First, delete any existing driver with this national_id or phone to avoid conflicts
DELETE FROM drivers 
WHERE national_id = '1067895456' 
   OR phone_number = '0500756756' 
   OR phone_number = '+966500756756';

-- ============================================
-- 2. CREATE OR UPDATE USER
-- ============================================
INSERT INTO users (id, phone, name, email, is_verified, is_active, created_at, updated_at)
VALUES (
  gen_random_uuid(),
  '0500756756',
  'فايز',
  'cy-20@outlook.com',
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (phone) DO UPDATE 
SET 
  name = 'فايز',
  email = COALESCE(NULLIF(users.email, ''), 'cy-20@outlook.com'),
  is_verified = true,
  is_active = true,
  updated_at = NOW();

-- ============================================
-- 3. CREATE OR UPDATE DRIVER
-- ============================================
DO $$
DECLARE
  v_user_id UUID;
  v_driver_id UUID;
  v_national_id VARCHAR(10) := '1067895456'; -- Example national ID - MUST be unique
BEGIN
  -- Get user ID
  SELECT id INTO v_user_id
  FROM users
  WHERE phone = '0500756756' OR phone = '+966500756756'
  LIMIT 1;

  IF v_user_id IS NULL THEN
    RAISE EXCEPTION 'User not found for phone: 0500756756';
  END IF;

  -- Check if driver already exists for this user
  SELECT id INTO v_driver_id
  FROM drivers
  WHERE user_id = v_user_id
  LIMIT 1;

  IF v_driver_id IS NOT NULL THEN
    -- Update existing driver
    UPDATE drivers
    SET 
      full_name = 'فايز',
      national_id = v_national_id,
      phone_number = '0500756756',
      email = 'cy-20@outlook.com',
      status = 'approved',
      is_online = false,
      current_latitude = 24.7136,
      current_longitude = 46.6753,
      updated_at = NOW()
    WHERE id = v_driver_id;
    
    RAISE NOTICE 'Driver updated: %', v_driver_id;
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
      v_national_id,
      '0500756756',
      'cy-20@outlook.com',
      'approved',
      false,
      24.7136,
      46.6753,
      NOW(),
      NOW()
    )
    RETURNING id INTO v_driver_id;
    
    RAISE NOTICE 'Driver created: %', v_driver_id;
  END IF;
END $$;

-- ============================================
-- 4. SET PIN FOR TEST DRIVER
-- ============================================
-- PIN: 1234
-- bcrypt hash for '1234' (10 rounds): $2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
UPDATE users
SET 
  pin_hash = '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy',
  updated_at = NOW()
WHERE phone = '0500756756' OR phone = '+966500756756';

-- ============================================
-- 5. VERIFY RESULTS
-- ============================================
-- Check user
SELECT 
  id, 
  phone, 
  name, 
  email, 
  pin_hash IS NOT NULL as has_pin,
  is_verified, 
  is_active,
  created_at
FROM users
WHERE phone = '0500756756' OR phone = '+966500756756';

-- Check driver
SELECT 
  d.id,
  d.user_id,
  d.full_name,
  d.national_id,
  d.phone_number,
  d.email,
  d.status,
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
