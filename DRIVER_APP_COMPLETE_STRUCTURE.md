# 🏗️ Driver App - Complete Structure (Full)

**التاريخ:** 25 يناير 2026  
**الهدف:** رسم الهيكل الكامل للـ Driver App

---

## 📋 **الهيكل الكامل:**

```
driver_app/
├─ pubspec.yaml
├─ analysis_options.yaml
├─ android/
│  └─ app/src/main/AndroidManifest.xml
├─ ios/
│  └─ Runner/Info.plist
├─ assets/
│  ├─ images/
│  │  ├─ logo.png
│  │  ├─ placeholder_avatar.png
│  │  └─ icons/
│  ├─ lottie/
│  │  ├─ loading.json
│  │  ├─ success.json
│  │  └─ error.json
│  └─ sounds/
│     └─ new_job.mp3
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
   │  │  ├─ driver_theme.dart
   │  │  └─ (imports from shared package)
   │  ├─ network/
   │  │  ├─ api_client.dart (from shared)
   │  │  ├─ endpoints.dart
   │  │  ├─ app_network_config.dart
   │  │  └─ interceptors/ (from shared)
   │  ├─ storage/
   │  │  ├─ secure_storage.dart (from shared)
   │  │  ├─ local_storage.dart (from shared)
   │  │  └─ storage_keys.dart
   │  ├─ location/                         # ✨ Driver critical
   │  │  ├─ location_service.dart
   │  │  ├─ background_location_service.dart
   │  │  ├─ location_throttler.dart
   │  │  └─ location_models.dart
   │  ├─ maps/
   │  │  ├─ map_provider.dart
   │  │  ├─ route_launcher.dart
   │  │  └─ polyline_decoder.dart (optional)
   │  ├─ audio/
   │  │  ├─ sound_player.dart
   │  │  └─ sound_assets.dart
   │  ├─ permissions/
   │  │  ├─ permission_service.dart
   │  │  └─ permission_types.dart
   │  ├─ utils/
   │  │  ├─ validators.dart (from shared)
   │  │  ├─ formatters.dart (from shared)
   │  │  ├─ debounce.dart
   │  │  ├─ logger.dart (from shared)
   │  │  └─ time.dart (from shared)
   │  ├─ errors/
   │  │  ├─ failure.dart (from shared)
   │  │  ├─ error_mapper.dart (from shared)
   │  │  ├─ error_handler.dart (from shared)
   │  │  └─ app_exception.dart (from shared)
   │  ├─ widgets/
   │  │  ├─ app_scaffold.dart
   │  │  ├─ primary_button.dart
   │  │  ├─ secondary_button.dart
   │  │  ├─ app_text_field.dart
   │  │  ├─ loading_view.dart
   │  │  ├─ empty_state.dart
   │  │  ├─ error_state.dart
   │  │  ├─ app_snackbar.dart
   │  │  ├─ app_dialog.dart
   │  │  └─ status_badge.dart
   │  └─ di/
   │     ├─ providers.dart
   │     └─ service_locator.dart (optional)
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
   │  │  │  │  └─ driver_user.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ auth_repo.dart
   │  │  │  └─ usecases/
   │  │  │     ├─ request_otp.dart
   │  │  │     ├─ verify_otp.dart
   │  │  │     ├─ refresh_token.dart
   │  │  │     └─ logout.dart
   │  │  └─ presentation/
   │  │     ├─ providers/
   │  │     │  ├─ auth_state.dart
   │  │     │  └─ auth_notifier.dart
   │  │     ├─ screens/
   │  │     │  ├─ splash_screen.dart
   │  │     │  ├─ phone_screen.dart
   │  │     │  ├─ otp_screen.dart
   │  │     │  └─ blocked_or_pending_screen.dart
   │  │     └─ widgets/
   │  │        └─ otp_input.dart
   │  ├─ driver_profile/
   │  │  ├─ data/
   │  │  │  ├─ datasources/
   │  │  │  │  └─ driver_profile_remote_ds.dart
   │  │  │  ├─ models/
   │  │  │  │  └─ driver_profile_dto.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ driver_profile_repo_impl.dart
   │  │  │  └─ mappers/
   │  │  │     └─ driver_profile_mapper.dart
   │  │  ├─ domain/
   │  │  │  ├─ entities/
   │  │  │  │  └─ driver_profile.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ driver_profile_repo.dart
   │  │  │  └─ usecases/
   │  │  │     ├─ get_driver_profile.dart
   │  │  │     └─ set_availability.dart
   │  │  └─ presentation/
   │  │     ├─ providers/
   │  │     │  ├─ driver_profile_state.dart
   │  │     │  └─ driver_profile_notifier.dart
   │  │     ├─ screens/
   │  │     │  └─ profile_screen.dart
   │  │     └─ widgets/
   │  │        ├─ online_toggle.dart
   │  │        └─ profile_header.dart
   │  ├─ registration/
   │  │  ├─ data/
   │  │  │  ├─ datasources/
   │  │  │  │  └─ registration_remote_ds.dart
   │  │  │  ├─ models/
   │  │  │  │  ├─ register_step1_dto.dart
   │  │  │  │  ├─ register_step2_dto.dart
   │  │  │  │  └─ register_step3_dto.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ registration_repo_impl.dart
   │  │  │  └─ mappers/
   │  │  │     └─ registration_mapper.dart
   │  │  ├─ domain/
   │  │  │  ├─ entities/
   │  │  │  │  └─ driver_registration.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ registration_repo.dart
   │  │  │  └─ usecases/
   │  │  │     ├─ register_step1.dart
   │  │  │     ├─ register_step2.dart
   │  │  │     ├─ register_step3.dart
   │  │  │     └─ track_application.dart
   │  │  └─ presentation/
   │  │     ├─ providers/
   │  │     │  ├─ registration_state.dart
   │  │     │  └─ registration_notifier.dart
   │  │     ├─ screens/
   │  │     │  ├─ register_step1_screen.dart
   │  │     │  ├─ register_step2_screen.dart
   │  │     │  ├─ register_step3_screen.dart
   │  │     │  └─ track_application_screen.dart
   │  │     └─ widgets/
   │  │        ├─ document_upload_widget.dart
   │  │        └─ registration_progress_indicator.dart
   │  ├─ jobs/
   │  │  ├─ data/
   │  │  │  ├─ datasources/
   │  │  │  │  └─ jobs_remote_ds.dart
   │  │  │  ├─ models/
   │  │  │  │  ├─ job_offer_dto.dart
   │  │  │  │  └─ active_job_dto.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ jobs_repo_impl.dart
   │  │  │  └─ mappers/
   │  │  │     └─ jobs_mapper.dart
   │  │  ├─ domain/
   │  │  │  ├─ entities/
   │  │  │  │  ├─ job_offer.dart
   │  │  │  │  ├─ active_job.dart
   │  │  │  │  └─ job_location.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ jobs_repo.dart
   │  │  │  └─ usecases/
   │  │  │     ├─ get_inbox.dart
   │  │  │     ├─ get_active_job.dart
   │  │  │     ├─ accept_job.dart
   │  │  │     └─ reject_job.dart
   │  │  └─ presentation/
   │  │     ├─ providers/
   │  │     │  ├─ jobs_state.dart
   │  │     │  └─ jobs_notifier.dart
   │  │     ├─ screens/
   │  │     │  └─ jobs_screen.dart
   │  │     └─ widgets/
   │  │        ├─ job_offer_card.dart
   │  │        ├─ job_countdown_timer.dart
   │  │        └─ new_job_banner.dart
   │  ├─ delivery/
   │  │  ├─ data/
   │  │  │  ├─ datasources/
   │  │  │  │  └─ delivery_remote_ds.dart
   │  │  │  ├─ models/
   │  │  │  │  ├─ assignment_dto.dart
   │  │  │  │  ├─ status_update_dto.dart
   │  │  │  │  └─ location_update_dto.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ delivery_repo_impl.dart
   │  │  │  └─ mappers/
   │  │  │     └─ delivery_mapper.dart
   │  │  ├─ domain/
   │  │  │  ├─ entities/
   │  │  │  │  ├─ delivery_assignment.dart
   │  │  │  │  ├─ delivery_status.dart
   │  │  │  │  └─ delivery_contact.dart
   │  │  │  ├─ repositories/
   │  │  │  │  └─ delivery_repo.dart
   │  │  │  └─ usecases/
   │  │  │     ├─ update_status.dart
   │  │  │     ├─ send_location.dart
   │  │  │     └─ get_assignment_details.dart
   │  │  └─ presentation/
   │  │     ├─ providers/
   │  │     │  ├─ active_delivery_state.dart
   │  │     │  ├─ active_delivery_notifier.dart
   │  │     │  └─ location_publisher.dart
   │  │     ├─ screens/
   │  │     │  ├─ active_delivery_screen.dart
   │  │     │  ├─ navigate_to_restaurant_screen.dart
   │  │     │  ├─ pickup_screen.dart
   │  │     │  ├─ navigate_to_customer_screen.dart
   │  │     │  └─ delivered_screen.dart
   │  │     └─ widgets/
   │  │        ├─ delivery_stepper.dart
   │  │        ├─ delivery_map_view.dart
   │  │        ├─ order_summary_card.dart
   │  │        ├─ customer_contact_bar.dart
   │  │        └─ status_action_button.dart
   │  └─ notifications/
   │     ├─ data/
   │     │  ├─ datasources/
   │     │  │  └─ notifications_remote_ds.dart
   │     │  ├─ models/
   │     │  │  └─ notification_dto.dart
   │     │  ├─ repositories/
   │     │  │  └─ notifications_repo_impl.dart
   │     │  └─ mappers/
   │     │     └─ notifications_mapper.dart
   │     ├─ domain/
   │     │  ├─ entities/
   │     │  │  └─ driver_notification.dart
   │     │  ├─ repositories/
   │     │  │  └─ notifications_repo.dart
   │     │  └─ usecases/
   │     │     ├─ register_fcm_token.dart
   │     │     └─ get_notifications.dart
   │     └─ presentation/
   │        ├─ providers/
   │        │  ├─ notifications_state.dart
   │        │  └─ notifications_notifier.dart
   │        └─ widgets/
   │           └─ notification_badge.dart
   ├─ shell/
   │  ├─ main_shell.dart
   │  └─ bottom_nav.dart
   └─ shared/
      ├─ enums/
      │  ├─ delivery_status.dart
      │  ├─ job_status.dart
      │  └─ app_error_codes.dart
      ├─ models/
      │  ├─ pagination.dart
      │  └─ money.dart
      └─ extensions/
         ├─ context_ext.dart
         ├─ datetime_ext.dart
         └─ num_ext.dart
```

