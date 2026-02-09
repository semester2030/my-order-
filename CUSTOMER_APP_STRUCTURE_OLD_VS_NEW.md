# تطبيق العميل: الهيكل القديم vs الهيكل الجديد

## ١. الهيكل القديم (الحالي)

### ١.١ تدفق الدخول والرئيسية

```
Splash → (إن مسجل) → navigateAfterAuth → selectAddressMap أو feed
                    → (إن غير مسجل) → welcome → phone → OTP → … → feed

بعد الدخول: المستخدم يصل مباشرة إلى Feed (فيديو المطاعم/المقدمين).
الـ Bottom Nav: [ Feed | Cart | Orders | Payment | Profile ]
الرابط الأول = Feed.
```

### ١.٢ الشاشات (Screens) — الحالية — **25 شاشة**

| # | الوحدة | الشاشة | الملاحظة |
|---|--------|--------|----------|
| 1 | auth | splash_screen | نقطة البداية |
| 2 | auth | welcome_screen | |
| 3 | auth | phone_screen | |
| 4 | auth | otp_screen | |
| 5 | auth | security_method_screen | |
| 6 | auth | create_pin_screen | |
| 7 | auth | enter_pin_screen | |
| 8 | feed | **feed_screen** | **الشاشة الرئيسية بعد الدخول** — فيديو بدون فلتر فئة |
| 9 | cart | cart_screen | |
| 10 | cart | vendor_conflict_dialog | (قد تُعدّ ويدجت وليست شاشة كاملة) |
| 11 | orders | orders_screen | |
| 12 | orders | order_tracking_screen | |
| 13 | orders | order_confirmation_screen | |
| 14 | orders | order_completed_screen | |
| 15 | orders | rating_screen | |
| 16 | payments | payment_screen | |
| 17 | payments | payment_methods_screen | |
| 18 | payments | add_card_screen | |
| 19 | addresses | select_address_map_screen | |
| 20 | addresses | addresses_list_screen | |
| 21 | vendors | vendor_screen | |
| 22 | vendors | vendor_reviews_screen | |
| 23 | profile | profile_screen | |
| 24 | profile | edit_name_screen | |
| 25 | profile | settings_screen | |
| 26 | search | search_screen | |

(حسب البحث: 25 ملفًا باسم *screen*.dart؛ vendor_conflict_dialog قد تكون شاشة أو ويدجت.)

### ١.٣ وحدات التطبيق (Modules) — الحالية

| الوحدة | البيانات / المجالات | العرض | الخدمات / الطبقة |
|--------|---------------------|--------|-------------------|
| auth | — | شاشات الدخول و PIN | — |
| feed | data (datasource, models, mappers, repo_impl), domain (entities, repo, usecases), presentation (notifier, state, screen, widgets) | feed_screen + فيديو كارد + أزرار | FeedRemoteDataSource, FeedRepository, FeedNotifier |
| cart | data, domain, presentation | cart_screen | CartRepo, CartNotifier |
| orders | data, domain, presentation | 5 شاشات طلبات | OrdersRepo, OrdersNotifier, OrderDetailsNotifier |
| payments | data, domain, presentation | 3 شاشات دفع | PaymentsRepo, PaymentNotifier |
| addresses | data, domain, presentation | 2 شاشات عناوين | AddressesRepo |
| vendors | data, domain, presentation | vendor_screen, vendor_reviews_screen | VendorsRepo |
| profile | data, domain, presentation | profile, edit_name, settings | ProfileRepo |
| search | data, domain, presentation + **vendor_search_service**, **search_service** | search_screen | SearchRepo, SearchNotifier |

### ١.٤ الملفات المرتبطة بالـ Feed (للتعديل لاحقاً)

