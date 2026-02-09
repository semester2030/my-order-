-- ✅ Create Test Customer Account
-- Phone: 0500756706
-- Name: خالد
-- Location: Riyadh, Al-Qadisiyah

-- ============================================
-- 1. CREATE OR UPDATE CUSTOMER USER
-- ============================================
INSERT INTO users (id, phone, name, email, is_verified, is_active, created_at, updated_at)
VALUES (
  gen_random_uuid(),
  '0500756706',
  'خالد',
  'khalid.customer@test.com',
  true,
  true,
  NOW(),
  NOW()
)
ON CONFLICT (phone) DO UPDATE 
SET 
  name = 'خالد',
  email = COALESCE(NULLIF(users.email, ''), 'khalid.customer@test.com'),
  is_verified = true,
  is_active = true,
  updated_at = NOW();

-- ============================================
-- 2. CREATE DEFAULT ADDRESS FOR CUSTOMER
-- ============================================
-- Get user ID first
DO $$
DECLARE
  v_user_id UUID;
  v_address_id UUID;
BEGIN
  -- Get user ID
  SELECT id INTO v_user_id
  FROM users
  WHERE phone = '0500756706' OR phone = '+966500756706'
  LIMIT 1;

  IF v_user_id IS NOT NULL THEN
    -- Check if address already exists
    SELECT id INTO v_address_id
    FROM addresses
    WHERE user_id = v_user_id AND is_default = true
    LIMIT 1;

    IF v_address_id IS NULL THEN
      -- Create default address
      INSERT INTO addresses (
        id, user_id, label, street_address, city, district,
        latitude, longitude, is_default, is_active,
        created_at, updated_at
      )
      VALUES (
        gen_random_uuid(),
        v_user_id,
        'Home',
        'Al-Qadisiyah District, Riyadh',
        'Riyadh',
        'Al-Qadisiyah',
        24.7136,  -- Riyadh coordinates
        46.6753,
        true,
        true,
        NOW(),
        NOW()
      );
    ELSE
      -- Update existing address
      UPDATE addresses
      SET 
        street_address = 'Al-Qadisiyah District, Riyadh',
        city = 'Riyadh',
        district = 'Al-Qadisiyah',
        latitude = 24.7136,
        longitude = 46.6753,
        updated_at = NOW()
      WHERE id = v_address_id;
    END IF;
  END IF;
END $$;

-- ============================================
-- 3. VERIFY RESULTS
-- ============================================
-- Check customer user
SELECT 
  id, 
  phone, 
  name, 
  email, 
  is_verified, 
  is_active,
  created_at
FROM users
WHERE phone = '0500756706' OR phone = '+966500756706';

-- Check customer address
SELECT 
  a.id,
  a.user_id,
  a.label,
  a.street_address,
  a.city,
  a.district,
  a.latitude,
  a.longitude,
  a.is_default,
  a.is_active
FROM addresses a
JOIN users u ON a.user_id = u.id
WHERE (u.phone = '0500756706' OR u.phone = '+966500756706')
  AND a.is_default = true;
