# Vendor Authentication Integration

## Current Status

The Vendor Web App is ready, but we need to ensure the backend has a vendor login endpoint.

## Backend Requirements

The backend should have:
1. `POST /api/auth/login` - Accepts email/password for vendors
2. Returns JWT token with vendor user info
3. Vendor user should be linked to VendorStaff entity

## If Backend Doesn't Have Vendor Login Yet

We need to add to `backend/src/modules/auth/auth.controller.ts`:

```typescript
@Post('vendor/login')
async vendorLogin(@Body() dto: VendorLoginDto) {
  return this.authService.vendorLogin(dto);
}
```

And in `auth.service.ts`:

```typescript
async vendorLogin(dto: VendorLoginDto) {
  // Find vendor staff by email
  // Verify password
  // Return JWT token
}
```

## Temporary Solution

For now, the frontend is configured to use `/api/auth/login`. If the backend doesn't support vendor login yet, you can:

1. Add vendor login endpoint to backend
2. Or modify frontend to use a different endpoint
3. Or use the existing user login and check if user is a vendor staff member
