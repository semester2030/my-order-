# خطة تنفيذ النواقص — لوحة الإدارة (حسب الأهمية)

**المرجع:** ADMIN_ARCHITECTURE_DECISION + ADMIN_PANEL_STATUS_REPORT  
**القرار:** Admin API تحت `/api/admin/*` فقط — حسابات الأدمن في جدول مستقل `admin_users` + `admin_roles`.

---

## ترتيب التنفيذ (من الأهم إلى الأقل أهمية)

| # | المرحلة | الهدف | أولوية |
|---|---------|--------|--------|
| 1 | Auth + RBAC + حماية المسارات | لوحة = تطبيق إدارة فعلي وليس UI فقط | حرجة |
| 2 | Audit Logs | توثيق كل تعديل إداري قبل أي أزرار موافقة/رفض | حرجة |
| 3 | Dashboard حقيقي + قوائم (قراءة فقط) | اللوحة تعرض الواقع المباشر | عالية جداً |
| 4 | إجراءات (موافقة/رفض/إيقاف) + Risk Flags | الإدارة قادرة على التدخل | عالية |
| 5 | فلترة وبحث + تحسينات UX | تحسين تجربة الاستخدام | متوسطة |
| 6 | إعدادات المنصة + مراقبة متقدمة | توسيع قدرات الإدارة | منخفضة (لاحقاً) |

---

## المرحلة 1 — Auth + RBAC + Route Protection (ننفذها أولاً)

**بدونها:** اللوحة مجرد واجهة؛ **بعدها:** تصبح تطبيق إدارة فعلي.

### 1.1 باك إند (NestJS)

| الترتيب | المطلوب | التفصيل |
|---------|---------|---------|
| 1.1.1 | جداول DB | **admin_roles** (id, name, slug مثل super_admin/ops/finance/support/quality، created_at). **admin_users** (id, email, password_hash, role_id FK, name, is_active, created_at, updated_at). |
| 1.1.2 | Migration | إنشاء migration لـ admin_roles و admin_users؛ إدراج أدوار افتراضية؛ (اختياري) مستخدم super_admin تجريبي. |
| 1.1.3 | Admin Auth Module | **POST /api/admin/auth/login** (body: email, password) — يتحقق من admin_users، يصدر JWT يحتوي (sub = admin_user.id, role = slug, type = 'admin'). **POST /api/admin/auth/refresh** (يرسل refresh token أو يعيد إصدار من التوكن الحالي حسب تصميمك). |
| 1.1.4 | JWT Strategy للأدمن | استراتيجية منفصلة للـ Admin (تتحقق من type = 'admin' أو issuer خاص بالأدمن) حتى لا يختلط توكن العميل/التاجر مع الأدمن. |
| 1.1.5 | Guards | **AdminJwtGuard**: يتحقق من JWT صالح ونوعه أدمن. **RolesGuard**: يتحقق من أن role المستخدم ضمن الأدوار المسموح بها للـ endpoint (يُستدعى بعد AdminJwtGuard). |
| 1.1.6 | تأمين مسارات Admin | تطبيق AdminJwtGuard (و RolesGuard حيث يلزم) على كل controller تحت `/api/admin/*` (ما عدا login/refresh). |

### 1.2 فرونت إند (Next.js — admin_panel)

| الترتيب | المطلوب | التفصيل |
|---------|---------|---------|
| 1.2.1 | متغير بيئة | **NEXT_PUBLIC_API_URL** (مثل `http://localhost:3001`) في `.env.local`. |
| 1.2.2 | عميل API | إنشاء **lib/api/client.ts** (أو services/api.ts): axios/fetch مع baseURL من env، وإرفاق التوكن في هيدر Authorization عند وجوده (من cookie أو من مكان التخزين). |
| 1.2.3 | تسجيل دخول حقيقي | في **app/auth/login/page.tsx**: نموذج (email + password) يرسل POST إلى `/api/admin/auth/login`، يستقبل JWT، يخزنه (HttpOnly cookie مُفضّل، أو localStorage كبداية). ثم إعادة توجيه إلى `/dashboard`. |
| 1.2.4 | تخزين التوكن | إما: (أ) Backend يرسل Set-Cookie (HttpOnly) عند login فالمتصفح يخزن تلقائياً، أو (ب) Frontend يخزن في localStorage ويضعه في الهيدر في كل طلب. |
| 1.2.5 | Middleware حماية المسارات | **middleware.ts** في جذر admin_panel: إذا الطلب إلى `/dashboard` أو `/dashboard/*` (أو كل المسارات ما عدا `/auth/login` و assets) وليس هناك توكن صالح → redirect إلى `/auth/login`. التحقق من التوكن إما عبر cookie أو عبر طلب GET إلى backend (مثل /api/admin/me) إن وُجد. |

**معيار الإنجاز:** أدمن يسجّل دخولاً بحساب من DB، وبدون تسجيل دخول لا يستطيع فتح `/dashboard`.

---

## المرحلة 2 — Audit Logs (قبل أي أزرار موافقة/رفض)

