# عقد API — تطبيق مقدم الخدمة (Vendor App)

مرجع موحد لمسارات الـ API وأمثلة request/response بين الفرونت اند والباك اند.

**Base URL:** من إعدادات التطبيق (مثلاً `https://api.example.com`).

---

## ربط التطبيق بلوحة الإدارة (Admin Panel)

التطبيق **مربوط بنفس الباك اند** الذي تستخدمه لوحة الإدارة (ويب فيندر السابق). قبول مقدم الخدمة ورفضه يتم **من لوحة الإدارة**:

1. **مقدم الخدمة** يسجّل من التطبيق → الباك اند يخزّن الحساب بحالة `pending` (قيد المراجعة).
2. **الإدارة** من **لوحة الإدارة (Admin Panel)** تقبل أو ترفض الطلب وتُدخل سبب الرفض إن وُجد.
3. **الباك اند** يحدّث حقول `registrationStatus` و `rejectionReason` في قاعدة البيانات.
4. **التطبيق** عند جلب البروفايل (`GET /vendors/profile`) يستلم `registrationStatus` و `rejectionReason` ويعرض للمستخدم شاشة «قيد المراجعة» أو «تم الرفض» مع سبب الرفض.

لا يوجد اتصال مباشر بين التطبيق ولوحة الإدارة؛ كلاهما يتحدث مع **نفس API الباك اند**، والتطبيق يقرأ فقط نتيجة قرار الإدارة من البروفايل.

---

## 1. Auth

### POST /auth/vendor/login

**Request:**
```json
{
  "email": "vendor@example.com",
  "password": "••••••••"
}
```

**Response (200):**
```json
{
  "accessToken": "eyJhbG...",
  "refreshToken": "eyJhbG...",
  "expiresIn": 3600
}
```

---

### POST /vendors/register

**Request:**
```json
{
  "name": "مطبخ الورد",
  "email": "vendor@example.com",
  "password": "••••••••",
  "phoneNumber": "0500000000",
  "providerCategory": "popular_cooking",
  "tradeName": "Kitchen Alward",
  "description": "وصف المقدم",
  "popularCookingAddOns": "[{\"name\":\"جريش\",\"price\":50}]"
}
```

**Response (201):**
```json
{
  "vendorId": "vendor-uuid",
  "status": "pending",
  "message": "تم استلام طلب التسجيل"
}
```

---

## 2. Profile

### GET /vendors/profile

**Headers:** `Authorization: Bearer <accessToken>`

**Response (200):**
```json
{
  "id": "vendor-uuid",
  "name": "مطبخ الورد",
  "tradeName": "Kitchen Alward",
  "email": "vendor@example.com",
  "phoneNumber": "0500000000",
  "description": "وصف",
  "address": "العنوان",
  "city": "الرياض",
  "providerCategory": "popular_cooking",
  "isActive": true,
  "isAcceptingOrders": true,
  "registrationStatus": "approved",
  "rejectionReason": null
}
```

- **registrationStatus:** `pending` | `approved` | `rejected` — تُحدَّث من **لوحة الإدارة** (قبول/رفض مقدم الخدمة).
- **rejectionReason:** سبب الرفض إن وُجد؛ يُدخله الأدمن عند الرفض ويُعرَض للمستخدم في التطبيق.

### PUT /vendors/profile

**Request:** نفس حقول البروفايل (id مطلوب، الباقي حسب التحديث).

**Response (200):** نفس شكل GET /vendors/profile.

### POST /vendors/change-password

**Request:**
```json
{
  "currentPassword": "••••••••",
  "newPassword": "••••••••"
}
```

**Response (200):** `{}` أو `{ "message": "تم تغيير كلمة المرور" }`.

---

## 3. Orders

### GET /vendors/orders

**Query:** `?page=1&limit=20&status=pending` (اختياري).

**Response (200):**
```json
{
  "data": [
    {
      "id": "order-uuid",
      "customerName": "عميل",
      "customerPhone": "0500000000",
      "status": "pending",
      "totalAmount": 150.0,
      "createdAt": "2025-01-28T12:00:00Z",
      "items": [
        {
          "id": "item-uuid",
          "name": "وجبة",
          "quantity": 2,
          "unitPrice": 50.0,
          "addOns": []
        }
      ]
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

### GET /vendors/orders/:id

**Response (200):** كائن طلب واحد بنفس الشكل أعلاه (مع items).

### POST /vendors/orders/:id/accept

**Response (200):** `{}` أو الطلب المحدّث.

### POST /vendors/orders/:id/reject

**Request (اختياري):**
```json
{ "reason": "سبب الرفض" }
```

**Response (200):** `{}` أو الطلب المحدّث.

### PATCH /vendors/orders/:id/status

**Request:**
```json
{ "status": "preparing" }
```

**Response (200):** الطلب المحدّث.

---

## 4. Menu

### GET /vendors/menu

**Query:** `?page=1&limit=20` (اختياري).

**Response (200):** قائمة وجبات مع pagination (data + meta).

### POST /vendors/menu

**Request:** اسم، وصف، سعر، صورة، توفر، إلخ.

### PUT /vendors/menu/:id

**Request:** نفس حقول الوجبة للتحديث.

### PATCH /vendors/menu/:id/availability

**Request:** `{ "isAvailable": true }`.

---

## 5. Services

نفس هيكل Menu إن كان الـ backend يستخدم endpoint منفصل، أو توضيح أنه نفس `/vendors/menu` مع `type=service`.

### GET /vendors/services

**Response:** قائمة خدمات مع pagination.

---

## 6. Staff

### GET /vendors/staff

**Response:** قائمة موظفين مع pagination.

### POST /vendors/staff — PUT /vendors/staff/:id

CRUD للموظفين.

---

## 7. Analytics

### GET /vendors/analytics

**Query:** `?from=2025-01-01&to=2025-01-31` (اختياري).

**Response (200):**
```json
{
  "pendingOrders": 5,
  "completedOrders": 120,
  "totalRevenue": 15000.0,
  "menuItemsCount": 25
}
```

---

## 8. Videos / Media

### POST /videos/upload/init

**Request:** اسم الملف، نوع المحتوى، حجم (إن وُجد).

**Response:** `uploadId`, `uploadUrl` أو ما يوفره الباك اند.

### POST /videos/upload/complete

**Request:** `uploadId` وربما مفتاح الملف النهائي.

### رفع الملف الفعلي

إما إلى `uploadUrl` من init أو endpoint واحد لرفع الملف (حسب تصميم الباك اند).

---

## Pagination (meta)

جميع قوائم الـ GET التي تدعم pagination ترجع:

```json
{
  "data": [ ... ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 100,
    "totalPages": 5
  }
}
```

---

## رموز الحالة

- **200** — نجاح
- **201** — تم الإنشاء (مثلاً تسجيل مقدم جديد)
- **400 / 422** — خطأ في التحقق من المدخلات
- **401** — غير مصرح (توكن منتهي أو غير صالح)
- **403** — ممنوع
- **404** — المورد غير موجود
- **500 / 502 / 503** — خطأ في الخادم
