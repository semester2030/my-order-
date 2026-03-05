# دليل إدارة الطبخ المنزلي — من الكود

## ما هو الطبخ المنزلي؟

عائلات تطبخ **في بيوتها فقط** وتعرض أطباقها في التطبيق. العميل يطلب **الوجبة فقط** — لا يطلب الطباخة. الطباخة تبقى في بيتها، والعميل يضيف للسلة ويستلم أو يُوصّل له.

---

## الفرق الجوهري بين الخدمات

| الخدمة | من يطلب؟ | ماذا يحدث؟ |
|--------|----------|------------|
| **الطبخ المنزلي** | العميل يطلب **الوجبة فقط** | الطباخة تطبخ في بيتها → العميل يضيف للسلة → توصيل/استلام |
| **الطبخ الشعبي + الشوي** | العميل يطلب **الطباخ** | الطباخ يأتي لمكان العميل ليطبخ (ذبايح، شوي، إلخ) |

---

## مسار الطبخ المنزلي (وجبات جاهزة فقط)

| المسار | الوصف | الكود | الحالة |
|-------|-------|-------|--------|
| **وجبات جاهزة** | أطباق بأسعار ثابتة → أضف للسلة → دفع | Cart → Order | ✅ يعمل |

---

## ١. مسار وجبات جاهزة (Cart → Order)

### ١.١ من جهة الطباخ (العائلة)

| الخطوة | الملف | ماذا يفعل |
|--------|--------|-----------|
| **التسجيل** | `vendor_app/lib/modules/auth/presentation/screens/register_screen.dart` | يسجل بـ `providerCategory: home_cooking` |
| **إضافة أطباق** | `vendor_app/lib/modules/menu/presentation/screens/add_menu_item_screen.dart` | اسم، وصف، سعر، صورة |
| **تفعيل الطلبات** | `vendor_app/lib/modules/profile/presentation/screens/edit_profile_screen.dart` | `isAcceptingOrders: true` |
| **إضافة فيديو** | عبر الـ menu | فيديو للأطباق يظهر في الفيد |
| **استقبال الطلبات** | `vendor_app/lib/modules/orders/presentation/screens/orders_screen.dart` | يسحب `GET /vendors/orders` — **بدون إشعار فوري** |

### ١.٢ من جهة العميل

| الخطوة | الملف | ماذا يفعل |
|--------|--------|-----------|
| **التصنيف** | `customer_app/lib/modules/categories/presentation/screens/categories_screen.dart` | يضغط "الطبخ المنزلي" |
| **الفيد** | `customer_app/lib/modules/feed/presentation/screens/feed_screen.dart` | `GET /feed?category=home_cooking` |
| **الفلترة** | `feed_screen.dart` | الأحدث | التقييم | الأقرب |
| **زر أضف للسلة** | `customer_app/lib/modules/feed/presentation/widgets/dish_overlay.dart` (سطر 218–226) | `!_isPopularCooking` → `onAddToCart` |
| **السلة** | `customer_app/lib/modules/cart/` | `addToCart` → `POST /cart/add` |
| **الدفع** | `cart_screen.dart` → `_handleCheckout` | `createOrder(defaultAddress.id)` → `POST /orders` |
| **الانتقال للدفع** | `context.push('${RouteNames.payment}/${order.id}')` | شاشة الدفع |

### ١.٣ من جهة الـ Backend

| الملف | الوظيفة |
|------|---------|
| `backend/src/modules/feed/feed.service.ts` | فلترة: `providerCategory=home_cooking`, `isActive=true`, `isAcceptingOrders=true` |
| `backend/src/modules/cart/cart.service.ts` | إضافة للسلة، قاعدة: مطبخ واحد فقط |
| `backend/src/modules/orders/orders.service.ts` | إنشاء الطلب من السلة، تفريغ السلة |

> **ملاحظة:** "اطلبي طباخة" / "احجز الطباخ" تظهر **فقط** في الطبخ الشعبي والشوي والمناسبات — **لا** في الطبخ المنزلي.

---

## ٢. ما يعمل حالياً

1. **التسجيل** → الطباخ يسجل كـ `home_cooking`
2. **إضافة أطباق** → اسم، سعر، صورة
3. **الفيد** → يظهر أطباق الطباخين المنزليين
4. **أضف للسلة** → إضافة للسلة (مع إصلاح vendorId الفارغ)
5. **الدفع** → إنشاء الطلب من السلة
6. **الطباخ يرى الطلبات** → عبر `GET /vendors/orders` (سحب يدوي)

---

## ٣. الفجوات (من الكود)

| الفجوة | الموقع | التأثير |
|--------|--------|---------|
| **لا إشعار للطباخ عند طلب جديد** | `orders.service.ts` | الطباخ لا يعرف إلا عند فتح شاشة الطلبات |
| **فلترة المسافة معطلة** | `feed.service.ts` (سطر 147–159) | يظهر كل الطباخين بغض النظر عن المسافة |

---

## ٤. ما يجب إضافته لإدارة الطبخ المنزلي بإتقان

### ٤.١ إشعار الطباخ عند طلب جديد

- **الخيار ١:** إشعار Push (FCM) عند `createOrder`
- **الخيار ٢:** إشعارات داخل التطبيق (In-App) + تحديث دوري عند فتح شاشة الطلبات

### ٤.٢ إعادة تفعيل فلترة المسافة

- في `feed.service.ts` إعادة تفعيل `isWithinDeliveryZone` بعد التأكد من بيانات `deliveryZones` للطباخين.

---

## ٥. ملخص الملفات المهمة

| الغرض | المسار |
|-------|--------|
| تسجيل الطباخ | `vendor_app/lib/modules/auth/.../register_screen.dart` |
| إضافة أطباق | `vendor_app/lib/modules/menu/.../add_menu_item_screen.dart` |
| شاشة الطلبات (الطباخ) | `vendor_app/lib/modules/orders/.../orders_screen.dart` |
| تصنيف الطبخ المنزلي | `customer_app/lib/modules/categories/.../categories_screen.dart` |
| الفيد | `customer_app/lib/modules/feed/.../feed_screen.dart` |
| زر أضف للسلة | `customer_app/lib/modules/feed/.../dish_overlay.dart` |
| السلة | `customer_app/lib/modules/cart/` |
| اطلبي طباخة (شعبي/شوي فقط) | `customer_app/lib/modules/vendors/.../request_chef_screen.dart` |
| Feed API | `backend/src/modules/feed/feed.service.ts` |
| Cart API | `backend/src/modules/cart/cart.service.ts` |
| Orders API | `backend/src/modules/orders/orders.service.ts` |
| Event Requests API | `backend/src/modules/event-requests/` |

---

## ٦. الخلاصة

- **الطبخ المنزلي:** وجبات جاهزة فقط — أضف للسلة → الطلب → الدفع. الطباخة تبقى في بيتها. لا "اطلبي طباخة".
- **الطبخ الشعبي + الشوي:** العميل يطلب الطباخ — "احجز الطباخ" — الطباخ يأتي عند العميل.

لإدارة الطبخ المنزلي بإتقان، يكفي إضافة إشعار للطباخ عند الطلبات الجديدة.
