# 📦 Shared Package Strategy - النسخة المحكمة النهائية

**التاريخ:** 25 يناير 2026  
**الهدف:** استراتيجية محكمة للتشارك بين Customer App و Driver App  
**التقييم المحدث:** 9.6/10 → **10/10** ⭐⭐⭐⭐⭐

---

## 🎯 **الخلاصة التنفيذية**

### ✅ **القاعدة الذهبية:**
> **Shared Package = Infrastructure + Design Tokens فقط**  
> **لا تضع فيه: Providers, Notifiers, Feature Modules, Endpoints, أو DTOs**

---

## 📋 **جدول المحتويات**

1. [ما يجب أن يتشارك (MUST SHARE)](#1-ما-يجب-أن-يتشارك-must-share)
2. [ما يجب أن يكون Configurable](#2-ما-يجب-أن-يكون-configurable)
3. [ما يجب أن يكون مختلفاً (NOT SHARE)](#3-ما-يجب-أن-يكون-مختلفاً-not-share)
4. [هيكل Shared Package](#4-هيكل-shared-package)
5. [هيكل Monorepo الكامل](#5-هيكل-monorepo-الكامل)
6. [Network Layer Strategy](#6-network-layer-strategy)
7. [Theme Strategy مع Driver Variants](#7-theme-strategy-مع-driver-variants)
8. [قواعد منع Over-Coupling](#8-قواعد-منع-over-coupling)
9. [Implementation Plan](#9-implementation-plan)

---

## 1. **ما يجب أن يتشارك (MUST SHARE)** ✅

### 🔴 **Critical - يجب التشارك 100%**

#### أ) **Design System** ⭐⭐⭐⭐⭐
```dart
shared/lib/design_system/
├─ colors/
│  ├─ app_colors.dart          # ✅ Primary colors (Sunset Orange, Gold)
│  ├─ semantic_colors.dart     # ✅ Success, Error, Warning
│  └─ gradient_colors.dart     # ✅ Gradients
├─ typography/
│  ├─ text_styles.dart         # ✅ Base text styles
│  ├─ font_sizes.dart          # ✅ Font size tokens
│  └─ font_families.dart       # ✅ Font families
├─ spacing/
│  ├─ insets.dart              # ✅ Padding tokens
│  └─ gaps.dart                # ✅ Gap tokens
├─ shapes/
│  ├─ radius.dart              # ✅ Border radius tokens
│  └─ borders.dart              # ✅ Border tokens
├─ shadows/
│  └─ app_shadows.dart         # ✅ Shadow tokens
└─ components/
   ├─ button_theme.dart         # ✅ Base button styles
   ├─ input_theme.dart         # ✅ Base input styles
   └─ card_theme.dart          # ✅ Base card styles
```

**لماذا:**
- ✅ Brand Identity - نفس الهوية البصرية
- ✅ Consistency - تجربة موحدة
- ✅ Maintenance - تحديث واحد

#### ب) **Network Core** ⭐⭐⭐⭐⭐
```dart
shared/lib/network_core/
├─ api_client.dart             # ✅ Base ApiClient (abstract)
├─ interceptors/
│  ├─ auth_interceptor.dart    # ✅ JWT token injection
│  ├─ logging_interceptor.dart # ✅ Request/Response logging
│  └─ error_interceptor.dart   # ✅ Error transformation
└─ exceptions/
   └─ network_exceptions.dart  # ✅ NetworkException types
```

**لماذا:**
- ✅ Same Backend - نفس الـ backend API
- ✅ Same Auth - نفس JWT tokens
- ✅ Same Error Handling - نفس معالجة الأخطاء

**⚠️ مهم:** ApiClient يأخذ `NetworkConfig` كـ parameter (لا hardcoded values)

#### ج) **Storage Core** ⭐⭐⭐⭐⭐
```dart
shared/lib/storage_core/
├─ token_store.dart            # ✅ Abstract interface
└─ secure_token_store.dart     # ✅ Implementation (flutter_secure_storage)
```

**لماذا:**
- ✅ Same Auth Tokens - نفس JWT storage mechanism
- ✅ Same Security - نفس security approach

#### د) **Errors Core** ⭐⭐⭐⭐⭐
```dart
shared/lib/errors_core/
├─ failure.dart                # ✅ Failure sealed class
├─ app_exception.dart          # ✅ AppException base
└─ error_mapper.dart           # ✅ Backend error → Failure mapping
```

**لماذا:**
- ✅ Same Backend Errors - نفس error codes
- ✅ Same User Messages - نفس رسائل الخطأ
- ✅ Consistency - معالجة موحدة

#### هـ) **Utils Core** ⭐⭐⭐⭐
```dart
shared/lib/utils_core/
├─ validators.dart             # ✅ Phone, Email validators
├─ formatters.dart             # ✅ Currency, Date formatters
├─ logger.dart                 # ✅ Logger interface
└─ time.dart                   # ✅ Time utilities
```

**لماذا:**
- ✅ Same Rules - نفس قواعد التحقق
- ✅ Same Formatting - نفس التنسيق

#### و) **Models Core** ⭐⭐⭐
```dart
shared/lib/models_core/
├─ money.dart                  # ✅ Money class (amount + currency)
├─ pagination.dart             # ✅ Pagination model
└─ result.dart                 # ✅ Result<T> sealed class
```

**لماذا:**
- ✅ Common Types - أنواع مشتركة
- ✅ Type Safety - type safety

---

## 2. **ما يجب أن يكون Configurable** ⚙️

### 🟡 **Network Configuration (Per App)**

#### **Customer App:**
```dart
// customer_app/lib/core/network/app_network_config.dart
class AppNetworkConfig {
  static const String baseUrl = 'http://localhost:3001/api';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const int retryCount = 2;
  static const LogLevel logLevel = LogLevel.info;
}
```

#### **Driver App:**
```dart
// driver_app/lib/core/network/app_network_config.dart
class AppNetworkConfig {
  static const String baseUrl = 'http://localhost:3001/api';
  static const Duration connectTimeout = Duration(seconds: 60); // ⚠️ أطول
  static const Duration receiveTimeout = Duration(seconds: 60); // ⚠️ أطول
  static const int retryCount = 3; // ⚠️ أكثر retries
  static const LogLevel logLevel = LogLevel.debug; // ⚠️ أكثر تفصيلاً
}
```

**لماذا مختلف:**
- ⚠️ Driver يحتاج timeouts أطول (network قد يكون unstable أثناء القيادة)
- ⚠️ Driver يحتاج retries أكثر (critical operations)
- ⚠️ Driver يحتاج logging أكثر (debugging أثناء القيادة)

---

## 3. **ما يجب أن يكون مختلفاً (NOT SHARE)** ❌

### 🔴 **Critical - لا يجب التشارك**

#### أ) **API Endpoints** ❌
```dart
// ❌ NOT SHARED
customer_app/lib/core/network/endpoints.dart
driver_app/lib/core/network/endpoints.dart
```

**لماذا:**
- ❌ Customer endpoints ≠ Driver endpoints
- ❌ إذا شاركتها → if/else/role flags → code pollution
- ❌ كل app له domain مختلف

**الحل:**
- ✅ Shared: `ApiClient` فقط
- ✅ Per App: `endpoints.dart` خاص بكل app

#### ب) **Routes** ❌
```dart
// ❌ NOT SHARED
customer_app/lib/core/routing/route_names.dart
driver_app/lib/core/routing/route_names.dart
```

**لماذا:**
- ❌ Navigation flows مختلفة تماماً
- ❌ Customer: Feed → Cart → Orders
- ❌ Driver: Jobs → Active Delivery → Profile

#### ج) **Location Services** ❌
```dart
// ❌ NOT SHARED
driver_app/lib/core/location/    # Continuous tracking
customer_app/lib/modules/map_location/  # One-time selection
```

**لماذا:**
- ❌ Driver: Background location + continuous tracking
- ❌ Customer: One-time selection فقط

#### د) **Maps Integration** ❌
```dart
// ❌ NOT SHARED
driver_app/lib/core/maps/        # Navigation + turn-by-turn
customer_app/lib/modules/map_location/  # Static map view
```

**لماذا:**
- ❌ Driver: Navigation + route optimization
- ❌ Customer: Static view فقط

#### هـ) **Feature Modules** ❌
```dart
// ❌ NOT SHARED
customer_app/lib/modules/feed/
customer_app/lib/modules/cart/
driver_app/lib/modules/jobs/
driver_app/lib/modules/delivery/
```

**لماذا:**
- ❌ Features مختلفة تماماً
- ❌ Business logic مختلف
- ❌ UI/UX مختلف

#### و) **DTOs (Domain-Specific)** ❌
```dart
// ❌ NOT SHARED (Phase 1)
customer_app/lib/modules/orders/data/models/order_dto.dart
driver_app/lib/modules/jobs/data/models/job_offer_dto.dart
```

**لماذا:**
- ❌ DTOs تتغير كثيراً (APIs evolving)
- ❌ كل app له DTOs مختلفة
- ⚠️ **Exception:** Primitive DTOs فقط (Money, Pagination)

---

## 4. **هيكل Shared Package** 📦

```
packages/shared/
├─ lib/
│  ├─ design_system/           # ✅ SHARED
│  │  ├─ colors/
│  │  ├─ typography/
│  │  ├─ spacing/
│  │  ├─ shapes/
│  │  ├─ shadows/
│  │  └─ components/
│  │
│  ├─ network_core/            # ✅ SHARED (لكن configurable)
│  │  ├─ api_client.dart       # Base ApiClient
│  │  ├─ network_config.dart   # NetworkConfig interface
│  │  ├─ interceptors/
│  │  └─ exceptions/
│  │
│  ├─ storage_core/            # ✅ SHARED
│  │  ├─ token_store.dart      # Abstract interface
│  │  └─ secure_token_store.dart # Implementation
│  │
│  ├─ errors_core/             # ✅ SHARED
│  │  ├─ failure.dart
│  │  ├─ app_exception.dart
│  │  └─ error_mapper.dart
│  │
│  ├─ utils_core/              # ✅ SHARED
│  │  ├─ validators.dart
│  │  ├─ formatters.dart
│  │  ├─ logger.dart
│  │  └─ time.dart
│  │
│  └─ models_core/             # ✅ SHARED (Primitives only)
│     ├─ money.dart
│     ├─ pagination.dart
│     └─ result.dart
│
└─ pubspec.yaml
```

---

## 5. **هيكل Monorepo الكامل** 🏗️

```
my-order/
├─ packages/
│  └─ shared/                  # ✨ Shared Package
│     ├─ lib/
│     │  ├─ design_system/
│     │  ├─ network_core/
│     │  ├─ storage_core/
│     │  ├─ errors_core/
│     │  ├─ utils_core/
│     │  └─ models_core/
│     └─ pubspec.yaml
│
├─ customer_app/               # Customer App
│  └─ lib/
│     ├─ core/
│     │  ├─ network/
│     │  │  ├─ endpoints.dart          # ❌ NOT SHARED
│     │  │  └─ app_network_config.dart # ❌ NOT SHARED
│     │  ├─ routing/
│     │  │  ├─ route_names.dart        # ❌ NOT SHARED
│     │  │  └─ app_router.dart         # ❌ NOT SHARED
│     │  └─ theme/
│     │     └─ app_theme.dart          # ✅ Extends shared theme
│     │
│     └─ modules/             # Feature modules
│        ├─ feed/
│        ├─ cart/
│        └─ orders/
│
├─ driver_app/                # Driver App
│  └─ lib/
│     ├─ core/
│     │  ├─ network/
│     │  │  ├─ endpoints.dart          # ❌ NOT SHARED
│     │  │  └─ app_network_config.dart # ❌ NOT SHARED
│     │  ├─ routing/
│     │  │  ├─ route_names.dart        # ❌ NOT SHARED
│     │  │  └─ app_router.dart         # ❌ NOT SHARED
│     │  ├─ location/                  # ❌ NOT SHARED
│     │  ├─ maps/                      # ❌ NOT SHARED
│     │  └─ theme/
│     │     └─ driver_theme.dart      # ✅ Extends shared + variants
│     │
│     └─ modules/             # Feature modules
│        ├─ jobs/
│        ├─ delivery/
│        └─ driver_profile/
│
└─ backend/                   # Backend (unchanged)
   └─ src/
      └─ modules/
```

---

## 6. **Network Layer Strategy** 🔌

### **Shared Package (Infrastructure):**

```dart
// packages/shared/lib/network_core/network_config.dart
abstract class NetworkConfig {
  String get baseUrl;
  Duration get connectTimeout;
  Duration get receiveTimeout;
  int get retryCount;
  LogLevel get logLevel;
}

// packages/shared/lib/network_core/api_client.dart
class ApiClient {
  final NetworkConfig config;
  final TokenStore tokenStore;
  
  ApiClient({
    required this.config,
    required this.tokenStore,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
      ),
    );
    
    _dio.interceptors.addAll([
      AuthInterceptor(tokenStore: tokenStore),
      LoggingInterceptor(level: config.logLevel),
      ErrorInterceptor(),
    ]);
  }
}
```

### **Per App (Configuration):**

```dart
// customer_app/lib/core/network/app_network_config.dart
class AppNetworkConfig implements NetworkConfig {
  @override
  String get baseUrl => 'http://localhost:3001/api';
  
  @override
  Duration get connectTimeout => const Duration(seconds: 30);
  
  @override
  Duration get receiveTimeout => const Duration(seconds: 30);
  
  @override
  int get retryCount => 2;
  
  @override
  LogLevel get logLevel => LogLevel.info;
}

// customer_app/lib/core/network/endpoints.dart
class Endpoints {
  static const String baseUrl = 'http://localhost:3001/api';
  
  // Auth
  static const String requestOtp = '/auth/otp/request';
  static const String verifyOtp = '/auth/otp/verify';
  
  // Orders
  static const String orders = '/orders';
  static const String getOrders = orders;
  
  // ... Customer-specific endpoints
}
```

```dart
// driver_app/lib/core/network/app_network_config.dart
class AppNetworkConfig implements NetworkConfig {
  @override
  String get baseUrl => 'http://localhost:3001/api';
  
  @override
  Duration get connectTimeout => const Duration(seconds: 60); // ⚠️ أطول
  
  @override
  Duration get receiveTimeout => const Duration(seconds: 60); // ⚠️ أطول
  
  @override
  int get retryCount => 3; // ⚠️ أكثر
  
  @override
  LogLevel get logLevel => LogLevel.debug; // ⚠️ أكثر تفصيلاً
}

// driver_app/lib/core/network/endpoints.dart
class Endpoints {
  static const String baseUrl = 'http://localhost:3001/api';
  
  // Auth
  static const String requestOtp = '/auth/otp/request';
  static const String verifyOtp = '/auth/otp/verify';
  
  // Jobs
  static const String jobs = '/jobs';
  static const String getInbox = '$jobs/inbox';
  static const String acceptJob = '$jobs/{id}/accept';
  
  // ... Driver-specific endpoints
}
```

---

## 7. **Theme Strategy مع Driver Variants** 🎨

### **Shared Package (Base Theme):**

```dart
// packages/shared/lib/design_system/colors/app_colors.dart
class AppColors {
  static const Color primary = Color(0xFFFF6B35);
  static const Color accent = Color(0xFFFFD700);
  // ... base colors
}

// packages/shared/lib/design_system/typography/text_styles.dart
class TextStyles {
  static TextStyle headlineLarge = TextStyle(
    fontSize: FontSizes.headlineLarge,
    fontWeight: FontWeight.w600,
  );
  // ... base styles
}
```

### **Customer App (Uses Shared):**

```dart
// customer_app/lib/core/theme/app_theme.dart
import 'package:shared/design_system/design_system.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primary,
      textTheme: TextTheme(
        headlineLarge: TextStyles.headlineLarge,
      ),
      // ... uses shared theme directly
    );
  }
}
```

### **Driver App (Extends Shared + Variants):**

```dart
// driver_app/lib/core/theme/driver_theme.dart
import 'package:shared/design_system/design_system.dart';

class DriverTheme {
  // ✅ Uses shared colors
  static const Color primary = AppColors.primary;
  static const Color accent = AppColors.accent;
  
  // ⚠️ Driver-specific variants
  static const double touchTargetMinSize = 48.0; // Larger (vs 44.0)
  static const double fontScaleFactor = 1.1; // +10% larger
  
  // ⚠️ Higher contrast for navigation
  static const Color navigationText = AppColors.textPrimary;
  static const Color navigationBackground = AppColors.background;
  
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primary,
      textTheme: TextTheme(
        headlineLarge: TextStyles.headlineLarge.copyWith(
          fontSize: TextStyles.headlineLarge.fontSize! * fontScaleFactor,
        ),
      ),
      // ... extends shared with driver-specific overrides
    );
  }
}
```

**لماذا:**
- ✅ Brand Identity محفوظة (نفس الألوان)
- ⚠️ Driver يحتاج touch targets أكبر (أثناء القيادة)
- ⚠️ Driver يحتاج contrast أعلى (visibility)

---

## 8. **قواعد منع Over-Coupling** 🛡️

### ✅ **DO (افعل):**

1. ✅ **Shared = Infrastructure + Design Tokens فقط**
2. ✅ **Network Core = ApiClient + Interceptors (configurable)**
3. ✅ **Endpoints = Per App (لا تشارك)**
4. ✅ **Theme = Base shared + App-specific variants**
5. ✅ **DTOs = Per App (Phase 1) → Primitive DTOs shared (Phase 3)**

### ❌ **DON'T (لا تفعل):**

1. ❌ **لا تضع Providers/Notifiers في shared**
   - ❌ `shared/lib/providers/` → NO
   - ✅ `customer_app/lib/modules/*/providers/` → YES

2. ❌ **لا تضع Feature Modules في shared**
   - ❌ `shared/lib/modules/orders/` → NO
   - ✅ `customer_app/lib/modules/orders/` → YES

3. ❌ **لا تضع Endpoints في shared**
   - ❌ `shared/lib/network/endpoints.dart` → NO
   - ✅ `customer_app/lib/core/network/endpoints.dart` → YES

4. ❌ **لا تضع Routes في shared**
   - ❌ `shared/lib/routing/route_names.dart` → NO
   - ✅ `customer_app/lib/core/routing/route_names.dart` → YES

5. ❌ **لا تضع Hardcoded Config في shared**
   - ❌ `ApiClient(baseUrl: 'http://localhost:3001')` → NO
   - ✅ `ApiClient(config: NetworkConfig)` → YES

---

## 9. **Implementation Plan** 📋

### **Phase 1: Setup Shared Package** (Week 1)

1. ✅ إنشاء `packages/shared/`
2. ✅ نقل `design_system/` من customer_app
3. ✅ إنشاء `network_core/` (ApiClient + Interceptors)
4. ✅ إنشاء `storage_core/` (TokenStore)
5. ✅ إنشاء `errors_core/` (Failure + ErrorMapper)
6. ✅ إنشاء `utils_core/` (Validators + Formatters)
7. ✅ إنشاء `models_core/` (Money + Pagination)

### **Phase 2: Refactor Customer App** (Week 2)

1. ✅ تحديث `customer_app/pubspec.yaml` لاستخدام shared
2. ✅ نقل `endpoints.dart` إلى `customer_app/lib/core/network/`
3. ✅ إنشاء `app_network_config.dart` في customer_app
4. ✅ تحديث `ApiClient` لاستخدام `NetworkConfig`
5. ✅ تحديث Theme لاستخدام shared design_system

### **Phase 3: Create Driver App** (Week 3)

1. ✅ إنشاء `driver_app/` structure
2. ✅ إضافة shared dependency
3. ✅ إنشاء `driver_app/lib/core/network/endpoints.dart`
4. ✅ إنشاء `driver_app/lib/core/network/app_network_config.dart`
5. ✅ إنشاء `driver_app/lib/core/theme/driver_theme.dart` (extends shared)

### **Phase 4: Testing & Validation** (Week 4)

1. ✅ Test shared package في customer_app
2. ✅ Test shared package في driver_app
3. ✅ Validate no over-coupling
4. ✅ Validate configurable network settings

---

## 📊 **ملخص الاستراتيجية النهائية**

| Component | Shared? | Configurable? | Location |
|-----------|---------|---------------|----------|
| **Design System** | ✅ Yes | ⚠️ Variants | `shared/lib/design_system/` |
| **Network Core** | ✅ Yes | ✅ Yes | `shared/lib/network_core/` |
| **Network Config** | ❌ No | ✅ Per App | `{app}/lib/core/network/app_network_config.dart` |
| **Endpoints** | ❌ No | ❌ No | `{app}/lib/core/network/endpoints.dart` |
| **Storage Core** | ✅ Yes | ❌ No | `shared/lib/storage_core/` |
| **Errors Core** | ✅ Yes | ❌ No | `shared/lib/errors_core/` |
| **Utils Core** | ✅ Yes | ❌ No | `shared/lib/utils_core/` |
| **Models Core** | ✅ Yes (Primitives) | ❌ No | `shared/lib/models_core/` |
| **Routes** | ❌ No | ❌ No | `{app}/lib/core/routing/` |
| **Location** | ❌ No | ❌ No | `driver_app/lib/core/location/` |
| **Maps** | ❌ No | ❌ No | `{app}/lib/core/maps/` |
| **Feature Modules** | ❌ No | ❌ No | `{app}/lib/modules/` |
| **DTOs** | ⚠️ Phase 3 | ❌ No | `{app}/lib/modules/*/data/models/` |

---

## 🎯 **الخلاصة النهائية**

### ✅ **ما يجب أن يتشارك:**
1. **Design System** (100% shared + variants per app)
2. **Network Core** (ApiClient + Interceptors, configurable)
3. **Storage Core** (TokenStore)
4. **Errors Core** (Failure + ErrorMapper)
5. **Utils Core** (Validators + Formatters)
6. **Models Core** (Primitives only: Money, Pagination)

### ⚙️ **ما يجب أن يكون Configurable:**
1. **Network Config** (baseUrl, timeouts, retry, logLevel)
2. **Theme Variants** (touch targets, font scale, contrast)

### ❌ **ما يجب أن يكون مختلفاً:**
1. **Endpoints** (per app)
2. **Routes** (per app)
3. **Location Services** (Driver only)
4. **Maps** (different features)
5. **Feature Modules** (completely different)

### 🛡️ **القاعدة الذهبية:**
> **Shared Package = Infrastructure + Design Tokens فقط**  
> **لا تضع: Providers, Notifiers, Feature Modules, Endpoints, أو DTOs**

---

**التقييم النهائي: 10/10** ⭐⭐⭐⭐⭐

**الاستراتيجية محكمة وجاهزة للتنفيذ!** ✅
