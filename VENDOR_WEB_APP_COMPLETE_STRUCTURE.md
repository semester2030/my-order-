# 🏗️ هيكل تطبيق المطعم الكامل (Vendor Web App) - احترافي ومكتمل

**التاريخ:** 25 يناير 2026  
**الهدف:** تطبيق ويب احترافي كامل لإدارة المطاعم الفاخرة  
**التقنيات:** Next.js 14 + React 18 + TypeScript + NestJS Backend

---

## 📐 **الهيكل العام للتطبيق**

```
vendor-web-app/
├── src/
│   ├── app/                          # Next.js App Router
│   │   ├── (auth)/                   # Auth Group Routes
│   │   │   ├── login/
│   │   │   ├── forgot-password/
│   │   │   └── reset-password/
│   │   ├── (dashboard)/              # Protected Routes
│   │   │   ├── layout.tsx            # Dashboard Layout
│   │   │   ├── page.tsx              # Dashboard Home
│   │   │   ├── orders/
│   │   │   ├── menu/
│   │   │   ├── analytics/
│   │   │   ├── reviews/
│   │   │   ├── profile/
│   │   │   ├── settings/
│   │   │   └── staff/
│   │   └── api/                      # API Routes (if needed)
│   ├── components/                   # Reusable Components
│   │   ├── ui/                       # Base UI Components (shadcn/ui)
│   │   ├── layout/                   # Layout Components
│   │   ├── orders/                   # Order-specific Components
│   │   ├── menu/                     # Menu-specific Components
│   │   ├── analytics/                # Analytics Components
│   │   └── shared/                   # Shared Components
│   ├── lib/                          # Utilities & Config
│   │   ├── api/                      # API Client
│   │   ├── hooks/                    # Custom Hooks
│   │   ├── utils/                    # Utility Functions
│   │   ├── constants/                 # Constants
│   │   └── types/                    # TypeScript Types
│   ├── store/                        # State Management (Zustand)
│   │   ├── auth.store.ts
│   │   ├── orders.store.ts
│   │   ├── menu.store.ts
│   │   └── analytics.store.ts
│   └── styles/                       # Global Styles
└── public/                           # Static Assets
```

---

## 🎯 **1. التسجيل والمصادقة (Registration & Authentication)**

### **1.1 صفحة تسجيل المطعم (Vendor Registration)**
**Route:** `/register`

#### **الوظائف:**
- ✅ **Multi-Step Form** - نموذج متعدد الخطوات (8 خطوات)
- ✅ **Step 1: Basic Information** - البيانات الأساسية
- ✅ **Step 2: Commercial Registration** - السجل التجاري
- ✅ **Step 3: Location** - الموقع (مع خريطة)
- ✅ **Step 4: Certificates** - الشهادات والتراخيص
- ✅ **Step 5: Contact Information** - بيانات الاتصال
- ✅ **Step 6: Banking** - البيانات البنكية
- ✅ **Step 7: Media** - الصور والفيديوهات
- ✅ **Step 8: Account** - بيانات الحساب
- ✅ **Save Draft** - حفظ كمسودة
- ✅ **File Upload** - رفع الوثائق
- ✅ **Validation** - التحقق من البيانات
- ✅ **Terms & Conditions** - الموافقة على الشروط

#### **البيانات المطلوبة:**
- ✅ **Basic Info:** Name, Trade Name, Type, Description, Phone, Email
- ✅ **Commercial Registration:** Number, Issue Date, Expiry Date, Image
- ✅ **Location:** Address, City, District, Coordinates (Map Picker)
- ✅ **Certificates:** Health Certificate, Municipal License, Food Safety, Others
- ✅ **Contact:** Owner Name, Phone, Email, ID Number, ID Image
- ✅ **Banking:** Bank Name, Account Number, IBAN, Account Holder
- ✅ **Media:** Logo, Cover, Restaurant Images, Video
- ✅ **Account:** Username, Password, Terms Acceptance

#### **التكامل مع الباك إند:**
```typescript
POST /api/vendors/register
Body: FormData {
  // All registration data + files
}
Response: {
  vendorId: string,
  status: 'pending_approval',
  message: 'Registration submitted successfully'
}
```

#### **التصميم:**
- Progress Bar - شريط التقدم
- Step Navigation - تنقل بين الخطوات
- File Upload with Preview - رفع الملفات مع معاينة
- Map Integration - Google Maps
- Validation per Step - التحقق من كل خطوة
- Auto-save Draft - حفظ تلقائي كمسودة

---

### **1.2 صفحة حالة التسجيل (Registration Status)**
**Route:** `/register/status`

#### **الوظائف:**
- ✅ **عرض حالة التسجيل** - Status Badge
- ✅ **Timeline** - مراحل المراجعة
- ✅ **الوثائق المرفوعة** - Uploaded Documents
- ✅ **ملاحظات الإدارة** - Admin Notes
- ✅ **Contact Support** - الاتصال بالدعم

