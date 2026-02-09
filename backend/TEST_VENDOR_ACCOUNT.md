# Test Vendor Account

## Account Details:

**Email:** `cy-20@outlook.com`  
**Password:** `test123456`

## How to Use:

1. The backend now has a vendor login endpoint: `POST /api/auth/vendor/login`
2. The test account is configured to work with this email/password
3. Frontend is configured to use `/api/auth/vendor/login`

## Important Notes:

- The test account will work if:
  1. User exists with email `cy-20@outlook.com`
  2. User is linked to a vendor via VendorStaff
  3. Password is `test123456`

- If the account doesn't exist, you need to:
  1. Create a user with this email
  2. Create a vendor
  3. Link them via VendorStaff

## Quick Setup:

You can manually create the account in the database or use the script in:
`backend/src/modules/auth/scripts/create-test-vendor.ts`
