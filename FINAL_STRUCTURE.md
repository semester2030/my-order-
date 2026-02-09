# الهيكل النهائي المحسّن للمشروع

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
│  ├─ lottie/
│  └─ fonts/
│     └─ (Montserrat, etc)
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
   │  │  ├─ app_theme.dart
   │  │  ├─ colors.dart
   │  │  ├─ typography.dart
   │  │  └─ spacing.dart
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
   │  ├─ video/                    # ✨ جديد
   │  │  ├─ video_controller_pool.dart
   │  │  ├─ video_cache_manager.dart
   │  │  ├─ video_preloader.dart
   │  │  └─ video_quality_manager.dart
   │  ├─ delivery/                 # ✨ جديد
   │  │  ├─ eta_calculator.dart
   │  │  ├─ delivery_zone_validator.dart
   │  │  └─ delivery_fee_calculator.dart
   │  ├─ providers/                # ✨ جديد
   │  │  └─ global_cart_provider.dart
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
   │  │  ├─ primary_button.dart
   │  │  ├─ secondary_button.dart
   │  │  ├─ app_text_field.dart
   │  │  ├─ loading_view.dart
   │  │  ├─ empty_state.dart
   │  │  ├─ error_state.dart
   │  │  ├─ app_snackbar.dart
   │  │  └─ app_bottom_sheet.dart
   │  └─ di/
   │     ├─ providers.dart
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
   │  ├─ addresses/                # ✨ جديد (منفصل عن profile)
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
   │  │  │  └─ usecases/
   │  │  │     ├─ get_default_address.dart
   │  │  │     ├─ set_default_address.dart
   │  │  │     ├─ get_addresses.dart
   │  │  │     ├─ add_address.dart
   │  │  │     ├─ update_address.dart
   │  │  │     ├─ delete_address.dart
   │  │  │     └─ validate_delivery_zone.dart
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
   │  │     │  └─ cart_state.dart  # يستخدم global_cart_provider
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
   │  │  │  ├─ gateways/              # ✨ جديد
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
   │  │  │  ├─ services/              # ✨ جديد
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
   │  ├─ map_location/               # ✨ محدود (للخرائط فقط)
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
   │  │  │  │  ├─ geo_point.dart
   │  │  │  │  └─ geocode_result.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ map_location_repo.dart
   │  │  │  └─ usecases/
   │  │  │     ├─ get_current_location.dart
   │  │  │     └─ reverse_geocode.dart
   │  │  └─ presentation/
   │  │     └─ widgets/
   │  │        ├─ map_pin.dart
   │  │        └─ map_controls.dart
   │  ├─ search/
   │  │  ├─ data/
   │  │  │  ├─ datasources/
   │  │  │  │  └─ search_remote_ds.dart
   │  │  │  ├─ services/              # ✨ جديد (للمستقبل)
   │  │  │  │  ├─ vendor_search_service.dart
   │  │  │  │  └─ menu_search_service.dart
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
   │  │  │  ├─ services/              # ✨ جديد
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

## ملاحظات مهمة:

### ✨ التغييرات الرئيسية:
1. **core/video/** - Video management مشترك
2. **core/delivery/** - ETA و delivery logic
3. **core/providers/** - Global cart provider
4. **modules/addresses/** - Module مستقل للعناوين
5. **payments/data/gateways/** - Payment gateways منفصلة
6. **payments/domain/services/** - Payment gateway interface
7. **search/domain/services/** - Search service interface (للمستقبل)

### ✅ ما بقي كما هو:
- Clean Architecture structure
- Feature-based modules
- State management (Riverpod)
- Mappers separation