#### **الحالات:**
- ⏳ **Pending Approval** - في انتظار المراجعة
- 🔍 **Under Review** - قيد المراجعة
- ✅ **Approved** - موافق عليه
- ❌ **Rejected** - مرفوض
- ⚠️ **Suspended** - معلق

---

### **1.3 صفحة تسجيل الدخول (Login)**
**Route:** `/login`

#### **الوظائف:**
- ✅ **إدخال رقم الهاتف أو البريد الإلكتروني**
- ✅ **إدخال كلمة المرور**
- ✅ **Remember Me** - حفظ الجلسة
- ✅ **Forgot Password** - رابط لاستعادة كلمة المرور
- ✅ **Validation** - التحقق من البيانات
- ✅ **Error Handling** - عرض الأخطاء
- ✅ **Loading State** - حالة التحميل

#### **التكامل مع الباك إند:**
```typescript
POST /api/auth/vendor/login
Body: { phone/email, password }
Response: { accessToken, refreshToken, vendor }
```

#### **التصميم:**
- تصميم احترافي مع Logo المطعم
- Form validation في الوقت الفعلي
- Error messages واضحة
- Success feedback

---

### **1.2 صفحة استعادة كلمة المرور (Forgot Password)**
**Route:** `/forgot-password`

#### **الوظائف:**
- ✅ **إدخال البريد الإلكتروني**
- ✅ **إرسال رابط الاستعادة**
- ✅ **Confirmation Message** - رسالة تأكيد
- ✅ **Resend Email** - إعادة الإرسال

#### **التكامل مع الباك إند:**
```typescript
POST /api/auth/vendor/forgot-password
Body: { email }
Response: { message: "Email sent" }
```

---

### **1.3 صفحة إعادة تعيين كلمة المرور (Reset Password)**
**Route:** `/reset-password?token=xxx`

#### **الوظائف:**
- ✅ **إدخال كلمة المرور الجديدة**
- ✅ **تأكيد كلمة المرور**
- ✅ **Validation** - قوة كلمة المرور
- ✅ **Success Redirect** - الانتقال لصفحة تسجيل الدخول

#### **التكامل مع الباك إند:**
```typescript
POST /api/auth/vendor/reset-password
Body: { token, newPassword, confirmPassword }
Response: { message: "Password reset successfully" }
```

---

## 📊 **2. لوحة المعلومات (Dashboard)**

### **2.1 الصفحة الرئيسية (Dashboard Home)**
**Route:** `/` أو `/dashboard`

#### **المحتوى:**

##### **A. إحصائيات سريعة (Quick Stats Cards):**
- ✅ **الطلبات اليوم** - عدد الطلبات اليوم + نسبة التغيير
- ✅ **المبيعات اليوم** - إجمالي المبيعات + نسبة التغيير
- ✅ **متوسط قيمة الطلب** - Average Order Value
- ✅ **التقييم الحالي** - Rating + عدد التقييمات

##### **B. الطلبات الجديدة (New Orders Widget):**
- ✅ **قائمة الطلبات الجديدة** (آخر 5 طلبات)
- ✅ **Badge** - عدد الطلبات الجديدة
- ✅ **Quick Actions** - قبول/رفض سريع
- ✅ **Link** - "View All Orders"

##### **C. المبيعات (Sales Chart):**
- ✅ **رسم بياني** - المبيعات آخر 7 أيام
- ✅ **Comparison** - مقارنة مع الأسبوع الماضي
- ✅ **Tooltip** - تفاصيل عند Hover

##### **D. العناصر الأكثر مبيعاً (Top Selling Items):**
- ✅ **قائمة** - Top 5 عناصر
- ✅ **عدد المبيعات** - لكل عنصر
- ✅ **صورة** - صورة العنصر

##### **E. الإشعارات (Notifications):**
- ✅ **قائمة الإشعارات** - آخر 5 إشعارات
- ✅ **Badge** - عدد الإشعارات غير المقروءة
- ✅ **Mark as Read** - تحديد كمقروء

##### **F. حالة المطعم (Restaurant Status):**
- ✅ **Toggle** - قبول/إيقاف الطلبات
- ✅ **Status Indicator** - Online/Offline
- ✅ **Working Hours** - ساعات العمل الحالية

#### **التكامل مع الباك إند:**
```typescript
GET /api/vendors/dashboard/stats
Response: {
  todayOrders: number,
  todaySales: number,
  averageOrderValue: number,
  rating: number,
  ratingCount: number,
  newOrdersCount: number,
  salesChart: Array<{ date, sales }>,
  topItems: Array<{ id, name, image, salesCount }>,
  notifications: Array<Notification>
}
```

#### **التصميم:**
- Grid Layout - Responsive
- Cards - لكل قسم
- Charts - Recharts
- Real-time Updates - WebSocket أو Polling

---

## 📦 **3. إدارة الطلبات (Orders Management)**

### **3.1 صفحة قائمة الطلبات (Orders List)**
**Route:** `/orders`

