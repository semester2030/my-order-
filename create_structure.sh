#!/bin/bash

# Navigate to customer_app directory
cd "/Users/fayez/Desktop/my order/customer_app"

# Create all Dart files based on the structure

# Root files
touch lib/main.dart
touch lib/app.dart
touch lib/bootstrap.dart

# Core - Config
touch lib/core/config/env.dart
touch lib/core/config/flavor.dart
touch lib/core/config/app_constants.dart

# Core - Routing
touch lib/core/routing/app_router.dart
touch lib/core/routing/route_names.dart
touch lib/core/routing/guards.dart

# Core - Theme
touch lib/core/theme/app_theme.dart
touch lib/core/theme/design_system.dart
touch lib/core/theme/colors/app_colors.dart
touch lib/core/theme/colors/semantic_colors.dart
touch lib/core/theme/colors/gradient_colors.dart
touch lib/core/theme/typography/text_styles.dart
touch lib/core/theme/typography/font_families.dart
touch lib/core/theme/typography/font_sizes.dart
touch lib/core/theme/icons/app_icons.dart
touch lib/core/theme/icons/icon_sizes.dart
touch lib/core/theme/animations/durations.dart
touch lib/core/theme/animations/curves.dart
touch lib/core/theme/animations/transitions.dart
touch lib/core/theme/shapes/borders.dart
touch lib/core/theme/shapes/radius.dart
touch lib/core/theme/shapes/card_shapes.dart
touch lib/core/theme/spacing/insets.dart
touch lib/core/theme/spacing/gaps.dart
touch lib/core/theme/shadows/app_shadows.dart
touch lib/core/theme/components/button_theme.dart
touch lib/core/theme/components/input_theme.dart
touch lib/core/theme/components/card_theme.dart
touch lib/core/theme/components/bottom_sheet_theme.dart
touch lib/core/theme/components/video_overlay_theme.dart

# Core - Network
touch lib/core/network/api_client.dart
touch lib/core/network/endpoints.dart
touch lib/core/network/interceptors/auth_interceptor.dart
touch lib/core/network/interceptors/logging_interceptor.dart
touch lib/core/network/interceptors/error_interceptor.dart
touch lib/core/network/network_exceptions.dart

# Core - Storage
touch lib/core/storage/secure_storage.dart
touch lib/core/storage/local_storage.dart
touch lib/core/storage/storage_keys.dart

# Core - Video
touch lib/core/video/video_controller_pool.dart
touch lib/core/video/video_cache_manager.dart
touch lib/core/video/video_preloader.dart
touch lib/core/video/video_quality_manager.dart

# Core - Delivery
touch lib/core/delivery/eta_calculator.dart
touch lib/core/delivery/delivery_fee_calculator.dart

# Core - Utils
touch lib/core/utils/validators.dart
touch lib/core/utils/formatters.dart
touch lib/core/utils/debounce.dart
touch lib/core/utils/logger.dart

# Core - Errors
touch lib/core/errors/failure.dart
touch lib/core/errors/error_mapper.dart
touch lib/core/errors/error_handler.dart
touch lib/core/errors/app_exception.dart

# Core - Widgets
touch lib/core/widgets/app_scaffold.dart
touch lib/core/widgets/app_icon.dart
touch lib/core/widgets/primary_button.dart
touch lib/core/widgets/secondary_button.dart
touch lib/core/widgets/app_text_field.dart
touch lib/core/widgets/loading_view.dart
touch lib/core/widgets/empty_state.dart
touch lib/core/widgets/error_state.dart
touch lib/core/widgets/app_snackbar.dart
touch lib/core/widgets/app_bottom_sheet.dart

# Core - DI
touch lib/core/di/providers.dart
touch lib/core/di/service_locator.dart