| الطبقة | الملف | الوظيفة الحالية |
|--------|-------|------------------|
| data | feed_remote_ds.dart | getFeed(page, limit, vendorType) |
| data | feed_repo_impl.dart | يمرّر vendorType للـ datasource |
| domain | feed_repo.dart | getFeed(..., vendorType) |
| presentation | feed_notifier.dart | loadFeed() بدون معلمة فئة؛ filterByVendorType() |
| presentation | feed_screen.dart | loadFeed() عند initState بدون فئة |
| core | route_names.dart | feed, home |
| core | app_router.dart | route واحد: feed |
| core | navigation_helper.dart | context.go(RouteNames.feed) |
| core | app_bottom_navigation_bar.dart | case 0 → feed |
| core | guards.dart | redirect → feed |
| addresses | select_address_map_screen.dart | بعد الحفظ → feed |
| cart | cart_screen.dart | زر العودة/إفراغ → feed |
| orders | orders_screen.dart | إجراء → feed |
| orders | order_completed_screen.dart | زر → feed |
| orders | order_confirmation_screen.dart | زر → feed |

### ١.٥ الخدمات (Services) — الحالية

- **لا يوجد** في التطبيق طبقة باسم "Service" منفصلة عن الـ Repo/Notifier إلا:
  - **search:** `vendor_search_service.dart`, `search_service.dart` (دومين/استخدامات بحث).
  - **payments:** بوابات دفع (mada, stc, apple) داخل data/gateways.

الـ Feed يعتمد على:
- **FeedRemoteDataSource** (data)
- **FeedRepository** (domain + impl في data)
- **FeedNotifier** (presentation)

لا توجد "خدمة Feed" منفصلة؛ التعديل يكون على الـ DataSource + Repo + Notifier.

---

## ٢. الهيكل الجديد (بعد إضافة الأيقونات الأربع و Feed حسب الفئة)

### ٢.١ تدفق الدخول والرئيسية

```
Splash → (إن مسجل) → navigateAfterAuth → selectAddressMap أو شاشة الأيقونات الأربع
                    → (إن غير مسجل) → welcome → … → شاشة الأيقونات الأربع

شاشة الأيقونات الأربع (جديدة):
  [ الطبخ المنزلي ]  [ الطبخ الشعبي ]  [ المناسبات الخاصة ]  [ الشوي ]
         ↓                    ↓                    ↓                ↓
    Feed (فئة=طبخ منزلي)  Feed (فئة=شعبي)   Feed (فئة=مناسبات)  Feed (فئة=شوي)

الـ Bottom Nav: [ اكتشف/الرئيسية | Cart | Orders | Payment | Profile ]
الرابط الأول = شاشة الأيقونات الأربع (لا Feed مباشرة).
من الأيقونات → Feed مع معلمة الفئة (path أو query).
```

### ٢.٢ الشاشات — الجديدة

| الحالة | العدد | التفصيل |
|--------|-------|---------|
| **شاشات نضيفها** | **1** | **categories_screen** (أو service_categories_screen) — تعرض الأيقونات الأربع فقط. |
| **شاشات نعدّلها** | **1** | **feed_screen** — تقبل معلمة الفئة (من الـ route أو الـ state) وتمرّرها للـ Notifier عند loadFeed(). |
| **شاشات نحذفها** | **0** | لا حذف لأي شاشة. |

**المجموع بعد التحديث:** 25 + 1 = **26 شاشة** (بدون احتساب ويدجت كشاشة).

### ٢.٣ وحدات جديدة / معدّلة

| الوحدة | التغيير |
|--------|----------|
| **categories (أو home)** | **وحدة جديدة** — على الأقل: شاشة واحدة (الأيقونات الأربع) + ويدجت اختياري لأيقونة الفئة. |
| **feed** | **تعديل** — نفس الشاشة والـ Notifier مع دعم معلمة الفئة (category) من الأعلى إلى الأسفل (Screen → Notifier → Repo → DataSource). |

---

## ٣. مقارنة الملفات: ما نضيفه وما نعدّله

### ٣.١ ملفات نضيفها (جديدة)

| # | المسار المقترح | الوظيفة |
|---|----------------|---------|
| 1 | `lib/modules/categories/presentation/screens/categories_screen.dart` | شاشة الأيقونات الأربع؛ كل أيقونة تنقل إلى Feed مع الفئة (مثلاً `/feed/home_cooking`). |
| 2 | `lib/modules/categories/presentation/widgets/category_icon_card.dart` | (اختياري) ويدجت واحد قابل لإعادة الاستخدام لأيقونة الفئة. |
| 3 | `lib/core/constants/provider_categories.dart` (أو `shared/constants/`) | ثوابت الفئات الأربع: home_cooking, popular_cooking, private_events, grilling + التسميات والعناوين. |

