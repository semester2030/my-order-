# خطة تنفيذ الطلب المسبق للطبخ المنزلي — دقيقة ومفصّلة

## الهدف

إضافة ميزة "أريد الطلب جاهزاً بعد ساعة / في وقت محدد" دون التأثير على واجهة المستخدم الحالية، مع تحديد المكان المناسب لكل تغيير.

---

## ١. أين نضع الميزات (بدون تأثير سلبي على الواجهة)

### مبدأ التصميم

- **الفيد والسلة:** لا نغيّر — يبقى "أضف للسلة" كما هو.
- **نقطة الاختيار الوحيدة:** بين الضغط على "إتمام الطلب" وفتح شاشة الدفع.
- **الطباخة:** إعدادات إضافية في شاشة موجودة (الإعدادات/الملف الشخصي).

---

### ١.١ تطبيق العميل (Customer App)

| الموقع | التعديل | التأثير على الواجهة |
|--------|---------|----------------------|
| **cart_screen.dart** | إضافة **قسم صغير** فوق زر "إتمام الطلب": "متى تريد الطلب؟" — خياران: "جاهز الآن" (افتراضي) أو "في وقت محدد" مع منتقي تاريخ/وقت | ✅ تأثير بسيط — قسم اختياري، الافتراضي "جاهز الآن" يحافظ على السلوك الحالي |
| **أو: Bottom Sheet** | عند الضغط على "إتمام الطلب" تظهر نافذة من الأسفل: العنوان + "متى تريد الطلب؟" + زر "متابعة للدفع" | ✅ لا تغيير على شاشة السلة — كل شيء في النافذة |
| **payment_screen.dart** | لا تغيير | — |
| **feed_screen.dart** | لا تغيير | — |
| **dish_overlay.dart** | لا تغيير | — |

**التوصية:** استخدام **Bottom Sheet** عند الضغط على "إتمام الطلب" — يحافظ على السلة نظيفة ويجمع العنوان + الوقت في خطوة واحدة.

---

### ١.٢ تطبيق الطباخ (Vendor App)

| الموقع | التعديل | التأثير على الواجهة |
|--------|---------|----------------------|
| **edit_profile_screen.dart** أو **settings** | إضافة قسم "إعدادات الطلبات المسبقة": حد أدنى للتحضير (ساعة، ساعتان)، أيام العمل (إن لم يكن workingHours مستخدماً) | ✅ قسم جديد في صفحة موجودة |
| **orders_screen.dart** | عرض عمود/حقل "مطلوب الساعة X" بجانب كل طلب | ✅ إضافة حقل فقط |
| **order_detail_screen** (إن وُجد) | عرض "العميل يريده جاهزاً الساعة X" | ✅ إضافة نص |

---

### ١.٣ موقع الطباخ (Vendor Web)

| الموقع | التعديل | التأثير على الواجهة |
|--------|---------|----------------------|
| **settings/page.tsx** | نفس إعدادات "الطلبات المسبقة" (حد أدنى للتحضير، أيام العمل) | ✅ قسم في صفحة موجودة |

---

## ٢. ما الذي يحتاج Backend؟

### نعم — كل التغييرات التالية في Backend

| المكون | التعديل | الملف |
|--------|---------|--------|
| **Order Entity** | إضافة `requestedReadyAt` (timestamp nullable)، `orderType` (enum: ready_now \| scheduled) | `backend/src/modules/orders/entities/order.entity.ts` |
| **CreateOrderDto** | إضافة `requestedReadyAt?: string` (ISO)، `orderType?: 'ready_now' \| 'scheduled'` | `backend/src/modules/orders/dto/create-order.dto.ts` |
| **OrdersService** | حفظ `requestedReadyAt` و `orderType` عند إنشاء الطلب | `backend/src/modules/orders/orders.service.ts` |
| **Vendor Entity** | إضافة `minPreparationMinutes` (nullable، مثلاً 60 أو 120) | `backend/src/modules/vendors/entities/vendor.entity.ts` |
| **UpdateVendorProfileDto** | إضافة `minPreparationMinutes?: number` | `backend/src/modules/vendors/dto/update-vendor-profile.dto.ts` |
| **Migration** | إضافة أعمدة `requested_ready_at`، `order_type` في orders، و `min_preparation_minutes` في vendors | `backend/src/migrations/` |

---

## ٣. هل تحتاج إضافة إلى Render؟

### نعم — بعد تعديل Backend