**الهدف:** أي تعديل إداري موثّق؛ بدونها تعرّض المنصة لمشاكل تشغيلية وقانونية.

### 2.1 باك إند فقط

| الترتيب | المطلوب | التفصيل |
|---------|---------|---------|
| 2.1.1 | جدول audit_logs | **audit_logs**: id, actor_type ('admin'), actor_id (admin_user.id), action (مثل APPROVE_VENDOR, REJECT_DRIVER, FORCE_ORDER_STATUS), entity_type (vendor/driver/order/payment), entity_id, old_value (JSONB), new_value (JSONB), reason (nullable), ip (nullable), user_agent (nullable), created_at. |
| 2.1.2 | Migration | إنشاء migration لـ audit_logs. |
| 2.1.3 | AuditService | **AuditService.log({ actorId, action, entityType, entityId, oldValue, newValue, reason?, req? })** — يكتب سطراً واحداً في audit_logs. يُستدعى من أي Admin action لاحقاً (موافقة، رفض، تغيير حالة، إلخ). |
| 2.1.4 | (اختياري) GET للواجهة | **GET /api/admin/audit-logs?page&limit&action&entityType** — لصفحة سجل التدقيق في اللوحة (يمكن تأجيله للمرحلة 3). |

**معيار الإنجاز:** وجود جدول وخدمة جاهزة؛ أي كود يضاف لاحقاً لـ approve/reject يستدعي AuditService.log.

---

## المرحلة 3 — Dashboard حقيقي + قوائم (قراءة فقط)

**الهدف:** اللوحة تعرض بيانات حية قبل تنفيذ أزرار التعديل.

### 3.1 باك إند — Endpoints (Read-only)

| الترتيب | المطلوب | التفصيل |
|---------|---------|---------|
| 3.1.1 | GET /api/admin/dashboard | يرجع: ordersToday, ordersPending, vendorsPendingCount, driversPendingCount, ordersLiveCount, paymentIssuesCount (أو ما يتوفر من إحصائيات من جداولك الحالية). كلها من استعلامات على orders, vendors, drivers, payments. |
| 3.1.2 | GET /api/admin/vendors | query: status, page, limit. يرجع قائمة مطاعم (من vendor entity) مع الحالة. |
| 3.1.3 | GET /api/admin/vendors/:id | تفاصيل مطعم واحد. |
| 3.1.4 | GET /api/admin/drivers | query: status, page, limit. قائمة سائقين. |
| 3.1.5 | GET /api/admin/drivers/:id | تفاصيل سائق واحد. |
| 3.1.6 | GET /api/admin/orders | query: status, dateFrom, dateTo, page, limit. قائمة طلبات. |
| 3.1.7 | GET /api/admin/orders/:id | تفاصيل طلب واحد. |
| 3.1.8 | GET /api/admin/payments | query: page, limit (وما يلزم). قائمة معاملات. |
| 3.1.9 | GET /api/admin/disputes | إن وُجد جدول/كيان disputes؛ وإلا يمكن تأجيله. |
| 3.1.10 | GET /api/admin/audit-logs | (إن لم يُنفذ في المرحلة 2) للصفحة سجل التدقيق. |

كل الـ GET فوق محمية بـ AdminJwtGuard (و RolesGuard إن فرضت صلاحيات مختلفة لكل دور).

### 3.2 فرونت إند — ربط البيانات الحية

| الترتيب | المطلوب | التفصيل |
|---------|---------|---------|
| 3.2.1 | استخدام عميل API | كل الطلبات إلى `/api/admin/*` تمر عبر **lib/api/client** مع إرفاق التوكن. |
| 3.2.2 | SWR أو React Query | تثبيت **SWR** (أو React Query) واستخدامه في الصفحات لجلب البيانات بدل الـ Mock. |
| 3.2.3 | Dashboard | **dashboard/page.tsx**: استدعاء GET /api/admin/dashboard، عرض الإحصائيات وآخر الطلبات (وطلبات بانتظار الموافقة إن وُجدت في الـ response). |
| 3.2.4 | صفحات القوائم | استبدال مصفوفات Mock في (vendors, vendors/applications, drivers, drivers/applications, orders, orders/live, payments, disputes, audit_logs) بـ useSWR أو useQuery على الـ endpoint المناسب. |
| 3.2.5 | صفحات التفاصيل | vendors/[id], drivers/[id], orders/[id], disputes/[id]: جلب البيانات بـ GET by id من API وعرضها. |
| 3.2.6 | Loading / Empty / Error | عرض حالة تحميل، وEmptyState عند عدم وجود بيانات، ورسالة خطأ عند فشل الطلب. |

**معيار الإنجاز:** لوحة التحكم وجميع القوائم والتفاصيل تعرض بيانات حية من DB عبر `/api/admin/*`.

---

## المرحلة 4 — إجراءات (موافقة / رفض / إيقاف) + Risk Flags

**الهدف:** الإدارة قادرة على التدخل؛ كل إجراء = استدعاء AuditService.log إلزامي.

### 4.1 باك إند — Actions