---

## 📋 **قائمة الشاشات (Phase 1):**

### **Auth:**
1. ✅ `splash_screen.dart`
2. ✅ `phone_screen.dart`
3. ✅ `otp_screen.dart`
4. ✅ `blocked_or_pending_screen.dart` (optional)

### **Registration:**
5. ✅ `register_step1_screen.dart` - Basic info (nationalId + phone)
6. ✅ `register_step2_screen.dart` - Documents (license, vehicle, consents)
7. ✅ `register_step3_screen.dart` - Insurance & Banking
8. ✅ `track_application_screen.dart` - Track application status

### **Shell (Main Navigation):**
9. ✅ `main_shell.dart` - Bottom navigation shell
10. ✅ `jobs_screen.dart` - Jobs inbox
11. ✅ `active_delivery_screen.dart` - Active delivery
12. ✅ `profile_screen.dart` - Driver profile

### **Delivery Flow:**
13. ✅ `navigate_to_restaurant_screen.dart` - Navigate to restaurant
14. ✅ `pickup_screen.dart` - Pickup confirmation
15. ✅ `navigate_to_customer_screen.dart` - Navigate to customer
16. ✅ `delivered_screen.dart` - Delivery confirmation

---

## 📋 **قائمة الملفات الكاملة (بدون كود):**

