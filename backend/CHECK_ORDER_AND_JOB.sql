-- 🔍 Check Order and Job Offer Status
-- Order Number: ORD-2026-000013
-- Customer Phone: 0500756706

-- ============================================
-- STEP 1: Find the Order
-- ============================================
SELECT 
  '📦 ORDER INFO:' as info,
  o.id as order_id,
  o.order_number,
  o.status as order_status,
  o.driver_id,
  o.created_at,
  o.updated_at
FROM orders o
WHERE o.order_number = 'ORD-2026-000013'
   OR o.id IN (
     SELECT o2.id FROM orders o2
     JOIN users u ON u.id = o2.user_id
     WHERE u.phone = '0500756706'
     ORDER BY o2.created_at DESC
     LIMIT 1
   );

-- ============================================
-- STEP 2: Check if Job Offer Exists
-- ============================================
SELECT 
  '🚗 JOB OFFER INFO:' as info,
  jo.id as job_offer_id,
  jo.order_id,
  jo.status as job_status,
  jo.accepted_by_driver_id,
  jo.expires_at,
  jo.created_at,
  CASE 
    WHEN jo.expires_at < NOW() THEN '❌ EXPIRED'
    WHEN jo.status = 'pending' THEN '✅ PENDING - Available'
    WHEN jo.status = 'accepted' THEN '✅ ACCEPTED'
    ELSE '⚠️ ' || jo.status
  END as job_status_desc
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

-- ============================================
-- STEP 3: Check Driver Status
-- ============================================
SELECT 
  '👤 DRIVER INFO:' as info,
  d.id as driver_id,
  d.phone_number,
  d.full_name,
  d.status as driver_status,
  d.is_online,
  d.identity_verified
FROM drivers d
WHERE d.phone_number = '0500756756'
   OR d.status = 'approved';

-- ============================================
-- STEP 4: Check Order Status History
-- ============================================
SELECT 
  '📊 ORDER STATUS HISTORY:' as info,
  o.order_number,
  o.status,
  o.driver_id,
  CASE 
    WHEN o.status = 'pending' THEN '1️⃣ PENDING'
    WHEN o.status = 'confirmed' THEN '2️⃣ CONFIRMED'
    WHEN o.status = 'preparing' THEN '3️⃣ PREPARING'
    WHEN o.status = 'ready' THEN '4️⃣ READY ⚠️ (Job Offer should be created here)'
    WHEN o.status = 'out_for_delivery' THEN '5️⃣ OUT FOR DELIVERY'
    WHEN o.status = 'delivered' THEN '6️⃣ DELIVERED'
    ELSE o.status
  END as status_description,
  o.created_at,
  o.updated_at
FROM orders o
WHERE o.order_number = 'ORD-2026-000013'
   OR o.id IN (
     SELECT o2.id FROM orders o2
     JOIN users u ON u.id = o2.user_id
     WHERE u.phone = '0500756706'
     ORDER BY o2.created_at DESC
     LIMIT 1
   );
