# Customer App - Flutter Project Structure

## 📁 Project Structure

هذا المشروع يتبع Clean Architecture مع Feature-based modules.

### ✅ الهيكل الكامل

```
customer_app/
├─ lib/
│  ├─ main.dart                    # Entry point
│  ├─ app.dart                     # MaterialApp configuration
│  ├─ bootstrap.dart               # App initialization
│  │
│  ├─ core/                        # Core infrastructure
│  │  ├─ config/                   # App configuration
│  │  ├─ routing/                  # Navigation & routing
│  │  ├─ theme/                    # Design system
│  │  ├─ network/                  # API client & interceptors
│  │  ├─ storage/                 # Local & secure storage
│  │  ├─ video/                    # Video management
│  │  ├─ delivery/                # Delivery calculations
│  │  ├─ utils/                    # Utilities
│  │  ├─ errors/                   # Error handling
│  │  ├─ widgets/                  # Reusable widgets
│  │  └─ di/                       # Dependency injection
│  │
│  ├─ modules/                     # Feature modules
│  │  ├─ auth/                     # Authentication
│  │  ├─ feed/                     # Video feed
│  │  ├─ addresses/                # Address management
│  │  ├─ vendors/                  # Restaurants
│  │  ├─ cart/                     # Shopping cart
│  │  ├─ orders/                   # Order management
│  │  ├─ payments/                 # Payment processing
│  │  ├─ map_location/             # Maps & geocoding
│  │  ├─ search/                   # Search functionality
│  │  └─ profile/                  # User profile
│  │
│  └─ shared/                      # Shared code
│     ├─ models/                   # Shared models
│     ├─ enums/                    # Enumerations
│     └─ extensions/               # Extensions
│
└─ assets/                         # Assets
   ├─ images/                      # Images
   ├─ fonts/                       # Fonts
   ├─ icons/                       # Icons
   └─ lottie/                      # Animations
```

## 🎯 Modules Overview

### Auth Module
- OTP authentication
- PIN setup & verification
- Biometric authentication
- Token management

### Feed Module
- Video feed (one dish at a time)
- Swipe interactions
- ETA display
- Add to cart

### Addresses Module
- Address management
- Delivery zone validation
- Map selection

### Vendors Module
- Restaurant details
- Menu items
- Signature dishes
- Reviews

### Cart Module
- Shopping cart
- Single vendor enforcement
- Checkout flow

### Orders Module
- Order creation
- Order tracking
- Order history
- Rating

### Payments Module
- Payment gateways (Apple Pay, Mada, STC Pay)
- Payment processing
- Payment confirmation

### Map Location Module
- Current location
- Reverse geocoding
- Distance calculation

### Search Module
- Vendor search (Phase 1)
- Menu search (Phase 2+)

### Profile Module
- User profile
- Profile editing

## 🚀 Getting Started

1. Install dependencies:
```bash
flutter pub get
```

2. Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Run the app:
```bash
flutter run
```

## 📝 Notes

- All files are created as empty placeholders
- Follow Clean Architecture principles
- Use Riverpod for state management
- Use GoRouter for navigation

## ✅ Next Steps

1. Implement core infrastructure
2. Implement auth module
3. Implement feed module
4. Implement remaining modules