### **Core Files:**
- `main.dart`
- `app.dart`
- `bootstrap.dart`

### **Core/Config:**
- `core/config/env.dart`
- `core/config/flavor.dart`
- `core/config/app_constants.dart`

### **Core/Routing:**
- `core/routing/app_router.dart`
- `core/routing/route_names.dart`
- `core/routing/guards.dart`

### **Core/Theme:**
- `core/theme/app_theme.dart`
- `core/theme/driver_theme.dart`

### **Core/Network:**
- `core/network/endpoints.dart`
- `core/network/app_network_config.dart`

### **Core/Location:**
- `core/location/location_service.dart` ✅ (created)
- `core/location/background_location_service.dart` ✅ (created)
- `core/location/location_throttler.dart` ✅ (created)
- `core/location/location_models.dart` ✅ (created)

### **Core/Maps:**
- `core/maps/map_provider.dart`
- `core/maps/route_launcher.dart` ✅ (created)

### **Core/Audio:**
- `core/audio/sound_player.dart`
- `core/audio/sound_assets.dart`

### **Core/Permissions:**
- `core/permissions/permission_service.dart`
- `core/permissions/permission_types.dart`

### **Core/Utils:**
- `core/utils/debounce.dart`

### **Core/Widgets:**
- `core/widgets/app_scaffold.dart`
- `core/widgets/primary_button.dart`
- `core/widgets/secondary_button.dart`
- `core/widgets/app_text_field.dart`
- `core/widgets/loading_view.dart`
- `core/widgets/empty_state.dart`
- `core/widgets/error_state.dart`
- `core/widgets/app_snackbar.dart`
- `core/widgets/app_dialog.dart`
- `core/widgets/status_badge.dart`

### **Core/DI:**
- `core/di/providers.dart`

### **Modules/Auth:**
- All auth files (data, domain, presentation)

### **Modules/Driver Profile:**
- All driver profile files

### **Modules/Registration:**
- All registration files

### **Modules/Jobs:**
- All jobs files

### **Modules/Delivery:**
- All delivery files

### **Modules/Notifications:**
- All notifications files

### **Shell:**
- `shell/main_shell.dart`
- `shell/bottom_nav.dart`

### **Shared:**
- All shared files

---

**الهيكل الكامل جاهز!** ✅