# Auth Module
touch lib/modules/auth/data/datasources/auth_remote_ds.dart
touch lib/modules/auth/data/datasources/auth_local_ds.dart
touch lib/modules/auth/data/models/otp_request_dto.dart
touch lib/modules/auth/data/models/otp_verify_dto.dart
touch lib/modules/auth/data/models/auth_tokens_dto.dart
touch lib/modules/auth/data/repositories/auth_repo_impl.dart
touch lib/modules/auth/data/mappers/auth_mapper.dart
touch lib/modules/auth/domain/entities/user_entity.dart
touch lib/modules/auth/domain/repositories/auth_repo.dart
touch lib/modules/auth/domain/usecases/request_otp.dart
touch lib/modules/auth/domain/usecases/verify_otp.dart
touch lib/modules/auth/domain/usecases/set_pin.dart
touch lib/modules/auth/domain/usecases/verify_pin.dart
touch lib/modules/auth/domain/usecases/logout.dart
touch lib/modules/auth/domain/usecases/refresh_token.dart
touch lib/modules/auth/presentation/providers/auth_state.dart
touch lib/modules/auth/presentation/providers/auth_notifier.dart
touch lib/modules/auth/presentation/providers/biometric_service.dart
touch lib/modules/auth/presentation/screens/splash_screen.dart
touch lib/modules/auth/presentation/screens/phone_screen.dart
touch lib/modules/auth/presentation/screens/otp_screen.dart
touch lib/modules/auth/presentation/screens/security_method_screen.dart
touch lib/modules/auth/presentation/screens/create_pin_screen.dart
touch lib/modules/auth/presentation/screens/enter_pin_screen.dart
touch lib/modules/auth/presentation/widgets/pin_pad.dart
touch lib/modules/auth/presentation/widgets/otp_input.dart

# Feed Module
touch lib/modules/feed/data/datasources/feed_remote_ds.dart
touch lib/modules/feed/data/models/feed_item_dto.dart
touch lib/modules/feed/data/models/feed_page_dto.dart
touch lib/modules/feed/data/repositories/feed_repo_impl.dart
touch lib/modules/feed/data/mappers/feed_mapper.dart
touch lib/modules/feed/domain/entities/feed_item.dart
touch lib/modules/feed/domain/entities/video_asset.dart
touch lib/modules/feed/domain/repositories/feed_repo.dart
touch lib/modules/feed/domain/usecases/get_feed_page.dart
touch lib/modules/feed/domain/usecases/refresh_feed.dart
touch lib/modules/feed/presentation/providers/feed_state.dart
touch lib/modules/feed/presentation/providers/feed_notifier.dart
touch lib/modules/feed/presentation/screens/feed_screen.dart
touch lib/modules/feed/presentation/widgets/feed_video_card.dart
touch lib/modules/feed/presentation/widgets/dish_overlay.dart
touch lib/modules/feed/presentation/widgets/view_restaurant_button.dart

# Addresses Module
touch lib/modules/addresses/data/datasources/addresses_remote_ds.dart
touch lib/modules/addresses/data/models/address_dto.dart
touch lib/modules/addresses/data/repositories/addresses_repo_impl.dart
touch lib/modules/addresses/data/mappers/address_mapper.dart
touch lib/modules/addresses/domain/entities/address.dart
touch lib/modules/addresses/domain/repositories/addresses_repo.dart
touch lib/modules/addresses/domain/services/delivery_zone_validator.dart
touch lib/modules/addresses/domain/usecases/get_default_address.dart
touch lib/modules/addresses/domain/usecases/set_default_address.dart
touch lib/modules/addresses/domain/usecases/get_addresses.dart
touch lib/modules/addresses/domain/usecases/add_address.dart
touch lib/modules/addresses/domain/usecases/update_address.dart
touch lib/modules/addresses/domain/usecases/delete_address.dart
touch lib/modules/addresses/domain/usecases/validate_delivery_zone.dart
touch lib/modules/addresses/presentation/providers/address_state.dart
touch lib/modules/addresses/presentation/providers/address_notifier.dart
touch lib/modules/addresses/presentation/screens/select_address_map_screen.dart
touch lib/modules/addresses/presentation/widgets/address_tile.dart
touch lib/modules/addresses/presentation/widgets/map_pin.dart

