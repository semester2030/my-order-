# Backend Push Notifications Implementation Plan

## 📋 Overview

تنفيذ Push Notifications باستخدام Firebase Cloud Messaging (FCM) في Backend NestJS لإرسال Job Offers للسائقين.

## 🎯 المتطلبات

### 1. Firebase Cloud Messaging (FCM)
- ✅ استخدام `firebase-admin` package
- ✅ إعداد Firebase Admin SDK
- ✅ حفظ FCM tokens للسائقين

### 2. Driver Notifications Service
- ✅ إرسال Job Offer notifications
- ✅ إرسال Delivery updates
- ✅ إرسال Earnings notifications

### 3. Integration مع Jobs Service
- ✅ إرسال notification عند إنشاء Job Offer
- ✅ إرسال notification عند قبول/رفض Job
- ✅ إرسال notification عند انتهاء Job Offer

## 📦 Packages المطلوبة

```json
{
  "firebase-admin": "^12.0.0"
}
```

## 🏗️ Architecture

```
backend/src/
├─ modules/
│  ├─ notifications/
│  │  ├─ fcm/
│  │  │  ├─ fcm.module.ts
│  │  │  ├─ fcm.service.ts          # Firebase Admin SDK wrapper
│  │  │  └─ fcm.config.ts           # Firebase config
│  │  ├─ driver/
│  │  │  └─ driver-notifications.service.ts  # Driver-specific notifications
│  │  └─ notifications.module.ts
│  ├─ drivers/
│  │  └─ entities/
│  │     └─ driver.entity.ts        # Add fcmToken field
│  └─ jobs/
│     └─ jobs.service.ts            # Send notification on job creation
```

## 🔧 Implementation Steps

### Step 1: Install Firebase Admin
```bash
npm install firebase-admin
```

### Step 2: Add FCM Token to Driver Entity
```typescript
@Column({ name: 'fcm_token', nullable: true })
fcmToken: string | null;
```

### Step 3: Create FCM Service
- Initialize Firebase Admin
- Send notification method
- Handle errors

### Step 4: Update Driver Notifications Service
- Send job offer notification
- Send delivery updates
- Send earnings notifications

### Step 5: Update Jobs Service
- Send notification when job offer is created
- Send notification when job is accepted/rejected

### Step 6: Add FCM Token Endpoint
- `POST /drivers/fcm-token` - Update FCM token

## 📱 Notification Payload Structure

### Job Offer Notification
```json
{
  "notification": {
    "title": "New Job Offer",
    "body": "Order #ORD-2026-000001 - 25.50 SAR"
  },
  "data": {
    "type": "job_offer",
    "jobOfferId": "uuid",
    "orderId": "uuid",
    "orderNumber": "ORD-2026-000001",
    "driverEarnings": "25.50",
    "estimatedDistance": "5.2",
    "estimatedDuration": "15",
    "expiresAt": "2026-01-25T10:15:00Z"
  }
}
```

## 🚀 Flow

1. **Order Ready** → `OrdersService` calls `JobsService.createJobOfferFromOrder()`
2. **Job Created** → `JobsService` calls `DriverNotificationsService.sendJobOfferNotification()`
3. **FCM Service** → Sends push notification to online drivers
4. **Driver App** → Receives notification, shows dialog
5. **Driver Accepts** → Calls `POST /jobs/accept`
6. **Backend** → Updates job status, sends confirmation notification

## ⚠️ Important Notes

- FCM tokens must be stored per driver
- Handle token refresh/update
- Handle notification failures gracefully
- Filter drivers by location (optional)
- Only send to online drivers
- Handle expired tokens

---

**Status**: 📋 **PLAN READY** - Ready for implementation
