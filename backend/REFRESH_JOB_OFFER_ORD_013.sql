-- Order ORD-2026-000013 exists; a job_offer already exists (that's why INSERT 0 0).
-- Inbox only shows: status = 'pending' AND expires_at > NOW().
-- Run this to see the current job_offer and refresh it so the driver sees it.

-- 1) Show current job_offer
SELECT id, order_id, status, expires_at,
       CASE WHEN expires_at < NOW() THEN 'EXPIRED' ELSE 'VALID' END AS expiry
FROM job_offers
WHERE order_id = '1edf2839-c0d0-4765-bcc9-5c384d2fb8c3';

-- 2) Refresh: set pending + extend expiry (only if not already accepted/completed)
UPDATE job_offers
SET status = 'pending',
    expires_at = NOW() + INTERVAL '30 minutes',
    updated_at = NOW()
WHERE order_id = '1edf2839-c0d0-4765-bcc9-5c384d2fb8c3'
  AND status <> 'accepted';

-- 3) Verify (run after the UPDATE)
SELECT id, order_id, status, expires_at,
       CASE WHEN expires_at < NOW() THEN 'EXPIRED' ELSE 'VALID' END AS expiry
FROM job_offers
WHERE order_id = '1edf2839-c0d0-4765-bcc9-5c384d2fb8c3';
