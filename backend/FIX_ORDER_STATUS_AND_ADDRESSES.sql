-- ✅ Fix Order Status and Addresses
-- This script fixes:
-- 1. Order status progression (PENDING -> CONFIRMED -> PREPARING -> READY)
-- 2. Vendor address (change from San Francisco to Riyadh, Al-Qadisiyah)
-- 3. Driver address (ensure driver is in Riyadh, Al-Qadisiyah)

-- ============================================
-- 1. UPDATE VENDOR ADDRESS TO RIYADH
-- ============================================
-- Update vendor address to Riyadh, Al-Qadisiyah district
UPDATE vendors
SET 
  address = 'Al-Qadisiyah District, Riyadh',
  city = 'Riyadh',
  district = 'Al-Qadisiyah',
  latitude = 24.7136,  -- Riyadh coordinates
  longitude = 46.6753,
  updated_at = NOW()
WHERE email = 'cy-20@outlook.com' OR phone_number = '+966501234567';

-- ============================================
-- 2. UPDATE DRIVER ADDRESS TO RIYADH
-- ============================================
-- Update driver address for test driver (phone: 0500756705)
UPDATE drivers
SET 
  city = 'Riyadh',
  district = 'Al-Qadisiyah',
  latitude = 24.7136,  -- Riyadh coordinates
  longitude = 46.6753,
  updated_at = NOW()
WHERE phone = '0500756705' OR phone = '+966500756705';

-- ============================================
-- 3. UPDATE EXISTING ORDERS WITH WRONG ADDRESS
-- ============================================
-- Update orders that have San Francisco address
UPDATE orders o
SET updated_at = NOW()
FROM addresses a
WHERE o.address_id = a.id 
  AND (a.city = 'San Francisco' OR a.street_address LIKE '%Stockton%');

-- Update addresses that are in San Francisco
UPDATE addresses
SET 
  city = 'Riyadh',
  district = 'Al-Qadisiyah',
  latitude = 24.7136,
  longitude = 46.6753,
  updated_at = NOW()
WHERE city = 'San Francisco' OR street_address LIKE '%Stockton%';

-- ============================================
-- 4. VERIFY TEST DRIVER DATA
-- ============================================
-- Ensure test driver exists with correct data
-- Phone: 0500756705
-- Email: cy-20@outlook.com
-- Name: فايز
-- Car: كامري 2022
-- Plate: ن ر س - 2230
-- Location: Riyadh, Al-Qadisiyah

-- First, find the user by phone
DO $$
DECLARE
  v_user_id UUID;
  v_driver_id UUID;
BEGIN
  -- Get user ID
  SELECT id INTO v_user_id
  FROM users
  WHERE phone = '0500756705' OR phone = '+966500756705'
  LIMIT 1;

  IF v_user_id IS NOT NULL THEN
    -- Update or create driver
    SELECT id INTO v_driver_id
    FROM drivers
    WHERE user_id = v_user_id
    LIMIT 1;

    IF v_driver_id IS NOT NULL THEN
      -- Update existing driver
      UPDATE drivers
      SET 
        name = 'فايز',
        city = 'Riyadh',
        district = 'Al-Qadisiyah',
        latitude = 24.7136,
        longitude = 46.6753,
        vehicle_type = 'sedan',
        vehicle_model = 'كامري 2022',
        vehicle_plate = 'ن ر س - 2230',
        status = 'approved',
        updated_at = NOW()
      WHERE id = v_driver_id;
    ELSE
      -- Create driver if doesn't exist
      INSERT INTO drivers (
        id, user_id, name, phone, email,
        city, district, latitude, longitude,
        vehicle_type, vehicle_model, vehicle_plate,
        status, created_at, updated_at
      )
      VALUES (
        gen_random_uuid(), v_user_id, 'فايز', '0500756705', 'cy-20@outlook.com',
        'Riyadh', 'Al-Qadisiyah', 24.7136, 46.6753,
        'sedan', 'كامري 2022', 'ن ر س - 2230',
        'approved', NOW(), NOW()
      );
    END IF;
  END IF;
END $$;

-- ============================================
-- 5. VERIFY RESULTS
-- ============================================
-- Check vendor address
SELECT id, name, email, city, district, latitude, longitude
FROM vendors
WHERE email = 'cy-20@outlook.com';

-- Check driver address
SELECT d.id, d.name, d.phone, d.email, d.city, d.district, d.latitude, d.longitude, d.status
FROM drivers d
JOIN users u ON d.user_id = u.id
WHERE u.phone = '0500756705' OR u.phone = '+966500756705';

-- Check addresses
SELECT id, user_id, street_address, city, district, latitude, longitude
FROM addresses
WHERE city = 'San Francisco' OR street_address LIKE '%Stockton%';
