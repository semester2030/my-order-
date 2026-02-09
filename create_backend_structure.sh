#!/bin/bash

# Navigate to backend directory
cd "/Users/fayez/Desktop/my order/backend"

# Common
touch src/common/decorators/.gitkeep
touch src/common/filters/.gitkeep
touch src/common/guards/.gitkeep
touch src/common/interceptors/.gitkeep
touch src/common/pipes/.gitkeep
touch src/common/utils/.gitkeep

# Config
touch src/config/database.config.ts
touch src/config/cloudflare.config.ts
touch src/config/payment.config.ts

# Auth Module
touch src/modules/auth/auth.module.ts
touch src/modules/auth/auth.controller.ts
touch src/modules/auth/auth.service.ts
touch src/modules/auth/strategies/otp.strategy.ts
touch src/modules/auth/strategies/pin.strategy.ts
touch src/modules/auth/guards/jwt-auth.guard.ts

# Users Module
touch src/modules/users/users.module.ts
touch src/modules/users/users.controller.ts
touch src/modules/users/users.service.ts
touch src/modules/users/entities/user.entity.ts

# Addresses Module
touch src/modules/addresses/addresses.module.ts
touch src/modules/addresses/addresses.controller.ts
touch src/modules/addresses/addresses.service.ts
touch src/modules/addresses/entities/address.entity.ts
touch src/modules/addresses/validators/delivery-zone.validator.ts

# Vendors Module
touch src/modules/vendors/vendors.module.ts
touch src/modules/vendors/vendors.controller.ts
touch src/modules/vendors/vendors.service.ts
touch src/modules/vendors/entities/vendor.entity.ts

# Menu Module
touch src/modules/menu/menu.module.ts
touch src/modules/menu/menu.controller.ts
touch src/modules/menu/menu.service.ts
touch src/modules/menu/entities/menu-item.entity.ts
touch src/modules/menu/entities/video-asset.entity.ts
touch src/modules/menu/dto/video-upload.dto.ts

# Videos Module
touch src/modules/videos/videos.module.ts
touch src/modules/videos/videos.controller.ts
touch src/modules/videos/videos.service.ts
touch src/modules/videos/cloudflare/cloudflare-stream.service.ts
touch src/modules/videos/cloudflare/cloudflare-stream.module.ts
touch src/modules/videos/entities/video-asset.entity.ts

# Feed Module
touch src/modules/feed/feed.module.ts
touch src/modules/feed/feed.controller.ts
touch src/modules/feed/feed.service.ts
touch src/modules/feed/algorithms/feed-balancer.ts
touch src/modules/feed/algorithms/eligibility-checker.ts
touch src/modules/feed/dto/feed-item.dto.ts

# Cart Module
touch src/modules/cart/cart.module.ts
touch src/modules/cart/cart.controller.ts
touch src/modules/cart/cart.service.ts
touch src/modules/cart/entities/cart.entity.ts

# Orders Module
touch src/modules/orders/orders.module.ts
touch src/modules/orders/orders.controller.ts
touch src/modules/orders/orders.service.ts
touch src/modules/orders/entities/order.entity.ts
touch src/modules/orders/events/order-events.service.ts
touch src/modules/orders/lifecycle/order-lifecycle.service.ts

# Delivery Module
touch src/modules/delivery/delivery.module.ts
touch src/modules/delivery/delivery.controller.ts
touch src/modules/delivery/delivery.service.ts
touch src/modules/delivery/assignment/order-assignment.service.ts
touch src/modules/delivery/assignment/driver-assignment.service.ts
touch src/modules/delivery/tracking/customer-tracking.service.ts
touch src/modules/delivery/tracking/driver-tracking.service.ts
touch src/modules/delivery/tracking/route-optimization.service.ts
touch src/modules/delivery/status/delivery-status.service.ts

# Drivers Module
touch src/modules/drivers/drivers.module.ts
touch src/modules/drivers/drivers.controller.ts
touch src/modules/drivers/drivers.service.ts
touch src/modules/drivers/registration/driver-registration.service.ts
touch src/modules/drivers/verification/driver-verification.service.ts
touch src/modules/drivers/profile/driver-profile.service.ts
touch src/modules/drivers/ratings/driver-ratings.service.ts
touch src/modules/drivers/earnings/driver-earnings.service.ts

# Payments Module
touch src/modules/payments/payments.module.ts
touch src/modules/payments/payments.controller.ts
touch src/modules/payments/payments.service.ts
touch src/modules/payments/gateways/apple-pay.gateway.ts
touch src/modules/payments/gateways/mada.gateway.ts
touch src/modules/payments/gateways/stc-pay.gateway.ts
touch src/modules/payments/webhooks/payment-webhook.controller.ts
touch src/modules/payments/reconciliation/payment-reconciliation.service.ts

# Notifications Module
touch src/modules/notifications/notifications.module.ts
touch src/modules/notifications/notifications.controller.ts
touch src/modules/notifications/notifications.service.ts
touch src/modules/notifications/customer/customer-notifications.service.ts
touch src/modules/notifications/driver/driver-notifications.service.ts
touch src/modules/notifications/vendor/vendor-notifications.service.ts

# Admin Module
touch src/modules/admin/admin.module.ts
touch src/modules/admin/admin.controller.ts
touch src/modules/admin/admin.service.ts

# Main
touch src/main.ts
touch src/app.module.ts

# Test
touch test/.gitkeep

echo "All backend files created successfully!"