#### **الوظائف:**

##### **A. الفلاتر (Filters):**
- ✅ **حالة الطلب** - All, New, Preparing, Ready, Completed, Cancelled
- ✅ **التاريخ** - اليوم، الأسبوع، الشهر، مخصص
- ✅ **المبلغ** - Min/Max
- ✅ **البحث** - رقم الطلب، اسم العميل

##### **B. الجدول (Orders Table):**
- ✅ **الأعمدة:**
  - رقم الطلب (Order Number)
  - العميل (Customer Name)
  - العناصر (Items Count)
  - المبلغ (Total Amount)
  - الحالة (Status Badge)
  - التاريخ (Date/Time)
  - الإجراءات (Actions)

##### **C. الإجراءات (Actions):**
- ✅ **View Details** - عرض التفاصيل
- ✅ **Accept** - قبول الطلب
- ✅ **Reject** - رفض الطلب
- ✅ **Update Status** - تحديث الحالة
- ✅ **Print Invoice** - طباعة الفاتورة

##### **D. Pagination:**
- ✅ **Page Size** - 10, 25, 50, 100
- ✅ **Page Navigation** - Previous/Next
- ✅ **Total Count** - إجمالي الطلبات

#### **التكامل مع الباك إند:**
```typescript
GET /api/vendors/orders?status=new&dateFrom=xxx&dateTo=xxx&page=1&limit=25
Response: {
  orders: Array<Order>,
  total: number,
  page: number,
  limit: number
}
```

---

### **3.2 صفحة تفاصيل الطلب (Order Details)**
**Route:** `/orders/[id]`

#### **المحتوى:**

##### **A. معلومات الطلب (Order Info):**
- ✅ **رقم الطلب** - Order Number
- ✅ **الحالة** - Status Badge + Timeline
- ✅ **التاريخ والوقت** - Created At, Updated At
- ✅ **طريقة الدفع** - Payment Method
- ✅ **حالة الدفع** - Payment Status

##### **B. معلومات العميل (Customer Info):**
- ✅ **الاسم** - Customer Name
- ✅ **رقم الهاتف** - Phone Number
- ✅ **العنوان** - Delivery Address (Map)
- ✅ **ملاحظات** - Special Instructions

##### **C. العناصر (Order Items):**
- ✅ **قائمة العناصر:**
  - صورة العنصر
  - اسم العنصر
  - الكمية
  - السعر
  - المجموع
- ✅ **الملخص:**
  - Subtotal
  - Delivery Fee
  - Tax
  - Discount
  - **Total**

##### **D. Timeline (Order Timeline):**
- ✅ **الأحداث:**
  - Order Created
  - Order Accepted
  - Order Preparing
  - Order Ready
  - Order Out for Delivery
  - Order Delivered
- ✅ **Timestamps** - لكل حدث
- ✅ **Icons** - لكل حالة

##### **E. الإجراءات (Actions):**
- ✅ **Accept Order** - قبول الطلب
- ✅ **Reject Order** - رفض الطلب (مع سبب)
- ✅ **Update Status** - تحديث الحالة
- ✅ **Print Invoice** - طباعة الفاتورة
- ✅ **Contact Customer** - الاتصال بالعميل
- ✅ **View on Map** - عرض على الخريطة

#### **التكامل مع الباك إند:**
```typescript
GET /api/vendors/orders/:id
Response: {
  id: string,
  orderNumber: string,
  status: OrderStatus,
  customer: { name, phone, address },
  items: Array<{ menuItem, quantity, price }>,
  total: number,
  payment: { method, status },
  timeline: Array<{ status, timestamp }>,
  createdAt: Date,
  updatedAt: Date
}

PATCH /api/vendors/orders/:id/accept
PATCH /api/vendors/orders/:id/reject
Body: { reason?: string }
PATCH /api/vendors/orders/:id/status
Body: { status: OrderStatus }
```

#### **التصميم:**
- Split Layout - معلومات + Timeline
- Map Integration - Google Maps
- Print-friendly - للفواتير
- Real-time Updates - WebSocket

---

### **3.3 صفحة الطلبات الجديدة (New Orders)**
**Route:** `/orders/new`

#### **الوظائف:**
- ✅ **قائمة الطلبات الجديدة فقط**
- ✅ **Auto-refresh** - تحديث تلقائي كل 30 ثانية
- ✅ **Sound Notification** - صوت عند طلب جديد
- ✅ **Quick Actions** - قبول/رفض سريع
- ✅ **Badge** - عدد الطلبات الجديدة

---

### **3.4 صفحة الطلبات النشطة (Active Orders)**
**Route:** `/orders/active`

#### **الوظائف:**
- ✅ **الطلبات قيد التحضير** - Preparing
- ✅ **الطلبات الجاهزة** - Ready
- ✅ **الطلبات في الطريق** - Out for Delivery
- ✅ **Kanban Board** - عرض على شكل أعمدة
- ✅ **Drag & Drop** - سحب وإفلات لتغيير الحالة

