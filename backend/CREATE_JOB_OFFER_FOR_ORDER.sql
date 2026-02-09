-- ✅ Create Job Offer for Existing Order
-- Order Number: ORD-2026-000013
-- This will create a job offer so driver can see it

-- ============================================
-- STEP 1: Find Order Details
-- ============================================
SELECT 
  '📦 Finding Order...' as step,
  o.id as order_id,
  o.order_number,
  o.status,
  o.delivery_fee,
  v.latitude as vendor_lat,
  v.longitude as vendor_lng,
  a.latitude as address_lat,
  a.longitude as address_lng
FROM orders o
JOIN vendors v ON v.id = o.vendor_id
JOIN addresses a ON a.id = o.address_id
WHERE o.order_number = 'ORD-2026-000013'
   OR o.id IN (
     SELECT o2.id FROM orders o2
     JOIN users u ON u.id = o2.user_id
     WHERE u.phone = '0500756706'
     ORDER BY o2.created_at DESC
     LIMIT 1
   );

-- ============================================
-- STEP 2: Create Job Offer
-- ============================================
INSERT INTO job_offers (
  id,
  order_id,
  status,
  delivery_fee,
  driver_earnings,
  pickup_latitude,
  pickup_longitude,
  delivery_latitude,
  delivery_longitude,
  estimated_distance,
  estimated_duration,
  expires_at,
  created_at,
  updated_at
)
SELECT 
  gen_random_uuid(),
  o.id,
  'pending',
  o.delivery_fee,
  o.delivery_fee * 0.8,  -- 80% to driver
  v.latitude,
  v.longitude,
  a.latitude,
  a.longitude,
  5.0,  -- km (placeholder)
  15,   -- minutes (placeholder)
  NOW() + INTERVAL '10 minutes',
  NOW(),
  NOW()
FROM orders o
JOIN vendors v ON v.id = o.vendor_id
JOIN addresses a ON a.id = o.address_id
WHERE o.order_number = 'ORD-2026-000013'
   OR o.id IN (
     SELECT o2.id FROM orders o2
     JOIN users u ON u.id = o2.user_id
     WHERE u.phone = '0500756706'
     ORDER BY o2.created_at DESC
     LIMIT 1
   )
  AND NOT EXISTS (
    SELECT 1 FROM job_offers jo 
    WHERE jo.order_id = o.id
  );

-- ============================================
-- STEP 3: Verify Job Offer Created
-- ============================================
SELECT 
  '✅ Job Offer Created!' as result,
  jo.id as job_offer_id,
  jo.order_id,
  jo.status,
  jo.expires_at,
  CASE 
    WHEN jo.expires_at < NOW() THEN '❌ EXPIRED'
    WHEN jo.status = 'pending' THEN '✅ PENDING - Driver can see it'
    ELSE '⚠️ ' || jo.status
  END as status_desc
FROM job_offers jo
WHERE jo.order_id IN (
  SELECT o.id FROM orders o
  WHERE o.order_number = 'ORD-2026-000013'
     OR o.id IN (
       SELECT o2.id FROM orders o2
       JOIN users u ON u.id = o2.user_id
       WHERE u.phone = '0500756706'
       ORDER BY o2.created_at DESC
       LIMIT 1
     )
);
