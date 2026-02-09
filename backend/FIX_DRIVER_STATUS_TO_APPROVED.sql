-- ✅ Fix Driver Status to Approved
-- This script ensures the test driver account has status = 'approved'
-- Phone: 0500756756

-- ============================================
-- UPDATE DRIVER STATUS TO APPROVED
-- ============================================
UPDATE drivers
SET 
  status = 'approved',
  updated_at = NOW()
WHERE phone_number = '0500756756' 
   OR phone_number = '+966500756756'
   OR user_id IN (
     SELECT id FROM users 
     WHERE phone = '0500756756' OR phone = '+966500756756'
   );

-- ============================================
-- VERIFY
-- ============================================
SELECT '✅ Driver Status Updated to Approved!' as status;

SELECT 
  u.phone,
  u.name,
  d.national_id,
  d.status,
  d.is_online,
  d.full_name,
  d.email
FROM users u
LEFT JOIN drivers d ON d.user_id = u.id
WHERE u.phone = '0500756756' OR u.phone = '+966500756756';