---

## 🍽️ **4. إدارة القائمة (Menu Management)**

### **4.1 صفحة القائمة (Menu List)**
**Route:** `/menu`

#### **الوظائف:**

##### **A. الفئات (Categories):**
- ✅ **قائمة الفئات** - All, Signature, Regular, etc.
- ✅ **إضافة فئة جديدة**
- ✅ **تعديل/حذف فئة**
- ✅ **ترتيب الفئات** - Drag & Drop

##### **B. العناصر (Menu Items):**
- ✅ **Grid/List View** - تبديل العرض
- ✅ **البحث** - البحث في العناصر
- ✅ **الفلترة:**
  - حسب الفئة
  - حسب التوفر (Available/Unavailable)
  - حسب Signature Items

##### **C. كل عنصر (Menu Item Card):**
- ✅ **صورة** - Image
- ✅ **الاسم** - Name
- ✅ **السعر** - Price
- ✅ **حالة التوفر** - Available/Unavailable Badge
- ✅ **Signature Badge** - إذا كان Signature
- ✅ **الإجراءات:**
  - Edit
  - Delete
  - Toggle Availability
  - Upload Video

##### **D. الإجراءات العامة:**
- ✅ **Add New Item** - إضافة عنصر جديد
- ✅ **Bulk Actions** - إجراءات جماعية:
  - Mark as Available/Unavailable
  - Delete Selected
  - Export to CSV

#### **التكامل مع الباك إند:**
```typescript
GET /api/vendors/menu?category=xxx&available=true&page=1&limit=50
Response: {
  items: Array<MenuItem>,
  categories: Array<Category>,
  total: number
}

POST /api/vendors/menu
Body: { name, description, price, category, image, isSignature, isAvailable }

PUT /api/vendors/menu/:id
Body: { name, description, price, category, image, isSignature, isAvailable }

DELETE /api/vendors/menu/:id
PATCH /api/vendors/menu/:id/availability
Body: { isAvailable: boolean }
```

---

### **4.2 صفحة إضافة/تعديل عنصر (Add/Edit Menu Item)**
**Route:** `/menu/new` أو `/menu/[id]/edit`

#### **النموذج (Form):**

##### **A. المعلومات الأساسية:**
- ✅ **الاسم** - Name (Required)
- ✅ **الوصف** - Description (Rich Text Editor)
- ✅ **السعر** - Price (Required, Number)
- ✅ **الفئة** - Category (Dropdown)
- ✅ **Signature Item** - Checkbox

##### **B. الصور:**
- ✅ **صورة رئيسية** - Main Image (Upload)
- ✅ **معاينة الصورة** - Image Preview
- ✅ **Drag & Drop** - سحب وإفلات
- ✅ **Image Cropper** - قص الصورة

##### **C. الفيديو:**
- ✅ **رفع فيديو** - Video Upload
- ✅ **معاينة الفيديو** - Video Preview
- ✅ **حذف الفيديو** - Delete Video
- ✅ **Progress Bar** - شريط التقدم

##### **D. الإعدادات:**
- ✅ **حالة التوفر** - Available/Unavailable Toggle
- ✅ **ترتيب العرض** - Display Order (Number)

##### **E. الإجراءات:**
- ✅ **Save** - حفظ
- ✅ **Save & Add Another** - حفظ وإضافة آخر
- ✅ **Cancel** - إلغاء
- ✅ **Delete** - حذف (في حالة التعديل)

#### **التكامل مع الباك إند:**
```typescript
POST /api/vendors/menu
Body: FormData {
  name: string,
  description: string,
  price: number,
  category: string,
  image: File,
  video?: File,
  isSignature: boolean,
  isAvailable: boolean,
  displayOrder: number
}

PUT /api/vendors/menu/:id
Body: FormData { ... }

POST /api/vendors/menu/:id/video
Body: FormData { video: File }
```

#### **التصميم:**
- Multi-step Form - خطوات متعددة
- Image Upload - مع معاينة
- Video Upload - مع معاينة
- Validation - في الوقت الفعلي
- Auto-save - حفظ تلقائي

---

### **4.3 صفحة إدارة الفئات (Categories Management)**
**Route:** `/menu/categories`

#### **الوظائف:**
- ✅ **قائمة الفئات** - List of Categories
- ✅ **إضافة فئة** - Add Category
- ✅ **تعديل فئة** - Edit Category
- ✅ **حذف فئة** - Delete Category
- ✅ **ترتيب الفئات** - Drag & Drop
- ✅ **عدد العناصر** - Items Count per Category

---

## 📈 **5. الإحصائيات والمبيعات (Analytics)**

### **5.1 صفحة لوحة المعلومات (Analytics Dashboard)**
**Route:** `/analytics`

#### **المحتوى:**