**عدد الملفات الجديدة:** **2 إلزامي** (شاشة + ثوابت)، **1 اختياري** (ويدجت الأيقونة) → **2–3 ملفات**.

### ٣.٢ ملفات نعدّلها (بدون حذف)

| # | الملف | نوع التعديل |
|---|-------|-------------|
| 1 | `core/routing/route_names.dart` | إضافة route لشاشة الأيقونات (مثلاً `categories` أو `homeCategories`) وربما routes للـ Feed حسب الفئة (مثلاً `feedHomeCooking`, …) أو path واحد مع query. |
| 2 | `core/routing/app_router.dart` | إضافة route لـ categories_screen؛ تعديل route الـ Feed ليقبل معلمة الفئة (path param مثل `:category?` أو query). |
| 3 | `modules/auth/utils/navigation_helper.dart` | استبدال `context.go(RouteNames.feed)` بـ `context.go(RouteNames.categories)` (أو الاسم الجديد). |
| 4 | `modules/feed/data/datasources/feed_remote_ds.dart` | إضافة معلمة `category` (أو استخدام نفس vendorType بقيم الفئات) في getFeed وتمريرها كـ query param للـ API. |
| 5 | `modules/feed/domain/repositories/feed_repo.dart` | إضافة معلمة `category` إلى getFeed(). |
| 6 | `modules/feed/data/repositories/feed_repo_impl.dart` | تمرير `category` من الـ Repo إلى الـ DataSource. |
| 7 | `modules/feed/presentation/providers/feed_notifier.dart` | إضافة `_category`؛ دالة مثل `setCategory(String? category)` أو استدعاء loadFeed(category: …)； loadFeed يمرّر category للـ repository. |
| 8 | `modules/feed/presentation/screens/feed_screen.dart` | قراءة الفئة من الـ route (path أو query)؛ عند initState أو عند الدخول أول مرة استدعاء notifier.setCategory(...) ثم loadFeed(refresh: true). |
| 9 | `core/widgets/app_bottom_navigation_bar.dart` | الرابط الأول (index 0): التوجيه إلى `RouteNames.categories` بدلاً من `RouteNames.feed`؛ وربما _getIndexForRoute يدعم مسار categories. |
| 10 | `core/routing/guards.dart` | في redirectIfAuthenticated استبدال `RouteNames.feed` بـ `RouteNames.categories`. |
| 11 | `modules/addresses/presentation/screens/select_address_map_screen.dart` | بعد حفظ العنوان التوجيه إلى `RouteNames.categories` بدلاً من feed. |
| 12 | `modules/cart/presentation/screens/cart_screen.dart` | زر العودة/إفراغ العربة → التوجيه إلى `RouteNames.categories`. |
| 13 | `modules/orders/presentation/screens/orders_screen.dart` | زر الإجراء (مثلاً "تسوق مرة أخرى") → `RouteNames.categories`. |
| 14 | `modules/orders/presentation/screens/order_completed_screen.dart` | أزرار العودة/الرئيسية → `RouteNames.categories`. |
| 15 | `modules/orders/presentation/screens/order_confirmation_screen.dart` | أي توجيه للرئيسية → `RouteNames.categories`. |

**عدد الملفات المعدّلة:** **15 ملفاً**.

### ٣.٣ ملفات لا نحذفها

- لا حذف لأي شاشة أو وحدة. الـ Feed، Cart، Orders، Vendors، Auth، Profile، Search تبقى كما هي مع التعديلات المذكورة فقط حيث يلزم.

---

## ٤. الخدمات (Services) — مقارنة

