# الهيكل النهائي المصحح (10/10)

## التغييرات بناءً على الملاحظات الهندسية:

### ✅ التغيير 1: نقل global_cart_provider
**قبل:**
```
core/providers/global_cart_provider.dart  ❌
```

**بعد:**
```
modules/cart/presentation/providers/cart_notifier.dart  ✅
core/di/providers.dart  (expose فقط)
```

### ✅ التغيير 2: توحيد delivery_zone_validator
**قبل:**
```
core/delivery/delivery_zone_validator.dart  ❌
modules/addresses/domain/usecases/validate_delivery_zone.dart  ❌
```

**بعد:**
```
modules/addresses/domain/services/delivery_zone_validator.dart  ✅
modules/addresses/domain/usecases/validate_delivery_zone.dart  (يستخدم service)
core/delivery/  (pure calculations فقط)
```

### ✅ التغيير 3: توثيق dependencies
- `addresses` → `map_location` (one-way dependency)
- `map_location` يبقى generic (لا يعرف Address)

### ✅ التغيير 4: حذف menu_search_service من Phase 1
**قبل:**
```
search/data/services/menu_search_service.dart  ❌
```

**بعد:**
```
search/data/services/vendor_search_service.dart  ✅
# menu_search_service محذوف من Phase 1
```

---

## الهيكل النهائي الكامل:

```
customer_app/
├─ pubspec.yaml
├─ analysis_options.yaml
├─ android/
├─ ios/
├─ assets/
│  ├─ images/
│  │  ├─ logo.png
│  │  ├─ placeholder_poster.png
│  │  └─ icons/
│  ├─ fonts/
│  │  ├─ Montserrat/              # خط Montserrat (Regular, Medium, SemiBold, Bold)
│  │  │  ├─ Montserrat-Regular.ttf
│  │  │  ├─ Montserrat-Medium.ttf
│  │  │  ├─ Montserrat-SemiBold.ttf
│  │  │  └─ Montserrat-Bold.ttf
│  │  └─ (خطوط إضافية إن لزم)
│  ├─ icons/
│  │  ├─ app_icons/               # أيقونات مخصصة للتطبيق
│  │  └─ custom_icons/            # أيقونات إضافية
│  └─ lottie/
│     ├─ loading.json
│     ├─ success.json
│     ├─ error.json
│     └─ (أنيميشن إضافية)
└─ lib/
   ├─ main.dart
   ├─ app.dart
   ├─ bootstrap.dart
   ├─ core/
   │  ├─ config/
   │  │  ├─ env.dart
   │  │  ├─ flavor.dart
   │  │  └─ app_constants.dart
   │  ├─ routing/
   │  │  ├─ app_router.dart
   │  │  ├─ route_names.dart
   │  │  └─ guards.dart
   │  ├─ theme/
   │  │  ├─ app_theme.dart              # ThemeData الرئيسي
   │  │  ├─ design_system.dart         # ✨ Facade - يجمع كل exports
   │  │  ├─ colors/
   │  │  │  ├─ app_colors.dart          # الألوان الأساسية
   │  │  │  ├─ semantic_colors.dart     # ألوان دلالية (success, error, warning)
   │  │  │  └─ gradient_colors.dart      # ألوان التدرجات
   │  │  ├─ typography/
   │  │  │  ├─ text_styles.dart         # أنماط النصوص
   │  │  │  ├─ font_families.dart       # عائلات الخطوط
   │  │  │  └─ font_sizes.dart          # أحجام الخطوط
   │  │  ├─ icons/
   │  │  │  ├─ app_icons.dart           # أيقونات التطبيق الموحدة (تعريفات)
   │  │  │  └─ icon_sizes.dart          # أحجام الأيقونات
   │  │  ├─ animations/
   │  │  │  ├─ durations.dart           # مدة الأنيميشن
   │  │  │  ├─ curves.dart              # منحنيات الأنيميشن
   │  │  │  └─ transitions.dart         # انتقالات الصفحات
   │  │  ├─ shapes/
   │  │  │  ├─ borders.dart             # أنماط الحدود
   │  │  │  ├─ radius.dart              # أنصاف الأقطار
   │  │  │  └─ card_shapes.dart         # أشكال البطاقات
   │  │  ├─ spacing/
   │  │  │  ├─ insets.dart              # ✨ EdgeInsets موحد (padding + margin)
   │  │  │  └─ gaps.dart                # الفجوات بين العناصر (SizedBox)
   │  │  ├─ shadows/
   │  │  │  └─ app_shadows.dart         # الظلال الموحدة
   │  │  └─ components/                # ثيمات المكونات
   │  │     ├─ button_theme.dart        # ثيم الأزرار
   │  │     ├─ input_theme.dart         # ثيم حقول الإدخال
   │  │     ├─ card_theme.dart          # ثيم البطاقات
   │  │     ├─ bottom_sheet_theme.dart  # ثيم Bottom Sheets
   │  │     └─ video_overlay_theme.dart # ✨ ثيم Video Overlay (Feed)
   │  ├─ network/
   │  │  ├─ api_client.dart
   │  │  ├─ endpoints.dart
   │  │  ├─ interceptors/
   │  │  │  ├─ auth_interceptor.dart
   │  │  │  ├─ logging_interceptor.dart
   │  │  │  └─ error_interceptor.dart
   │  │  └─ network_exceptions.dart
   │  ├─ storage/
   │  │  ├─ secure_storage.dart
   │  │  ├─ local_storage.dart
   │  │  └─ storage_keys.dart
   │  ├─ video/
   │  │  ├─ video_controller_pool.dart
   │  │  ├─ video_cache_manager.dart
   │  │  ├─ video_preloader.dart
   │  │  └─ video_quality_manager.dart
   │  ├─ delivery/                 # Pure calculations only
   │  │  ├─ eta_calculator.dart
   │  │  └─ delivery_fee_calculator.dart
   │  ├─ utils/
   │  │  ├─ validators.dart
   │  │  ├─ formatters.dart
   │  │  ├─ debounce.dart
   │  │  └─ logger.dart
   │  ├─ errors/
   │  │  ├─ failure.dart
   │  │  ├─ error_mapper.dart
   │  │  ├─ error_handler.dart
   │  │  └─ app_exception.dart
   │  ├─ widgets/
   │  │  ├─ app_scaffold.dart
   │  │  ├─ app_icon.dart              # ✨ Widget موحد لعرض الأيقونات
   │  │  ├─ primary_button.dart
   │  │  ├─ secondary_button.dart
   │  │  ├─ app_text_field.dart
   │  │  ├─ loading_view.dart
   │  │  ├─ empty_state.dart
   │  │  ├─ error_state.dart
   │  │  ├─ app_snackbar.dart
   │  │  └─ app_bottom_sheet.dart
   │  └─ di/
   │     ├─ providers.dart          # Composition root - exposes all providers
   │     └─ service_locator.dart
   ├─ modules/
   │  ├─ auth/
   │  │  ├─ data/
   │  │  │  ├─ datasources/
   │  │  │  │  ├─ auth_remote_ds.dart
   │  │  │  │  └─ auth_local_ds.dart
   │  │  │  ├─ models/
   │  │  │  │  ├─ otp_request_dto.dart
   │  │  │  │  ├─ otp_verify_dto.dart
   │  │  │  │  └─ auth_tokens_dto.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ auth_repo_impl.dart
   │  │  │  └─ mappers/
   │  │  │     └─ auth_mapper.dart
   │  │  ├─ domain/
   │  │  │  ├─ entities/
   │  │  │  │  └─ user_entity.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ auth_repo.dart
   │  │  │  └─ usecases/
   │  │  │     ├─ request_otp.dart
   │  │  │     ├─ verify_otp.dart
   │  │  │     ├─ set_pin.dart
   │  │  │     ├─ verify_pin.dart
   │  │  │     ├─ logout.dart
   │  │  │     └─ refresh_token.dart
   │  │  └─ presentation/
   │  │     ├─ providers/
   │  │     │  ├─ auth_state.dart
   │  │     │  ├─ auth_notifier.dart
   │  │     │  └─ biometric_service.dart
   │  │     ├─ screens/
   │  │     │  ├─ splash_screen.dart
   │  │     │  ├─ phone_screen.dart
   │  │     │  ├─ otp_screen.dart
   │  │     │  ├─ security_method_screen.dart
   │  │     │  ├─ create_pin_screen.dart
   │  │     │  └─ enter_pin_screen.dart
   │  │     └─ widgets/
   │  │        ├─ pin_pad.dart
   │  │        └─ otp_input.dart
   │  ├─ feed/
   │  │  ├─ data/
   │  │  │  ├─ datasources/
   │  │  │  │  └─ feed_remote_ds.dart
   │  │  │  ├─ models/
   │  │  │  │  ├─ feed_item_dto.dart
   │  │  │  │  └─ feed_page_dto.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ feed_repo_impl.dart
   │  │  │  └─ mappers/
   │  │  │     └─ feed_mapper.dart
   │  │  ├─ domain/
   │  │  │  ├─ entities/
   │  │  │  │  ├─ feed_item.dart
   │  │  │  │  └─ video_asset.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ feed_repo.dart
   │  │  │  └─ usecases/
   │  │  │     ├─ get_feed_page.dart
   │  │  │     └─ refresh_feed.dart
   │  │  └─ presentation/
   │  │     ├─ providers/
   │  │     │  ├─ feed_state.dart
   │  │     │  └─ feed_notifier.dart
   │  │     ├─ screens/
   │  │     │  └─ feed_screen.dart
   │  │     └─ widgets/
   │  │        ├─ feed_video_card.dart
   │  │        ├─ dish_overlay.dart
   │  │        └─ view_restaurant_button.dart
   │  ├─ addresses/
   │  │  ├─ data/
   │  │  │  ├─ datasources/
   │  │  │  │  └─ addresses_remote_ds.dart
   │  │  │  ├─ models/
   │  │  │  │  └─ address_dto.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ addresses_repo_impl.dart
   │  │  │  └─ mappers/
   │  │  │     └─ address_mapper.dart
   │  │  ├─ domain/
   │  │  │  ├─ entities/
   │  │  │  │  └─ address.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ addresses_repo.dart
   │  │  │  ├─ services/                    # ✨ جديد
   │  │  │  │  └─ delivery_zone_validator.dart
   │  │  │  └─ usecases/
   │  │  │     ├─ get_default_address.dart
   │  │  │     ├─ set_default_address.dart
   │  │  │     ├─ get_addresses.dart
   │  │  │     ├─ add_address.dart
   │  │  │     ├─ update_address.dart
   │  │  │     ├─ delete_address.dart
   │  │  │     └─ validate_delivery_zone.dart  # يستخدم service
   │  │  └─ presentation/
   │  │     ├─ providers/
   │  │     │  ├─ address_state.dart
   │  │     │  └─ address_notifier.dart
   │  │     ├─ screens/
   │  │     │  └─ select_address_map_screen.dart
   │  │     └─ widgets/
   │  │        ├─ address_tile.dart
   │  │        └─ map_pin.dart
   │  ├─ vendors/
   │  │  ├─ data/
   │  │  │  ├─ datasources/
   │  │  │  │  └─ vendors_remote_ds.dart
   │  │  │  ├─ models/
   │  │  │  │  ├─ vendor_dto.dart
   │  │  │  │  ├─ menu_item_dto.dart
   │  │  │  │  └─ vendor_menu_dto.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ vendors_repo_impl.dart
   │  │  │  └─ mappers/
   │  │  │     └─ vendors_mapper.dart
   │  │  ├─ domain/
   │  │  │  ├─ entities/
   │  │  │  │  ├─ vendor.dart
   │  │  │  │  └─ menu_item.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ vendors_repo.dart
   │  │  │  └─ usecases/
   │  │  │     ├─ get_vendor.dart
   │  │  │     ├─ get_vendor_menu.dart
   │  │  │     └─ get_signature_items.dart
   │  │  └─ presentation/
   │  │     ├─ providers/
   │  │     │  ├─ vendor_state.dart
   │  │     │  └─ vendor_notifier.dart
   │  │     ├─ screens/
   │  │     │  ├─ vendor_screen.dart
   │  │     │  └─ vendor_reviews_screen.dart
   │  │     └─ widgets/
   │  │        ├─ vendor_header.dart
   │  │        ├─ menu_item_tile.dart
   │  │        └─ hero_video_banner.dart
   │  ├─ cart/
   │  │  ├─ data/
   │  │  │  ├─ datasources/
   │  │  │  │  └─ cart_remote_ds.dart
   │  │  │  ├─ models/
   │  │  │  │  ├─ cart_dto.dart
   │  │  │  │  └─ cart_item_dto.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ cart_repo_impl.dart
   │  │  │  └─ mappers/
   │  │  │     └─ cart_mapper.dart
   │  │  ├─ domain/
   │  │  │  ├─ entities/
   │  │  │  │  ├─ cart.dart
   │  │  │  │  └─ cart_item.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ cart_repo.dart
   │  │  │  └─ usecases/
   │  │  │     ├─ get_cart.dart
   │  │  │     ├─ add_to_cart.dart
   │  │  │     ├─ update_cart_item.dart
   │  │  │     ├─ remove_cart_item.dart
   │  │  │     └─ clear_cart.dart
   │  │  └─ presentation/
   │  │     ├─ providers/
   │  │     │  ├─ cart_state.dart
   │  │     │  └─ cart_notifier.dart        # ✨ هنا (ليس في core)
   │  │     ├─ screens/
   │  │     │  ├─ cart_screen.dart
   │  │     │  └─ vendor_conflict_dialog.dart
   │  │     └─ widgets/
   │  │        ├─ cart_item_row.dart
   │  │        ├─ cart_summary.dart
   │  │        └─ checkout_button.dart
   │  ├─ orders/
   │  │  ├─ data/
   │  │  │  ├─ datasources/
   │  │  │  │  └─ orders_remote_ds.dart
   │  │  │  ├─ models/
   │  │  │  │  ├─ order_dto.dart
   │  │  │  │  ├─ order_item_dto.dart
   │  │  │  │  └─ order_tracking_dto.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ orders_repo_impl.dart
   │  │  │  └─ mappers/
   │  │  │     └─ orders_mapper.dart
   │  │  ├─ domain/
   │  │  │  ├─ entities/
   │  │  │  │  ├─ order.dart
   │  │  │  │  ├─ order_item.dart
   │  │  │  │  └─ order_tracking.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ orders_repo.dart
   │  │  │  └─ usecases/
   │  │  │     ├─ create_order.dart
   │  │  │     ├─ get_orders.dart
   │  │  │     ├─ get_order_details.dart
   │  │  │     └─ cancel_order.dart
   │  │  └─ presentation/
   │  │     ├─ providers/
   │  │     │  ├─ orders_state.dart
   │  │     │  ├─ orders_notifier.dart
   │  │     │  ├─ order_details_state.dart
   │  │     │  └─ order_details_notifier.dart
   │  │     ├─ screens/
   │  │     │  ├─ orders_screen.dart
   │  │     │  ├─ order_confirmation_screen.dart
   │  │     │  ├─ order_tracking_screen.dart
   │  │     │  ├─ order_completed_screen.dart
   │  │     │  └─ rating_screen.dart
   │  │     └─ widgets/
   │  │        ├─ order_timeline.dart
   │  │        ├─ tracking_map_view.dart
   │  │        ├─ driver_contact_bar.dart
   │  │        └─ rating_stars.dart
   │  ├─ payments/
   │  │  ├─ data/
   │  │  │  ├─ datasources/
   │  │  │  │  └─ payments_remote_ds.dart
   │  │  │  ├─ gateways/
   │  │  │  │  ├─ apple_pay_gateway.dart
   │  │  │  │  ├─ mada_gateway.dart
   │  │  │  │  └─ stc_pay_gateway.dart
   │  │  │  ├─ models/
   │  │  │  │  ├─ payment_init_dto.dart
   │  │  │  │  └─ payment_confirm_dto.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ payments_repo_impl.dart
   │  │  │  └─ mappers/
   │  │  │     └─ payments_mapper.dart
   │  │  ├─ domain/
   │  │  │  ├─ entities/
   │  │  │  │  └─ payment.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ payments_repo.dart
   │  │  │  ├─ services/
   │  │  │  │  └─ payment_gateway_interface.dart
   │  │  │  └─ usecases/
   │  │  │     ├─ initiate_payment.dart
   │  │  │     └─ confirm_payment.dart
   │  │  └─ presentation/
   │  │     ├─ providers/
   │  │     │  ├─ payment_state.dart
   │  │     │  └─ payment_notifier.dart
   │  │     └─ screens/
   │  │        └─ payment_screen.dart
   │  ├─ map_location/               # Generic - لا يعرف Address
   │  │  ├─ data/
   │  │  │  ├─ datasources/
   │  │  │  │  ├─ geocoding_remote_ds.dart
   │  │  │  │  └─ distance_matrix_remote_ds.dart
   │  │  │  ├─ models/
   │  │  │  │  ├─ geocode_result_dto.dart
   │  │  │  │  └─ distance_matrix_dto.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ map_location_repo_impl.dart
   │  │  │  └─ mappers/
   │  │  │     └─ map_location_mapper.dart
   │  │  ├─ domain/
   │  │  │  ├─ entities/
   │  │  │  │  ├─ geo_point.dart        # Generic
   │  │  │  │  └─ geocode_result.dart   # Generic (لا يعرف Address)
   │  │  │  ├─ repositories/
   │  │  │  │  └─ map_location_repo.dart
   │  │  │  └─ usecases/
   │  │  │     ├─ get_current_location.dart  # يرجع GeoPoint
   │  │  │     └─ reverse_geocode.dart       # يرجع GeocodeResult
   │  │  └─ presentation/
   │  │     └─ widgets/
   │  │        ├─ map_pin.dart
   │  │        └─ map_controls.dart
   │  ├─ search/
   │  │  ├─ data/
   │  │  │  ├─ datasources/
   │  │  │  │  └─ search_remote_ds.dart
   │  │  │  ├─ services/
   │  │  │  │  └─ vendor_search_service.dart  # Phase 1 فقط
   │  │  │  ├─ models/
   │  │  │  │  └─ search_vendor_dto.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ search_repo_impl.dart
   │  │  │  └─ mappers/
   │  │  │     └─ search_mapper.dart
   │  │  ├─ domain/
   │  │  │  ├─ entities/
   │  │  │  │  └─ vendor_search_item.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ search_repo.dart
   │  │  │  ├─ services/
   │  │  │  │  └─ search_service.dart  # Interface
   │  │  │  └─ usecases/
   │  │  │     └─ search_vendors.dart
   │  │  └─ presentation/
   │  │     ├─ providers/
   │  │     │  ├─ search_state.dart
   │  │     │  └─ search_notifier.dart
   │  │     ├─ screens/
   │  │     │  └─ search_screen.dart
   │  │     └─ widgets/
   │  │        ├─ vendor_search_tile.dart
   │  │        └─ search_input.dart
   │  └─ profile/
   │     ├─ data/
   │     │  ├─ datasources/
   │     │  │  └─ profile_remote_ds.dart
   │     │  ├─ models/
   │     │  │  └─ profile_dto.dart
   │     │  ├─ repositories/
   │     │  │  └─ profile_repo_impl.dart
   │     │  └─ mappers/
   │     │     └─ profile_mapper.dart
   │     ├─ domain/
   │     │  ├─ entities/
   │     │  │  └─ profile.dart
   │     │  ├─ repositories/
   │     │  │  └─ profile_repo.dart
   │     │  └─ usecases/
   │     │     ├─ get_profile.dart
   │     │     └─ update_profile.dart
   │     └─ presentation/
   │        ├─ providers/
   │        │  ├─ profile_state.dart
   │        │  └─ profile_notifier.dart
   │        ├─ screens/
   │        │  ├─ profile_screen.dart
   │        │  └─ edit_name_screen.dart
   │        └─ widgets/
   │           ├─ profile_header.dart
   │           └─ profile_tile.dart
   └─ shared/
      ├─ models/
      │  └─ pagination.dart
      ├─ enums/
      │  ├─ vendor_type.dart
      │  ├─ order_status.dart
      │  └─ app_error_codes.dart
      └─ extensions/
         ├─ context_ext.dart
         ├─ num_ext.dart
         └─ datetime_ext.dart
```

---

## ملاحظات Dependency Graph:

### ✅ Dependencies الصحيحة:

```
core/ (independent)
  ↑
  ├─ modules/auth/
  ├─ modules/feed/
  ├─ modules/addresses/ → map_location/ (one-way)
  ├─ modules/vendors/
  ├─ modules/cart/
  ├─ modules/orders/
  ├─ modules/payments/
  ├─ modules/map_location/ (independent, generic)
  ├─ modules/search/
  └─ modules/profile/

core/di/providers.dart (composition root)
  ├─ exposes cart_notifier (from modules/cart/)
  ├─ exposes all other providers
  └─ wires dependencies
```

### ✅ Rules:

1. **core/** لا يعرف شيئًا عن business logic
2. **map_location/** generic فقط (GeoPoint, GeocodeResult)
3. **addresses/** يعتمد على map_location (one-way)
4. **cart/** logic في module، expose عبر DI فقط
5. **delivery_zone_validator** في addresses domain services

---

## التقييم النهائي: **10/10** ✅