##### **A. إحصائيات عامة (Overview Stats):**
- ✅ **إجمالي المبيعات** - Total Sales (Period)
- ✅ **عدد الطلبات** - Total Orders
- ✅ **متوسط قيمة الطلب** - Average Order Value
- ✅ **عدد العملاء** - Total Customers
- ✅ **التقييم المتوسط** - Average Rating

##### **B. رسم المبيعات (Sales Chart):**
- ✅ **Line Chart** - المبيعات عبر الزمن
- ✅ **Period Selector** - اليوم، الأسبوع، الشهر، السنة، مخصص
- ✅ **Comparison** - مقارنة مع الفترة السابقة
- ✅ **Tooltip** - تفاصيل عند Hover
- ✅ **Export** - تصدير كـ PNG/PDF

##### **C. توزيع الطلبات (Orders Distribution):**
- ✅ **Pie Chart** - حسب الحالة
- ✅ **Bar Chart** - حسب اليوم/الساعة
- ✅ **Heatmap** - خريطة حرارية للأوقات

##### **D. العناصر الأكثر مبيعاً (Top Selling Items):**
- ✅ **Table** - Top 10 عناصر
- ✅ **الأعمدة:**
  - الترتيب
  - صورة العنصر
  - اسم العنصر
  - عدد المبيعات
  - إجمالي المبيعات
  - نسبة من الإجمالي
- ✅ **Chart** - Bar Chart للمبيعات

##### **E. أوقات الذروة (Peak Hours):**
- ✅ **Line Chart** - الطلبات حسب الساعة
- ✅ **Heatmap** - خريطة حرارية
- ✅ **Insights** - توصيات

##### **F. العملاء (Customers):**
- ✅ **عدد العملاء الجدد** - New Customers
- ✅ **العملاء المتكررين** - Returning Customers
- ✅ **Customer Lifetime Value** - CLV

##### **G. التقييمات (Ratings):**
- ✅ **توزيع التقييمات** - Rating Distribution
- ✅ **متوسط التقييم** - Average Rating
- ✅ **Trend** - اتجاه التقييمات

#### **التكامل مع الباك إند:**
```typescript
GET /api/vendors/analytics/overview?period=week&dateFrom=xxx&dateTo=xxx
Response: {
  totalSales: number,
  totalOrders: number,
  averageOrderValue: number,
  totalCustomers: number,
  averageRating: number,
  salesChart: Array<{ date, sales, orders }>,
  ordersDistribution: { status, count },
  topItems: Array<{ id, name, image, salesCount, revenue }>,
  peakHours: Array<{ hour, orders }>,
  customers: { new, returning, clv },
  ratings: { average, distribution, trend }
}
```

#### **التصميم:**
- Dashboard Layout - Grid
- Interactive Charts - Recharts
- Date Range Picker
- Export Options - PNG, PDF, CSV
- Real-time Updates

---

### **5.2 صفحة التقارير (Reports)**
**Route:** `/analytics/reports`

#### **الوظائف:**
- ✅ **تقرير يومي** - Daily Report
- ✅ **تقرير أسبوعي** - Weekly Report
- ✅ **تقرير شهري** - Monthly Report
- ✅ **تقرير سنوي** - Yearly Report
- ✅ **تقرير مخصص** - Custom Report
- ✅ **تصدير** - Export to PDF/Excel
- ✅ **جدولة التقارير** - Schedule Reports (Email)

#### **محتوى التقرير:**
- ✅ **ملخص تنفيذي** - Executive Summary
- ✅ **المبيعات** - Sales Breakdown
- ✅ **الطلبات** - Orders Analysis
- ✅ **العناصر** - Items Performance
- ✅ **العملاء** - Customers Analysis
- ✅ **التقييمات** - Ratings Analysis

---

## ⭐ **6. إدارة التقييمات (Reviews Management)**

### **6.1 صفحة التقييمات (Reviews List)**
**Route:** `/reviews`

#### **الوظائف:**

##### **A. الفلاتر:**
- ✅ **حسب التقييم** - All, 5 Stars, 4 Stars, etc.
- ✅ **حسب التاريخ** - Period Selector
- ✅ **البحث** - اسم العميل، نص التقييم

##### **B. قائمة التقييمات:**
- ✅ **كل تقييم:**
  - صورة العميل (Avatar)
  - اسم العميل
  - التقييم (Stars)
  - نص التقييم
  - التاريخ
  - الطلب المرتبط (Link)
  - الرد (Reply)
  - الإجراءات (Actions)

##### **C. الإجراءات:**
- ✅ **الرد على التقييم** - Reply to Review
- ✅ **حذف الرد** - Delete Reply
- ✅ **Report** - الإبلاغ عن تقييم غير مناسب

##### **D. الإحصائيات:**
- ✅ **متوسط التقييم** - Average Rating
- ✅ **عدد التقييمات** - Total Reviews
- ✅ **توزيع التقييمات** - Rating Distribution Chart

