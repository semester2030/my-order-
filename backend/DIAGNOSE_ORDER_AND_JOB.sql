-- Diagnose: Why INSERT 0 0?
-- 1) Check if order exists
SELECT 'Orders with number ORD-2026-000013:' AS step;
SELECT id, order_number, status, delivery_fee, vendor_id, address_id
FROM orders
WHERE order_number = 'ORD-2026-000013';

-- 2) Check orders for customer 0500756706
SELECT 'Orders for customer 0500756706:' AS step;
SELECT o.id, o.order_number, o.status, o.delivery_fee, o.vendor_id, o.address_id
FROM orders o
JOIN users u ON u.id = o.user_id
WHERE u.phone = '0500756706'
ORDER BY o.created_at DESC
LIMIT 5;

-- 3) Check if job_offers exist for those orders
SELECT 'Job offers for these orders:' AS step;
SELECT jo.id, jo.order_id, jo.status, jo.expires_at,
       CASE WHEN jo.expires_at < NOW() THEN 'EXPIRED' ELSE 'VALID' END AS expiry
FROM job_offers jo
WHERE jo.order_id IN (
  SELECT id FROM orders WHERE order_number = 'ORD-2026-000013'
  UNION
  SELECT o.id FROM orders o JOIN users u ON u.id = o.user_id
  WHERE u.phone = '0500756706' ORDER BY o.created_at DESC LIMIT 5
);

-- 4) List recent orders (any) to find correct order_number
SELECT 'Recent orders (last 5):' AS step;
SELECT id, order_number, status, total, created_at
FROM orders
ORDER BY created_at DESC
LIMIT 5;
