# 🛠️ Driver App - Tech Stack & Decisions

**التاريخ:** 25 يناير 2026  
**الهدف:** توضيح التقنيات والاختيارات للـ Driver App

---

## 🎨 **1. Theme & Design System**

### ✅ **نعم - سأستخدم الثيم الموحد (Shared Theme)** ⭐⭐⭐⭐⭐

#### **الاستراتيجية:**
```dart
// driver_app/lib/core/theme/driver_theme.dart
import 'package:shared/design_system/design_system.dart';

class DriverTheme {
  // ✅ Uses shared colors
  static const Color primary = AppColors.primary; // Sunset Orange
  static const Color accent = AppColors.accent;   // Gold
  
  // ⚠️ Driver-specific variants
  static const double touchTargetMinSize = 48.0; // Larger (vs 44.0)
  static const double fontScaleFactor = 1.1;      // +10% larger
  
  // ⚠️ Higher contrast for navigation
  static const Color navigationText = AppColors.textPrimary;
  static const Color navigationBackground = AppColors.background;
}
```

#### **ما سيتشارك:**
- ✅ **Colors** - نفس الألوان (Sunset Orange, Gold)
- ✅ **Typography** - نفس الخطوط والأحجام (مع scale factor للـ driver)
- ✅ **Spacing** - نفس المسافات
- ✅ **Component Themes** - نفس themes للـ buttons/inputs

#### **ما سيكون مختلفاً:**
- ⚠️ **Touch Targets** - أكبر (48.0 vs 44.0)
- ⚠️ **Font Scale** - +10% أكبر
- ⚠️ **Contrast** - أعلى للـ navigation

#### **الملفات:**
- ✅ `packages/shared/lib/design_system/` - Shared theme
- ✅ `driver_app/lib/core/theme/driver_theme.dart` - Driver variants

---

## 🗺️ **2. Google Maps**

### ✅ **سأستخدم نفس الإصدار المستخدم في Customer App** ⭐⭐⭐⭐

#### **الإصدار الحالي:**
```yaml
# customer_app/pubspec.yaml
google_maps_flutter: ^2.5.0
```

#### **القرار:**
- ✅ **استخدام `google_maps_flutter: ^2.5.0`** - نفس الإصدار
- ✅ **الاتساق** - نفس الـ API و behavior
- ✅ **Stability** - إصدار مستقر وموثوق

#### **Google Maps الجديد (Maps SDK for Flutter v3.x):**
- ⚠️ **لا - لن أستخدمه الآن** - لا يزال في beta
- ⚠️ **يمكن الترقية لاحقاً** - عندما يصبح stable

#### **السبب:**
1. ✅ **Consistency** - نفس الإصدار في customer_app
2. ✅ **Stability** - v2.5.0 مستقر وموثوق
3. ✅ **Compatibility** - يعمل بشكل جيد مع Flutter
4. ⚠️ **v3.x** - لا يزال في beta (قد يكون غير مستقر)

---

## 📦 **3. Dependencies (Driver App)**

### **Core Dependencies:**
```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management (Same as customer_app)
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # Routing (Same as customer_app)
  go_router: ^12.1.3

  # Network (Shared package)
  shared:
    path: ../packages/shared

  # Maps & Location (Same version as customer_app)
  google_maps_flutter: ^2.5.0  # ✅ Same version
  geolocator: ^10.1.0
  geocoding: ^2.1.1

  # Location (Driver-specific)
  location: ^6.0.0              # ⚠️ For background location
  permission_handler: ^11.0.0   # ⚠️ For permissions

  # Audio (Driver-specific)
  audioplayers: ^5.2.0          # ⚠️ For sound notifications

  # Local Storage (Shared package)
  # flutter_secure_storage: ^9.0.0  # In shared package
  # shared_preferences: ^2.2.2      # In shared package

  # Utils (Shared package)
  # intl: ^0.18.1                  # In shared package
```

---

## 🏗️ **4. Architecture**

### ✅ **Clean Architecture (Same as customer_app)**
```
driver_app/
├─ lib/
│  ├─ core/                    # Infrastructure
│  │  ├─ theme/               # DriverTheme (extends shared)
│  │  ├─ network/             # Endpoints (driver-specific)
│  │  ├─ location/            # Location services (driver-specific)
│  │  ├─ maps/                # Maps integration
│  │  └─ routing/              # Routes (driver-specific)
│  │
│  ├─ modules/                 # Feature modules
│  │  ├─ auth/                # Auth (OTP, PIN)
│  │  ├─ driver_profile/      # Profile, availability
│  │  ├─ jobs/                # Jobs (inbox, active)
│  │  ├─ delivery/            # Delivery flow
│  │  └─ notifications/       # Notifications
│  │
│  └─ shared/                 # Shared code (from shared package)
│     └─ (imported from packages/shared)
```

---

## 🎯 **5. Key Differences from Customer App**

### **Driver-Specific Features:**

#### **1. Location Services** 🔴
```dart
// driver_app/lib/core/location/
├─ location_service.dart              // Continuous tracking
├─ background_location_service.dart   // Background location
├─ location_throttler.dart            // Battery optimization
└─ location_models.dart               // Location models
```

#### **2. Maps Integration** 🔴
```dart
// driver_app/lib/core/maps/
├─ map_provider.dart        // Google Maps wrapper
├─ route_launcher.dart      // Open external maps (Waze, Google Maps)
└─ navigation_service.dart  // Turn-by-turn navigation
```

#### **3. Audio/Sound** 🔴
```dart
// driver_app/lib/core/audio/
├─ sound_player.dart        // Sound notifications
└─ sound_assets.dart        // Sound files
```

#### **4. Background Services** 🔴
```dart
// driver_app/lib/core/services/
├─ background_location_service.dart   // Background location
└─ foreground_service.dart            // Foreground service (Android)
```

---

## 📋 **6. Summary**

### ✅ **ما سيتشارك:**
1. ✅ **Theme** - Shared design system (مع driver variants)
2. ✅ **Network** - Shared API client (مع driver endpoints)
3. ✅ **Storage** - Shared secure storage
4. ✅ **Errors** - Shared error handling
5. ✅ **Utils** - Shared validators/formatters
6. ✅ **Google Maps** - نفس الإصدار (2.5.0)

### ❌ **ما سيكون مختلفاً:**
1. ❌ **Location Services** - Continuous tracking (Driver-specific)
2. ❌ **Maps** - Navigation features (Driver-specific)
3. ❌ **Audio** - Sound notifications (Driver-specific)
4. ❌ **Background Services** - Background location (Driver-specific)
5. ❌ **Routes** - Completely different navigation
6. ❌ **Endpoints** - Driver-specific endpoints

---

## 🎯 **الخلاصة:**

### ✅ **Theme:**
- ✅ **نعم** - سأستخدم الثيم الموحد من shared package
- ⚠️ **مع variants** - Touch targets أكبر، Font scale أكبر، Contrast أعلى

### ✅ **Google Maps:**
- ✅ **نعم** - سأستخدم `google_maps_flutter: ^2.5.0` (نفس customer_app)
- ❌ **لا** - لن أستخدم Google Maps الجديد (v3.x) - لا يزال في beta

---

**كل شيء واضح ومحدد!** ✅