#### **التكامل مع الباك إند:**
```typescript
GET /api/vendors/reviews?rating=5&dateFrom=xxx&dateTo=xxx&page=1&limit=25
Response: {
  reviews: Array<{
    id: string,
    customer: { name, avatar },
    rating: number,
    comment: string,
    orderId: string,
    reply?: string,
    createdAt: Date
  }>,
  stats: {
    average: number,
    total: number,
    distribution: { 5: number, 4: number, ... }
  },
  total: number
}

POST /api/vendors/reviews/:id/reply
Body: { reply: string }
```

---

## 👤 **7. الملف الشخصي والإعدادات (Profile & Settings)**

### **7.1 صفحة الملف الشخصي (Profile)**
**Route:** `/profile`

#### **المحتوى:**

##### **A. معلومات المطعم:**
- ✅ **الاسم** - Restaurant Name
- ✅ **الوصف** - Description (Rich Text)
- ✅ **رقم الهاتف** - Phone Number
- ✅ **البريد الإلكتروني** - Email
- ✅ **العنوان** - Address
- ✅ **الموقع** - Location (Map Picker)
- ✅ **ساعات العمل** - Working Hours

##### **B. الصور:**
- ✅ **Logo** - Upload/Change Logo
- ✅ **Cover Image** - Upload/Change Cover
- ✅ **معاينة** - Preview

##### **C. الإعدادات:**
- ✅ **نوع المطعم** - Restaurant Type
- ✅ **مناطق التوصيل** - Delivery Zones (Map)
- ✅ **قبول الطلبات** - Accepting Orders Toggle
- ✅ **حالة المطعم** - Active/Inactive

---

### **7.2 صفحة إدارة الوثائق (Documents Management)**
**Route:** `/profile/documents`

#### **الوظائف:**
- ✅ **عرض جميع الوثائق** - View All Documents
- ✅ **السجل التجاري** - Commercial Registration
  - رقم السجل
  - تاريخ الإصدار/الانتهاء
  - صورة السجل
  - حالة التحقق
- ✅ **شهادة الصحة** - Health Certificate
  - رقم الشهادة
  - التواريخ
  - الصورة
  - حالة التحقق
- ✅ **رخصة البلدية** - Municipal License
  - رقم الرخصة
  - التواريخ
  - الصورة
  - حالة التحقق
- ✅ **شهادات أخرى** - Other Certificates
  - قائمة الشهادات
  - إضافة شهادة جديدة
  - تحديث/حذف
- ✅ **رفع وثائق جديدة** - Upload New Documents
- ✅ **تحديث وثائق منتهية** - Update Expired Documents
- ✅ **تنبيهات الانتهاء** - Expiry Alerts (30 days before)
- ✅ **حالة التحقق** - Verification Status Badge

#### **التكامل مع الباك إند:**
```typescript
GET    /api/vendors/profile/documents
POST   /api/vendors/profile/documents
PUT    /api/vendors/profile/documents/:id
DELETE /api/vendors/profile/documents/:id
```

#### **المحتوى:**

##### **A. معلومات المطعم:**
- ✅ **الاسم** - Restaurant Name
- ✅ **الوصف** - Description (Rich Text)
- ✅ **رقم الهاتف** - Phone Number
- ✅ **البريد الإلكتروني** - Email
- ✅ **العنوان** - Address
- ✅ **الموقع** - Location (Map Picker)
- ✅ **ساعات العمل** - Working Hours

##### **B. الصور:**
- ✅ **Logo** - Upload/Change Logo
- ✅ **Cover Image** - Upload/Change Cover
- ✅ **معاينة** - Preview

##### **C. الإعدادات:**
- ✅ **نوع المطعم** - Restaurant Type
- ✅ **مناطق التوصيل** - Delivery Zones (Map)
- ✅ **قبول الطلبات** - Accepting Orders Toggle
- ✅ **حالة المطعم** - Active/Inactive

#### **التكامل مع الباك إند:**
```typescript
GET /api/vendors/profile
Response: {
  id: string,
  name: string,
  description: string,
  phoneNumber: string,
  email: string,
  address: string,
  latitude: number,
  longitude: number,
  logo: string,
  cover: string,
  type: VendorType,
  workingHours: { day, open, close }[],
  deliveryZones: Array<{ id, name, coordinates }>,
  isActive: boolean,
  isAcceptingOrders: boolean
}

PUT /api/vendors/profile
Body: { name, description, phoneNumber, email, address, ... }

POST /api/vendors/profile/logo
Body: FormData { logo: File }

POST /api/vendors/profile/cover
Body: FormData { cover: File }

PATCH /api/vendors/profile/accepting-orders
Body: { isAcceptingOrders: boolean }
```

---

### **7.3 صفحة الإعدادات (Settings)**
**Route:** `/settings`

#### **الأقسام:**

##### **A. إعدادات الحساب:**
- ✅ **تغيير كلمة المرور** - Change Password
- ✅ **البريد الإلكتروني** - Email Settings
- ✅ **رقم الهاتف** - Phone Settings