| الترتيب | المطلوب | التفصيل |
|---------|---------|---------|
| 4.1.1 | Vendors | **POST /api/admin/vendors/:id/approve** — يغيّر حالة المطعم، يستدعي AuditService.log. **POST /api/admin/vendors/:id/reject** (body: reason) — نفس الشيء + reason في الـ audit. **POST /api/admin/vendors/:id/suspend** إن لزم. |
| 4.1.2 | Drivers | **POST /api/admin/drivers/:id/approve**, **reject** (مع reason), **suspend** — مع AuditService.log في كل منها. |
| 4.1.3 | Orders | **POST /api/admin/orders/:id/force-status** (body: status) — لتعديل حالة الطلب من الأدمن؛ مع audit. (لاحقاً: reassign-driver، refund مع صلاحية Finance.) |
| 4.1.4 | RolesGuard | ربط الصلاحيات: مثلاً فقط super_admin و ops يوافقون على مطاعم/سائقين؛ فقط finance يفعّل refund؛ إلخ. |

### 4.2 فرونت إند — أزرار الإجراءات

| الترتيب | المطلوب | التفصيل |
|---------|---------|---------|
| 4.2.1 | أزرار موافقة/رفض/إيقاف | في vendors/applications و vendors/[id] و drivers/applications و drivers/[id]: عند الضغط استدعاء POST المناسب، ثم إما إعادة جلب القائمة (revalidate) أو الانتقال للقائمة. عند الرفض: فتح modal أو حقل لإدخال reason وإرساله. |
| 4.2.2 | أزرار الطلبات | في orders/[id]: زر تغيير الحالة (force-status) مع اختيار الحالة ثم POST. |
| 4.2.3 | رسائل نجاح/خطأ | بعد كل إجراء عرض toast أو رسالة نجاح/خطأ من الـ API. |

### 4.3 Risk Engine (MVP بسيط)

| الترتيب | المطلوب | التفصيل |
|---------|---------|---------|
| 4.3.1 | قواعد بسيطة (اختياري في نفس المرحلة) | في الخدمة: حساب vendor reject rate، driver cancellations، orders stuck أكثر من X دقيقة؛ تخزين كـ "flags" أو إرجاعها من GET /api/admin/risk-flags. |
| 4.3.2 | GET /api/admin/risk-flags | يرجع قائمة flags للعرض في صفحة risk_engine. |
| 4.3.3 | صفحة risk_engine | استبدال Mock بقائمة من API. |

**معيار الإنجاز:** موافقة/رفض/إيقاف تعمل من الواجهة ومسجّلة في audit_logs؛ صفحة risk_engine تعرض قائمة flags من الباك إند (حتى لو بسيطة).

---

## المرحلة 5 — فلترة وبحث + تحسينات UX (أولوية متوسطة)

| البند | أين | التفصيل |
|--------|-----|---------|
| فلترة القوائم | Backend + Frontend | إضافة query params (status, dateFrom, dateTo, search) لـ GET vendors, drivers, orders واستخدامها في الواجهة (dropdowns أو حقول تاريخ). |
| بحث (اختياري) | Backend + Frontend | بحث بالاسم أو المعرف في قوائم المطاعم/السائقين إن احتجت. |
| EmptyState و Loading | Frontend | التأكد من استخدام EmptyState ووضع loading في كل الصفحات التي تجلب بيانات. |
| Pagination | Backend + Frontend | إرجاع total/count مع القوائم وعرض pagination في الجداول. |

---

## المرحلة 6 — إعدادات المنصة + مراقبة متقدمة (لاحقاً)

| البند | أولوية | ملاحظة |
|--------|--------|--------|
| إعدادات عامة (ساعات، مناطق، رسوم) | منخفضة | يحتاج جدول platform_settings و endpoints CRUD محمية بصلاحية super_admin. |
| مراقبة متقدمة (monitoring) | منخفضة | GET /api/admin/monitoring مع مقاييس إضافية (تأخير، نسب رفض/إلغاء). |
| إدارة الأدوار من الواجهة | منخفضة | واجهة لإدارة admin_roles وصلاحياتها إن أردت ديناميكية كاملة. |

---

## ملخص: ماذا ننفذ الآن (بالترتيب)

1. **المرحلة 1 بالكامل:** Auth + RBAC + حماية المسارات (DB admin_users/admin_roles، login/refresh، Guards، ثم Frontend: login حقيقي، تخزين توكن، Middleware).
2. **المرحلة 2 بالكامل:** جدول audit_logs + AuditService.
3. **المرحلة 3 بالكامل:** GET dashboard + GET vendors/drivers/orders (وقوائم أخرى) + ربط الفرونت إند (SWR/React Query، إزالة Mock، Loading/Empty/Error).
4. **المرحلة 4:** إجراءات موافقة/رفض/إيقاف مع استدعاء Audit في كل إجراء + ربط الأزرار في الواجهة؛ ثم Risk Flags بسيطة إن أمكن.

بهذا الترتيب تصبح اللوحة: (1) محمية، (2) موثّقة، (3) تعرض بيانات حية، (4) قادرة على التدخل. بعدها يمكن تنفيذ المرحلتين 5 و 6 حسب الحاجة.