# Vendors Module
touch lib/modules/vendors/data/datasources/vendors_remote_ds.dart
touch lib/modules/vendors/data/models/vendor_dto.dart
touch lib/modules/vendors/data/models/menu_item_dto.dart
touch lib/modules/vendors/data/models/vendor_menu_dto.dart
touch lib/modules/vendors/data/repositories/vendors_repo_impl.dart
touch lib/modules/vendors/data/mappers/vendors_mapper.dart
touch lib/modules/vendors/domain/entities/vendor.dart
touch lib/modules/vendors/domain/entities/menu_item.dart
touch lib/modules/vendors/domain/repositories/vendors_repo.dart
touch lib/modules/vendors/domain/usecases/get_vendor.dart
touch lib/modules/vendors/domain/usecases/get_vendor_menu.dart
touch lib/modules/vendors/domain/usecases/get_signature_items.dart
touch lib/modules/vendors/presentation/providers/vendor_state.dart
touch lib/modules/vendors/presentation/providers/vendor_notifier.dart
touch lib/modules/vendors/presentation/screens/vendor_screen.dart
touch lib/modules/vendors/presentation/screens/vendor_reviews_screen.dart
touch lib/modules/vendors/presentation/widgets/vendor_header.dart
touch lib/modules/vendors/presentation/widgets/menu_item_tile.dart
touch lib/modules/vendors/presentation/widgets/hero_video_banner.dart

# Cart Module
touch lib/modules/cart/data/datasources/cart_remote_ds.dart
touch lib/modules/cart/data/models/cart_dto.dart
touch lib/modules/cart/data/models/cart_item_dto.dart
touch lib/modules/cart/data/repositories/cart_repo_impl.dart
touch lib/modules/cart/data/mappers/cart_mapper.dart
touch lib/modules/cart/domain/entities/cart.dart
touch lib/modules/cart/domain/entities/cart_item.dart
touch lib/modules/cart/domain/repositories/cart_repo.dart
touch lib/modules/cart/domain/usecases/get_cart.dart
touch lib/modules/cart/domain/usecases/add_to_cart.dart
touch lib/modules/cart/domain/usecases/update_cart_item.dart
touch lib/modules/cart/domain/usecases/remove_cart_item.dart
touch lib/modules/cart/domain/usecases/clear_cart.dart
touch lib/modules/cart/presentation/providers/cart_state.dart
touch lib/modules/cart/presentation/providers/cart_notifier.dart
touch lib/modules/cart/presentation/screens/cart_screen.dart
touch lib/modules/cart/presentation/screens/vendor_conflict_dialog.dart
touch lib/modules/cart/presentation/widgets/cart_item_row.dart
touch lib/modules/cart/presentation/widgets/cart_summary.dart
touch lib/modules/cart/presentation/widgets/checkout_button.dart

# Orders Module
touch lib/modules/orders/data/datasources/orders_remote_ds.dart
touch lib/modules/orders/data/models/order_dto.dart
touch lib/modules/orders/data/models/order_item_dto.dart
touch lib/modules/orders/data/models/order_tracking_dto.dart
touch lib/modules/orders/data/repositories/orders_repo_impl.dart
touch lib/modules/orders/data/mappers/orders_mapper.dart
touch lib/modules/orders/domain/entities/order.dart
touch lib/modules/orders/domain/entities/order_item.dart
touch lib/modules/orders/domain/entities/order_tracking.dart
touch lib/modules/orders/domain/repositories/orders_repo.dart
touch lib/modules/orders/domain/usecases/create_order.dart
touch lib/modules/orders/domain/usecases/get_orders.dart
touch lib/modules/orders/domain/usecases/get_order_details.dart
touch lib/modules/orders/domain/usecases/cancel_order.dart
touch lib/modules/orders/presentation/providers/orders_state.dart
touch lib/modules/orders/presentation/providers/orders_notifier.dart
touch lib/modules/orders/presentation/providers/order_details_state.dart
touch lib/modules/orders/presentation/providers/order_details_notifier.dart
touch lib/modules/orders/presentation/screens/orders_screen.dart
touch lib/modules/orders/presentation/screens/order_confirmation_screen.dart
touch lib/modules/orders/presentation/screens/order_tracking_screen.dart
touch lib/modules/orders/presentation/screens/order_completed_screen.dart
touch lib/modules/orders/presentation/screens/rating_screen.dart
touch lib/modules/orders/presentation/widgets/order_timeline.dart
touch lib/modules/orders/presentation/widgets/tracking_map_view.dart
touch lib/modules/orders/presentation/widgets/driver_contact_bar.dart
touch lib/modules/orders/presentation/widgets/rating_stars.dart