##### **B. إعدادات الإشعارات:**
- ✅ **إشعارات الطلبات** - Order Notifications
- ✅ **إشعارات التقييمات** - Review Notifications
- ✅ **إشعارات المبيعات** - Sales Notifications
- ✅ **Email Notifications** - إشعارات البريد
- ✅ **SMS Notifications** - إشعارات SMS

##### **C. إعدادات الدفع:**
- ✅ **معلومات الحساب البنكي** - Bank Account
- ✅ **جدولة الدفع** - Payout Schedule
- ✅ **سجل المدفوعات** - Payment History

##### **D. إعدادات الأمان:**
- ✅ **Two-Factor Authentication** - 2FA
- ✅ **Session Management** - إدارة الجلسات
- ✅ **Activity Log** - سجل الأنشطة

##### **E. إعدادات أخرى:**
- ✅ **اللغة** - Language
- ✅ **المنطقة الزمنية** - Timezone
- ✅ **التاريخ والوقت** - Date/Time Format

---

## 👥 **8. إدارة الموظفين (Staff Management)**

### **8.1 صفحة الموظفين (Staff List)**
**Route:** `/staff`

#### **الوظائف:**
- ✅ **قائمة الموظفين** - Staff Members
- ✅ **إضافة موظف** - Add Staff
- ✅ **تعديل موظف** - Edit Staff
- ✅ **حذف موظف** - Delete Staff
- ✅ **الصلاحيات** - Permissions/Roles

#### **معلومات الموظف:**
- ✅ **الاسم** - Name
- ✅ **البريد الإلكتروني** - Email
- ✅ **رقم الهاتف** - Phone
- ✅ **الدور** - Role (Manager, Chef, Waiter, etc.)
- ✅ **الصلاحيات** - Permissions
- ✅ **حالة الحساب** - Active/Inactive

---

## 🔔 **9. الإشعارات (Notifications)**

### **9.1 صفحة الإشعارات (Notifications)**
**Route:** `/notifications`

#### **الوظائف:**
- ✅ **قائمة الإشعارات** - All Notifications
- ✅ **فلترة** - حسب النوع (Orders, Reviews, etc.)
- ✅ **Mark as Read** - تحديد كمقروء
- ✅ **Mark All as Read** - تحديد الكل كمقروء
- ✅ **Delete** - حذف الإشعارات

#### **أنواع الإشعارات:**
- ✅ **طلبات جديدة** - New Orders
- ✅ **تحديثات الطلبات** - Order Updates
- ✅ **تقييمات جديدة** - New Reviews
- ✅ **تحديثات الملف الشخصي** - Profile Updates
- ✅ **تنبيهات المبيعات** - Sales Alerts

---

## 🗺️ **10. الخريطة (Map View)**

### **10.1 صفحة الخريطة (Orders Map)**
**Route:** `/orders/map`

#### **الوظائف:**
- ✅ **عرض الطلبات على الخريطة** - Orders on Map
- ✅ **Markers** - علامات للطلبات
- ✅ **Info Window** - معلومات الطلب عند النقر
- ✅ **Routes** - مسارات التوصيل
- ✅ **Filter** - فلترة حسب الحالة

---

## 🔒 **11. الأمان والصلاحيات (Security & Permissions)**

### **11.1 Role-Based Access Control (RBAC)**

#### **الأدوار (Roles):**
- ✅ **Owner** - المالك (صلاحيات كاملة)
- ✅ **Manager** - المدير (إدارة كاملة)
- ✅ **Chef** - الشيف (الطلبات والقائمة)
- ✅ **Waiter** - النادل (الطلبات فقط)
- ✅ **Cashier** - الصراف (الطلبات والدفع)

#### **الصلاحيات (Permissions):**
- ✅ **Orders** - View, Accept, Reject, Update Status
- ✅ **Menu** - View, Add, Edit, Delete
- ✅ **Analytics** - View Reports
- ✅ **Reviews** - View, Reply
- ✅ **Settings** - View, Edit
- ✅ **Staff** - View, Add, Edit, Delete

---

## 📱 **12. Responsive Design**

### **12.1 Breakpoints:**
- ✅ **Mobile** - < 768px
- ✅ **Tablet** - 768px - 1024px
- ✅ **Desktop** - > 1024px

### **12.2 Mobile Optimizations:**
- ✅ **Touch-friendly** - أزرار كبيرة
- ✅ **Swipe Gestures** - إيماءات السحب
- ✅ **Bottom Navigation** - تنقل سفلي
- ✅ **Collapsible Sections** - أقسام قابلة للطي

---

## 🎨 **13. Design System**

### **13.1 الألوان (Colors):**
- ✅ **Primary** - لون أساسي
- ✅ **Secondary** - لون ثانوي
- ✅ **Success** - نجاح
- ✅ **Warning** - تحذير
- ✅ **Error** - خطأ
- ✅ **Info** - معلومات

### **13.2 Typography:**
- ✅ **Font Family** - خط احترافي
- ✅ **Font Sizes** - أحجام متنوعة
- ✅ **Font Weights** - أوزان مختلفة