| الخطوة | الوصف |
|--------|--------|
| 1 | تنفيذ Migration محلياً للتأكد من عدم أخطاء |
| 2 | رفع التعديلات إلى Git (نفس الـ repo الذي يتصل به Render) |
| 3 | Render يعيد النشر تلقائياً عند الـ push |
| 4 | Migrations تُنفَّذ عند بدء الخدمة (إن كان الإعداد الحالي يدعم ذلك) |

**ملاحظة:** إذا كانت Migrations تُشغَّل عند `npm run start:prod` (كما في `DEPLOY_FREE_RENDER.md`)، فلا حاجة لأي إعداد إضافي على Render — فقط push الكود.

---

## ٤. ترتيب التنفيذ الدقيق

### المرحلة ١: Backend (يجب أن تسبق التطبيقات)

| # | المهمة | الملفات |
|---|--------|---------|
| 1 | إنشاء Migration للأعمدة الجديدة | `backend/src/migrations/XXXXXX-AddScheduledOrderFields.ts` |
| 2 | تعديل Order Entity | `order.entity.ts` |
| 3 | تعديل CreateOrderDto | `create-order.dto.ts` |
| 4 | تعديل OrdersService | `orders.service.ts` |
| 5 | تعديل Vendor Entity + DTO | `vendor.entity.ts`, `update-vendor-profile.dto.ts` |
| 6 | تعديل VendorsService (حفظ minPreparationMinutes) | `vendors.service.ts` |
| 7 | إرجاع requestedReadyAt في استجابات الطلبات | `orders.service.ts` (getOrderDetails, getOrders) |

### المرحلة ٢: تطبيق العميل

| # | المهمة | الملفات |
|---|--------|---------|
| 1 | إنشاء Bottom Sheet أو شاشة "تفاصيل الطلب" (عنوان + وقت) | `customer_app/lib/modules/cart/presentation/widgets/checkout_details_sheet.dart` (جديد) |
| 2 | تعديل cart_screen: استدعاء الـ sheet قبل createOrder | `cart_screen.dart` |
| 3 | تعديل createOrder لتمرير requestedReadyAt و orderType | `orders_repo_impl.dart`, `orders_remote_ds.dart`, `orders_repo.dart` |
| 4 | إضافة نصوص الترجمة | `strings_ar.dart`, `strings_en.dart` |

### المرحلة ٣: تطبيق الطباخ

| # | المهمة | الملفات |
|---|--------|---------|
| 1 | إضافة حقل minPreparationMinutes في إعدادات الملف الشخصي | `edit_profile_screen.dart` أو ما يعادلها |
| 2 | عرض requestedReadyAt في قائمة الطلبات وتفاصيل الطلب | `order_tile.dart`, `order_detail_screen` |

### المرحلة ٤: Vendor Web (اختياري)

| # | المهمة | الملفات |
|---|--------|---------|
| 1 | إضافة minPreparationMinutes في الإعدادات | `vendor-web/app/settings/page.tsx` |

### المرحلة ٥: النشر على Render

| # | المهمة |
|---|--------|
| 1 | `git add` + `git commit` + `git push` |
| 2 | التحقق من Logs في Render: ظهور "Migrations completed" |
| 3 | اختبار API يدوياً أو من التطبيق |

---

## ٥. تفاصيل تقنية إضافية

### ٥.١ قيم orderType

- `ready_now`: الطلب الحالي — لا requestedReadyAt.
- `scheduled`: العميل حدد وقتاً — requestedReadyAt مطلوب.

### ٥.٢ التحقق (Backend)

- إذا `orderType === 'scheduled'` و `requestedReadyAt` فارغ → BadRequest.
- إذا `requestedReadyAt` في الماضي → BadRequest.
- (اختياري) التحقق من `minPreparationMinutes` للطباخ: إذا الطلب قبل أقل من الحد الأدنى → BadRequest أو تحذير.

### ٥.٣ التوافق مع الطلبات القديمة

- الطلبات الحالية: `orderType = null` أو `ready_now`، `requestedReadyAt = null`.
- الـ Migration يستخدم `nullable` و `default` لضمان عدم كسر البيانات القديمة.

---

## ٦. ملخص سريع

| السؤال | الجواب |
|--------|--------|
| أين نضع الميزات؟ | Bottom Sheet عند "إتمام الطلب" (العميل)؛ إعدادات في الملف الشخصي (الطباخ) |
| هل تحتاج Backend؟ | نعم — Order + Vendor + Migration |
| هل تحتاج Render؟ | نعم — push الكود، Render يعيد النشر وتشغيل Migrations تلقائياً |
| هل تؤثر على الواجهة؟ | تأثير بسيط — الافتراضي "جاهز الآن" يحافظ على السلوك الحالي |
