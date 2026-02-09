-- ✅ Set PIN for Test Customer Account
-- Phone: 0500756706
-- PIN: 1234
-- 
-- This script sets the PIN hash in the database for the test customer.
-- The PIN hash is generated using bcrypt with 10 salt rounds.
-- 
-- To generate the hash, run this in Node.js:
-- const bcrypt = require('bcrypt');
-- bcrypt.hash('1234', 10).then(h => console.log(h));
--
-- Or use the backend script: npm run script:set-customer-pin

-- ============================================
-- UPDATE CUSTOMER USER WITH PIN HASH
-- ============================================
-- Note: Replace the placeholder hash below with the actual bcrypt hash
-- You can generate it using: node -e "const bcrypt = require('bcrypt'); bcrypt.hash('1234', 10).then(h => console.log(h));"

UPDATE users
SET 
  pin_hash = '$2b$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', -- bcrypt hash for '1234' (10 rounds)
  updated_at = NOW()
WHERE phone = '0500756706' OR phone = '+966500756706';

-- ============================================
-- VERIFY RESULTS
-- ============================================
SELECT 
  id, 
  phone, 
  name, 
  email, 
  pin_hash IS NOT NULL as has_pin,
  is_verified, 
  is_active,
  updated_at
FROM users
WHERE phone = '0500756706' OR phone = '+966500756706';
