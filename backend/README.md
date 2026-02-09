# Customer Backend - NestJS API

## 📁 Project Structure

هذا المشروع يتبع NestJS Modular Architecture.

### ✅ الهيكل الكامل

```
backend/
├─ src/
│  ├─ common/                    # Shared code
│  │  ├─ decorators/
│  │  ├─ filters/
│  │  ├─ guards/
│  │  ├─ interceptors/
│  │  ├─ pipes/
│  │  └─ utils/
│  │
│  ├─ config/                    # Configuration
│  │  ├─ database.config.ts
│  │  ├─ cloudflare.config.ts
│  │  └─ payment.config.ts
│  │
│  ├─ modules/                   # Feature modules
│  │  ├─ auth/                  # Authentication
│  │  ├─ users/                 # User management
│  │  ├─ addresses/             # Address management
│  │  ├─ vendors/               # Restaurant management
│  │  ├─ menu/                  # Menu items
│  │  ├─ videos/                # Cloudflare Stream
│  │  ├─ feed/                  # Feed algorithm
│  │  ├─ cart/                  # Shopping cart
│  │  ├─ orders/                # Order management
│  │  ├─ delivery/              # Delivery management
│  │  ├─ drivers/               # Driver management (future)
│  │  ├─ payments/              # Payment processing
│  │  ├─ notifications/         # Notifications
│  │  └─ admin/                 # Admin panel
│  │
│  ├─ main.ts                    # Entry point
│  └─ app.module.ts             # Root module
│
├─ test/                         # E2E tests
├─ package.json
├─ tsconfig.json
└─ nest-cli.json
```

## 🎯 Modules Overview

### Auth Module
- OTP authentication
- PIN verification
- JWT tokens
- Biometric support

### Users Module
- User management
- User profiles
- User settings

### Addresses Module
- Address CRUD
- Delivery zone validation
- Default address management

### Vendors Module
- Restaurant management
- Vendor profiles
- Vendor settings

### Menu Module
- Menu items
- Video assets
- Signature dishes

### Videos Module
- Cloudflare Stream integration
- Video upload (init/complete)
- Video asset management

### Feed Module
- Feed algorithm
- Eligibility checking
- Feed balancing

### Cart Module
- Shopping cart
- Single vendor enforcement
- Cart operations

### Orders Module
- Order creation
- Order lifecycle
- Order events

### Delivery Module
- Order assignment
- Driver tracking
- Route optimization
- Delivery status

### Drivers Module (Future)
- Driver registration
- Driver verification
- Driver profile
- Driver ratings
- Driver earnings

### Payments Module
- Payment gateways (Apple Pay, Mada, STC Pay)
- Payment processing
- Webhooks
- Reconciliation

### Notifications Module
- Customer notifications
- Driver notifications
- Vendor notifications

### Admin Module
- Admin panel
- Analytics
- Management

## 🚀 Getting Started

1. Install dependencies:
```bash
npm install
```

2. Copy environment file:
```bash
cp .env.example .env
```

3. Update `.env` with your configuration

4. Run database migrations:
```bash
npm run migration:run
```

5. Start the server:
```bash
# Development
npm run start:dev

# Production
npm run start:prod
```

## 📝 Notes

- All files are created as empty placeholders
- Follow NestJS best practices
- Use TypeORM for database
- Use JWT for authentication
- Use Cloudflare Stream for videos

## ✅ Next Steps

1. Configure database connection
2. Implement auth module
3. Implement core modules
4. Implement Cloudflare Stream integration
5. Implement payment gateways