| الحالة | العدد | التفصيل |
|--------|-------|---------|
| **خدمات نضيفها** | **0** | لا حاجة لخدمة جديدة؛ الفئات ثوابت وتمرير المعلمة عبر Feed فقط. |
| **خدمات نعدّلها** | **0** | لا توجد "خدمة Feed" منفصلة؛ التعديل في **DataSource + Repo + Notifier** (4 ملفات في وحدة feed). |

ملاحظة: لو اعتبرنا "الطبقة التي تتحدث مع الـ API" خدمة، فالـ **FeedRemoteDataSource** يُعدّل ليقبل `category` ويرسلها للـ Backend — وهذا محسوب ضمن "ملفات نعدّلها" أعلاه.

---

## ٥. ملخص الأرقام

| البند | العدد |
|--------|--------|
| **شاشات نضيفها** | **1** (categories_screen) |
| **شاشات نعدّلها** | **1** (feed_screen) |
| **شاشات نحذفها** | **0** |
| **ملفات نضيفها** | **2–3** (شاشة + ثوابت + ويدجت اختياري) |
| **ملفات نعدّلها** | **15** (routing, auth helper, feed chain, bottom nav, guards, addresses, cart, orders) |
| **ملفات نحذفها** | **0** |
| **خدمات نضيفها** | **0** |
| **خدمات نعدّلها** | **0** (التعديل على DataSource/Repo/Notifier فقط) |

---

## ٦. رسم تخطيطي مختصر — الهيكل القديم vs الجديد

### الهيكل القديم (تدفق الدخول والرئيسية)

```
                    ┌─────────┐
                    │ Splash  │
                    └────┬────┘
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
     (غير مسجل)              (مسجل)
              │                     │
              ▼                     ▼
     welcome → … → PIN      navigateAfterAuth
              │                     │
              │              ┌──────┴──────┐
              │              ▼             ▼
              │      selectAddressMap   feed  ◄── الرئيسية
              │              │             │
              └──────────────┴─────────────┘
                             │
              Bottom Nav: [ Feed | Cart | Orders | Payment | Profile ]
```

### الهيكل الجديد (تدفق الدخول والرئيسية)

```
                    ┌─────────┐
                    │ Splash  │
                    └────┬────┘
                         │
              ┌──────────┴──────────┐
              ▼                     ▼
     (غير مسجل)              (مسجل)
              │                     │
              ▼                     ▼
     welcome → … → PIN      navigateAfterAuth
              │                     │
              │              ┌──────┴──────┐
              │              ▼             ▼
              │      selectAddressMap   categories  ◄── الرئيسية (جديد)
              │              │             │
              │              │      ┌──────┴──────┬────────────┬────────────┐
              │              │      ▼             ▼            ▼            ▼
              │              │  طبخ منزلي   طبخ شعبي   مناسبات خاصة   شوي
              │              │      │             │            │            │
              │              │      └──────┬──────┴────────────┴────────────┘
              │              │             ▼
              │              │         feed?category=...  (نفس FeedScreen مع فلتر فئة)
              │              │             │
              └──────────────┴─────────────┘
                             │
              Bottom Nav: [ اكتشف(categories) | Cart | Orders | Payment | Profile ]
```

---

## ٧. خلاصة للإجابة المباشرة

- **كم شاشة نضيف؟** **1** (شاشة الأيقونات الأربع).
- **كم شاشة نعدّل؟** **1** (feed_screen لقراءة الفئة وتمريرها للـ Notifier).
- **كم شاشة نحذف؟** **0**.
- **كم ملف نضيف؟** **2–3** (شاشة + ثوابت فئات + ويدجت اختياري).
- **كم ملف نعدّل؟** **15** (routing، مساعد الدخول، سلسلة Feed، الـ Bottom Nav، الحراس، وعودة العناوين/العربة/الطلبات إلى الرئيسية الجديدة).
- **كم خدمة نضيف؟** **0**.
- **كم خدمة نعدّل؟** **0** (التعديل على DataSource + Repo + Notifier في وحدة feed فقط، بدون طبقة Service منفصلة).

بهذا يكون الهيكل الجديد معكوساً على القديم بوضوح، مع عدد الشاشات والملفات والخدمات المطلوب إضافتها أو تعديلها أو حذفها.
