# 🔌 شرح Ports في المشروع

## 📋 **الـ Ports المستخدمة:**

| المكون | Port | الوصف |
|--------|------|-------|
| **Backend** (NestJS) | `3001` | API Server - جميع الـ APIs |
| **Vendor Web App** (Next.js) | `3000` | موقع Vendors فقط |
| **Customer App** (Flutter) | - | يتصل بـ Backend على `3001` |

---

## ⚠️ **المشكلة:**

### **قبل الإصلاح:**
```
Flutter App → http://localhost:3000/api/feed
    ↓
Vendor Web App (Next.js) ❌
    ↓
404 Error (لأن Next.js لا يحتوي على /feed endpoint)
```

### **بعد الإصلاح:**
```
Flutter App → http://localhost:3001/api/feed
    ↓
Backend (NestJS) ✅
    ↓
GET /api/feed → FeedController → FeedService
    ↓
Returns feed data with videos ✅
```

---

## ✅ **الحل:**

**Flutter App يجب أن يتصل بـ Backend على port 3001:**

```dart
// customer_app/lib/core/network/endpoints.dart
static const String baseUrl = 'http://localhost:3001/api'; // ✅ Backend
```

**ليس:**
```dart
static const String baseUrl = 'http://localhost:3000/api'; // ❌ Vendor Web App
```

---

## 🎯 **الخلاصة:**

- ✅ **Backend** على `3001` - يحتوي على `/feed` endpoint
- ✅ **Vendor Web App** على `3000` - لا يحتوي على `/feed`
- ✅ **Flutter App** يجب أن يتصل بـ `3001` (Backend)

**تم إصلاح المشكلة!** 🎉