### **13.3 Components:**
- ✅ **Buttons** - أزرار
- ✅ **Forms** - نماذج
- ✅ **Tables** - جداول
- ✅ **Cards** - بطاقات
- ✅ **Modals** - نوافذ منبثقة
- ✅ **Charts** - رسوم بيانية

---

## 🔄 **14. Real-time Features**

### **14.1 WebSocket Integration:**
- ✅ **New Orders** - طلبات جديدة فورية
- ✅ **Order Updates** - تحديثات الطلبات
- ✅ **Notifications** - إشعارات فورية

### **14.2 Polling (Fallback):**
- ✅ **Auto-refresh** - تحديث تلقائي كل 30 ثانية

---

## 📦 **15. Backend Endpoints المطلوبة**

### **15.1 Authentication & Registration:**
```typescript
POST   /api/vendors/register              # Register new vendor
GET    /api/vendors/registration-status/:id  # Check registration status
POST   /api/auth/vendor/login
POST   /api/auth/vendor/forgot-password
POST   /api/auth/vendor/reset-password
POST   /api/auth/vendor/refresh
POST   /api/auth/vendor/logout
```

### **15.2 Dashboard:**
```typescript
GET    /api/vendors/dashboard/stats
GET    /api/vendors/dashboard/notifications
```

### **15.3 Orders:**
```typescript
GET    /api/vendors/orders
GET    /api/vendors/orders/:id
PATCH  /api/vendors/orders/:id/accept
PATCH  /api/vendors/orders/:id/reject
PATCH  /api/vendors/orders/:id/status
GET    /api/vendors/orders/:id/invoice
```

### **15.4 Menu:**
```typescript
GET    /api/vendors/menu
POST   /api/vendors/menu
PUT    /api/vendors/menu/:id
DELETE /api/vendors/menu/:id
PATCH  /api/vendors/menu/:id/availability
POST   /api/vendors/menu/:id/video
GET    /api/vendors/menu/categories
POST   /api/vendors/menu/categories
PUT    /api/vendors/menu/categories/:id
DELETE /api/vendors/menu/categories/:id
```

### **15.5 Analytics:**
```typescript
GET    /api/vendors/analytics/overview
GET    /api/vendors/analytics/sales
GET    /api/vendors/analytics/orders
GET    /api/vendors/analytics/items
GET    /api/vendors/analytics/customers
GET    /api/vendors/analytics/reports
```

### **15.6 Reviews:**
```typescript
GET    /api/vendors/reviews
GET    /api/vendors/reviews/stats
POST   /api/vendors/reviews/:id/reply
DELETE /api/vendors/reviews/:id/reply
```

### **15.7 Profile:**
```typescript
GET    /api/vendors/profile
PUT    /api/vendors/profile
POST   /api/vendors/profile/logo
POST   /api/vendors/profile/cover
PATCH  /api/vendors/profile/accepting-orders
PUT    /api/vendors/profile/delivery-zones
```

### **15.8 Settings:**
```typescript
PATCH  /api/vendors/settings/password
PATCH  /api/vendors/settings/notifications
GET    /api/vendors/settings
PUT    /api/vendors/settings
```

### **15.9 Staff:**
```typescript
GET    /api/vendors/staff
POST   /api/vendors/staff
PUT    /api/vendors/staff/:id
DELETE /api/vendors/staff/:id
```

---

## 🚀 **16. Deployment & Infrastructure**

### **16.1 Frontend:**
- ✅ **Vercel** - Deploy مجاني
- ✅ **Environment Variables** - متغيرات البيئة
- ✅ **CDN** - تحميل سريع

### **16.2 Backend:**
- ✅ **Docker** - Containerization
- ✅ **Nginx** - Reverse Proxy
- ✅ **SSL** - HTTPS

### **16.3 Database:**
- ✅ **PostgreSQL** - قاعدة البيانات
- ✅ **Backups** - نسخ احتياطية

---

## 📋 **17. Checklist للتنفيذ**

### **Phase 1: الأساسيات (Week 1-2)**
- [ ] إعداد Next.js Project
- [ ] إعداد TypeScript
- [ ] إعداد Authentication
- [ ] إعداد API Client
- [ ] إعداد State Management
- [ ] إعداد UI Components

### **Phase 2: Core Features (Week 3-4)**
- [ ] Dashboard
- [ ] Orders Management
- [ ] Menu Management
- [ ] Profile & Settings

### **Phase 3: Advanced Features (Week 5-6)**
- [ ] Analytics
- [ ] Reviews
- [ ] Staff Management
- [ ] Notifications

### **Phase 4: Polish & Testing (Week 7-8)**
- [ ] Responsive Design
- [ ] Performance Optimization
- [ ] Testing
- [ ] Documentation

---

**التاريخ:** 25 يناير 2026  
**الحالة:** ✅ **COMPLETE STRUCTURE - READY FOR IMPLEMENTATION**
