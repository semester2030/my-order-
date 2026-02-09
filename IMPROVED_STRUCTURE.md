# Improved Project Structure

## التغييرات الرئيسية على الهيكل الأصلي:

### 1. إضافة `core/video/` للفيديو المشترك
```
core/
  └─ video/
     ├─ video_controller_pool.dart
     ├─ video_cache_manager.dart
     ├─ video_preloader.dart
     └─ video_quality_manager.dart
```

### 2. فصل `addresses/` كـ module مستقل
```
modules/
  └─ addresses/
     ├─ data/
     ├─ domain/
     │  └─ usecases/
     │     ├─ get_default_address.dart
     │     ├─ set_default_address.dart
     │     └─ validate_delivery_zone.dart
     └─ presentation/
        └─ screens/
           └─ select_address_map_screen.dart
```

### 3. إضافة `core/delivery/` للـ ETA والمناطق
```
core/
  └─ delivery/
     ├─ eta_calculator.dart
     ├─ delivery_zone_validator.dart
     └─ delivery_fee_calculator.dart
```

### 4. تحسين `payments/` مع Gateway Abstraction
```
modules/payments/
  ├─ domain/
  │  └─ services/
  │     └─ payment_gateway_interface.dart
  ├─ data/
  │  └─ gateways/
  │     ├─ apple_pay_gateway.dart
  │     ├─ mada_gateway.dart
  │     └─ stc_pay_gateway.dart
```

### 5. Global Cart Provider
```
core/
  └─ providers/
     └─ global_cart_provider.dart   # Riverpod StateNotifierProvider
```

### 6. Enhanced Network Layer
```
core/network/
  └─ interceptors/
     ├─ auth_interceptor.dart
     ├─ logging_interceptor.dart
     └─ error_interceptor.dart
```

### 7. Unified Error Handling
```
core/
  └─ errors/
     ├─ error_handler.dart
     ├─ error_mapper.dart
     └─ error_widgets.dart
```

## ملاحظات إضافية:

### Video Controller Pool
- يجب أن يكون Singleton
- يدير 3-5 controllers فقط
- يعيد استخدام controllers للفيديوهات السابقة

### Address Management
- العنوان الافتراضي يُستخدم في Feed filtering
- يجب أن يكون reactive (Riverpod Provider)
- التغيير في العنوان يحدث refresh للـ Feed

### ETA Calculation
- يُحسب بناءً على العنوان الافتراضي
- يُحدث عند تغيير العنوان
- يُعرض في Feed overlay

### Payment Gateways
- كل gateway يُنفذ `PaymentGatewayInterface`
- `PaymentNotifier` يستخدم factory pattern لاختيار Gateway
- يمكن إضافة gateways جديدة بسهولة
