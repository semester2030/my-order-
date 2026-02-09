-- Run in: psql -d customer_app
-- Copy-paste each block one at a time (or run the file: \i RUN_IN_PSQL_NOW.sql)
--
-- INSERT 0 0 means: either no order matched OR a job_offer already exists (NOT EXISTS skipped).
-- Run step 1 and 2 to see which. Then run 3b (refresh existing) and 3c (create if missing); safe to run both.

-- ========== 1) Does the order exist? ==========
SELECT id, order_number, status, delivery_fee, vendor_id, address_id
FROM orders
WHERE order_number = 'ORD-2026-000013';

-- ========== 2) Is there already a job_offer for this order? ==========
SELECT jo.id, jo.order_id, jo.status, jo.expires_at,
       CASE WHEN jo.expires_at < NOW() THEN 'EXPIRED' ELSE 'VALID' END AS expiry
FROM job_offers jo
WHERE jo.order_id = (SELECT id FROM orders WHERE order_number = 'ORD-2026-000013' LIMIT 1);

-- ========== 3a) If NO ROW in step 1: order_number might be different. List recent orders: ==========
-- SELECT id, order_number, status, created_at FROM orders ORDER BY created_at DESC LIMIT 10;

-- ========== 3b) If step 2 returned a row (job exists but maybe EXPIRED): refresh it ==========
-- Run this to make an existing job_offer visible again (extends expiry, resets to pending):
UPDATE job_offers
SET status = 'pending',
    expires_at = NOW() + INTERVAL '30 minutes',
    updated_at = NOW()
WHERE order_id = (SELECT id FROM orders WHERE order_number = 'ORD-2026-000013' LIMIT 1)
  AND status <> 'accepted';

-- ========== 3c) If step 1 returned a row but step 2 returned NO ROW: create job offer ==========
-- Run this only when order exists and no job_offer exists (INSERT 0 0 was due to NOT EXISTS):
INSERT INTO job_offers (
  id, order_id, status, delivery_fee, driver_earnings,
  pickup_latitude, pickup_longitude, delivery_latitude, delivery_longitude,
  estimated_distance, estimated_duration, expires_at, created_at, updated_at
)
SELECT
  gen_random_uuid(),
  o.id,
  'pending',
  o.delivery_fee,
  o.delivery_fee * 0.8,
  v.latitude, v.longitude,
  a.latitude, a.longitude,
  5.0, 15,
  NOW() + INTERVAL '30 minutes',
  NOW(), NOW()
FROM orders o
JOIN vendors v ON v.id = o.vendor_id
JOIN addresses a ON a.id = o.address_id
WHERE o.order_number = 'ORD-2026-000013'
  AND NOT EXISTS (SELECT 1 FROM job_offers jo WHERE jo.order_id = o.id);