# Payments Module
touch lib/modules/payments/data/datasources/payments_remote_ds.dart
touch lib/modules/payments/data/gateways/apple_pay_gateway.dart
touch lib/modules/payments/data/gateways/mada_gateway.dart
touch lib/modules/payments/data/gateways/stc_pay_gateway.dart
touch lib/modules/payments/data/models/payment_init_dto.dart
touch lib/modules/payments/data/models/payment_confirm_dto.dart
touch lib/modules/payments/data/repositories/payments_repo_impl.dart
touch lib/modules/payments/data/mappers/payments_mapper.dart
touch lib/modules/payments/domain/entities/payment.dart
touch lib/modules/payments/domain/repositories/payments_repo.dart
touch lib/modules/payments/domain/services/payment_gateway_interface.dart
touch lib/modules/payments/domain/usecases/initiate_payment.dart
touch lib/modules/payments/domain/usecases/confirm_payment.dart
touch lib/modules/payments/presentation/providers/payment_state.dart
touch lib/modules/payments/presentation/providers/payment_notifier.dart
touch lib/modules/payments/presentation/screens/payment_screen.dart

# Map Location Module
touch lib/modules/map_location/data/datasources/geocoding_remote_ds.dart
touch lib/modules/map_location/data/datasources/distance_matrix_remote_ds.dart
touch lib/modules/map_location/data/models/geocode_result_dto.dart
touch lib/modules/map_location/data/models/distance_matrix_dto.dart
touch lib/modules/map_location/data/repositories/map_location_repo_impl.dart
touch lib/modules/map_location/data/mappers/map_location_mapper.dart
touch lib/modules/map_location/domain/entities/geo_point.dart
touch lib/modules/map_location/domain/entities/geocode_result.dart
touch lib/modules/map_location/domain/repositories/map_location_repo.dart
touch lib/modules/map_location/domain/usecases/get_current_location.dart
touch lib/modules/map_location/domain/usecases/reverse_geocode.dart
touch lib/modules/map_location/presentation/widgets/map_pin.dart
touch lib/modules/map_location/presentation/widgets/map_controls.dart

# Search Module
touch lib/modules/search/data/datasources/search_remote_ds.dart
touch lib/modules/search/data/services/vendor_search_service.dart
touch lib/modules/search/data/models/search_vendor_dto.dart
touch lib/modules/search/data/repositories/search_repo_impl.dart
touch lib/modules/search/data/mappers/search_mapper.dart
touch lib/modules/search/domain/entities/vendor_search_item.dart
touch lib/modules/search/domain/repositories/search_repo.dart
touch lib/modules/search/domain/services/search_service.dart
touch lib/modules/search/domain/usecases/search_vendors.dart
touch lib/modules/search/presentation/providers/search_state.dart
touch lib/modules/search/presentation/providers/search_notifier.dart
touch lib/modules/search/presentation/screens/search_screen.dart
touch lib/modules/search/presentation/widgets/vendor_search_tile.dart
touch lib/modules/search/presentation/widgets/search_input.dart

# Profile Module
touch lib/modules/profile/data/datasources/profile_remote_ds.dart
touch lib/modules/profile/data/models/profile_dto.dart
touch lib/modules/profile/data/repositories/profile_repo_impl.dart
touch lib/modules/profile/data/mappers/profile_mapper.dart
touch lib/modules/profile/domain/entities/profile.dart
touch lib/modules/profile/domain/repositories/profile_repo.dart
touch lib/modules/profile/domain/usecases/get_profile.dart
touch lib/modules/profile/domain/usecases/update_profile.dart
touch lib/modules/profile/presentation/providers/profile_state.dart
touch lib/modules/profile/presentation/providers/profile_notifier.dart
touch lib/modules/profile/presentation/screens/profile_screen.dart
touch lib/modules/profile/presentation/screens/edit_name_screen.dart
touch lib/modules/profile/presentation/widgets/profile_header.dart
touch lib/modules/profile/presentation/widgets/profile_tile.dart

# Shared
touch lib/shared/models/pagination.dart
touch lib/shared/enums/vendor_type.dart
touch lib/shared/enums/order_status.dart
touch lib/shared/enums/app_error_codes.dart
touch lib/shared/extensions/context_ext.dart
touch lib/shared/extensions/num_ext.dart
touch lib/shared/extensions/datetime_ext.dart

echo "All files created successfully!"
