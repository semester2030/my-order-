# تقرير تحليلي شامل: لوحة الإدارة (Admin Panel)

**تاريخ التقرير:** يناير ٢٠٢٥  
**المرجع:** `ADMIN_PANEL_STRUCTURE.md` + هيكل المشروع الفعلي

---

## 1. ملخص تنفيذي

| الجانب | ما نُفّذ | ما تبقى | النسبة التقريبية |
|--------|----------|---------|-------------------|
| **فرونت إند (Admin Panel)** | واجهات كاملة + ثيم موحد + تفاعل | ربط API + مصادقة حقيقية + بيانات حية | **~75%** واجهات / **~0%** بيانات حية |
| **باك إند (Backend)** | وحدة Admin أساسية + endpoint واحد | كل endpoints الإدارة + Audit + Guards أدوار | **~5%** من متطلبات الإدارة |

**الدليل المختصر:** الفرونت إند يعمل على `localhost:3002` ببيانات وهمية (Mock). الباك إند فيه فقط `GET /admin/dashboard` يرجع `{ message: 'Admin dashboard' }` ولا يوجد ربط بين الاثنين.

---

## 2. ما نُفّذ بالضبط (مع الأدلة)

### 2.1 فرونت إند — لوحة الإدارة (`admin_panel/`)

#### أ) الهيكل والمسارات (مطابق لـ ADMIN_PANEL_STRUCTURE)

| المسار | الملف | الدليل |
|--------|--------|--------|
| `/` | `app/page.tsx` | `redirect('/dashboard')` |
| `/auth/login` | `app/auth/login/page.tsx` | صفحة تسجيل دخول (ثيم موحد، زر تجربة للوحة) |
| `/dashboard` | `app/(dashboard)/dashboard/page.tsx` | لوحة تحكم: StatCards + آخر الطلبات + طلبات بانتظار الموافقة |
| `/vendors` | `app/(dashboard)/vendors/page.tsx` | قائمة مطاعم (جدول + Badge + رابط تفاصيل) |
| `/vendors/applications` | `app/(dashboard)/vendors/applications/page.tsx` | طلبات تسجيل مطاعم (جدول + أزرار موافقة/رفض/تفاصيل) |
| `/vendors/[id]` | `app/(dashboard)/vendors/[id]/page.tsx` | تفاصيل مطعم (CardBody + dl + إجراءات) |
| `/drivers` | `app/(dashboard)/drivers/page.tsx` | قائمة سائقين |
| `/drivers/applications` | `app/(dashboard)/drivers/applications/page.tsx` | طلبات تسجيل سائقين |
| `/drivers/[id]` | `app/(dashboard)/drivers/[id]/page.tsx` | تفاصيل سائق |
| `/orders` | `app/(dashboard)/orders/page.tsx` | قائمة طلبات |
| `/orders/live` | `app/(dashboard)/orders/live/page.tsx` | طلبات حية |
| `/orders/[id]` | `app/(dashboard)/orders/[id]/page.tsx` | تفاصيل طلب |
| `/payments` | `app/(dashboard)/payments/page.tsx` | مدفوعات + StatCards + جدول |
| `/payments/reconciliation` | `app/(dashboard)/payments/reconciliation/page.tsx` | مصالحة |
| `/disputes` | `app/(dashboard)/disputes/page.tsx` | قائمة شكاوى |
| `/disputes/[id]` | `app/(dashboard)/disputes/[id]/page.tsx` | تفاصيل شكوى |
| `/monitoring` | `app/(dashboard)/monitoring/page.tsx` | مراقبة (StatCards + حالة خدمات + تنبيهات) |
| `/risk_engine` | `app/(dashboard)/risk_engine/page.tsx` | تنبيهات مخاطر |
| `/settings` | `app/(dashboard)/settings/page.tsx` | إعدادات (عام، رسوم، أدوار) |
| `/settings/roles` | `app/(dashboard)/settings/roles/page.tsx` | جدول أدوار |
| `/audit_logs` | `app/(dashboard)/audit_logs/page.tsx` | سجل تدقيق (جدول) |

**الإثبات:** وجود الملفات أعلاه تحت `admin_panel/app/` وكل صفحة تعرض محتوى منظم (PageHeader, Card, Table أو CardBody).

#### ب) الثيم الموحد (مع تطبيقات العميل وويب المطاعم)

| العنصر | الملف | الدليل |
|--------|--------|--------|
| ألوان Primary / Accent / Secondary | `tailwind.config.ts` | `primary: '#FF6B35'`, `accent: '#FFD700'`, `secondary: '#1A1A1A'` |
| Surface, Text, Border, Semantic | `tailwind.config.ts` | `surface`, `text.primary/secondary`, `success`, `warning`, `error`, `info` |
| خلفية دافئة | `app/globals.css` | `bg-surface-warmBg` في body |
| انتقالات | `app/globals.css` | `.transition-smooth`, `.focus-ring` |

**الإثبات:** لا استخدام لـ `admin-*` أو ألوان مختلفة عن الثيم؛ الصفحات تستخدم `text-text-primary`, `border-border`, `primary`, إلخ.

#### ج) المكونات المشتركة (UI)

| المكون | الملف | الاستخدام |
|--------|--------|-----------|
| PageHeader | `components/ui/PageHeader.tsx` | عنوان + وصف + أزرار اختيارية |
| Card, CardHeader, CardBody | `components/ui/Card.tsx` | بطاقات مع رأس وجسم |
| StatCard | `components/ui/StatCard.tsx` | إحصائيات + أيقونة + trend |
| Table, TableHeader, TableBody, TableRow, TableHead, TableCell | `components/ui/Table.tsx` | جداول موحدة |
| Button | `components/ui/Button.tsx` | primary, secondary, ghost, outline, danger |
| Badge | `components/ui/Badge.tsx` | default, success, warning, danger, info, primary |
| EmptyState | `components/ui/EmptyState.tsx` | حالة عدم وجود بيانات |
| Sidebar | `components/layout/Sidebar.tsx` | تنقل + أيقونات (lucide-react) + تمييز الرابط النشط |
| TopBar | `components/layout/TopBar.tsx` | شريط علوي |
| PageContainer | `components/layout/PageContainer.tsx` | غلاف المحتوى |
| cn() | `lib/cn.ts` | دمج كلاسات (clsx + tailwind-merge) |

**الإثبات:** استيراد من `@/components/ui/*` و `@/components/layout/*` في الصفحات؛ `components/ui/index.ts` يصدر المكونات.

#### د) البيانات الحالية

- **كل الجداول والقوائم والتفاصيل تعتمد على بيانات ثابتة (Mock)** داخل كل صفحة (مصفوفات مثل `applications`, `vendors`, `orders`).
- **لا يوجد:** استدعاء `fetch` أو `axios` أو متغير بيئة `NEXT_PUBLIC_API_URL` في مصدر التطبيق (فقط في node_modules/next).

---

### 2.2 باك إند — وحدة الإدارة (`backend/src/modules/admin/`)

| الملف | المحتوى | الدليل |
|--------|----------|--------|
| `admin.module.ts` | تسجيل AdminModule | موجود في `app.module.ts` |
| `admin.controller.ts` | `GET /admin/dashboard` مع JwtAuthGuard | يرجع من AdminService |
| `admin.service.ts` | `getDashboard()` يرجع `{ message: 'Admin dashboard' }` | لا استعلام DB ولا منطق إدارة |

**الإثبات:** قراءة الملفات أعلاه تظهر endpoint واحد وخدمة stub فقط.

---

## 3. ما تبقى بالضبط (مع الأولويات)

### 3.1 فرونت إند — المتبقي

| البند | الأولوية | التفصيل | الدليل على النقص |
|--------|----------|----------|-------------------|
| ربط API الباك إند | عالية جداً | إعداد base URL (مثل `.env.local`: `NEXT_PUBLIC_API_URL`)، عميل HTTP (axios أو fetch)، استدعاء APIs من الصفحات أو من طبقة services | عدم وجود أي استدعاء API في `app/` أو `components/` أو `lib/` |
| مصادقة حقيقية (Login) | عالية جداً | تسجيل دخول أدمن → JWT من الباك إند، حفظ التوكن، إرساله في الهيدر، حماية مسارات `/dashboard/*` (middleware أو HOC) | `auth/login/page.tsx` لا يرسل طلباً ولا يخزن توكن؛ زر "تجربة" يوجه للوحة بدون تحقق |
| جلب بيانات حية للوحة التحكم | عالية | استبدال Mock في dashboard بـ `GET /admin/dashboard` (أو endpoints منفصلة للإحصائيات والطلبات الأخيرة) | `dashboard/page.tsx` يستخدم مصفوفات ثابتة فقط |
| جلب قوائم حية (مطاعم، سائقون، طلبات، مدفوعات، شكاوى، سجل تدقيق) | عالية | استبدال البيانات الوهمية في كل صفحة قائمة بـ GET من الباك إند + معالجة loading/error | كل صفحات القوائم تحتوي على `const x = [ ... ]` ثابت |
| تفاصيل حية (vendors/[id], drivers/[id], orders/[id], disputes/[id]) | عالية | GET by id من الباك إند حسب الكيان | الصفحات تعرض قيماً ثابتة (مثل "مطعم الشرق") |
| تنفيذ إجراءات (موافقة/رفض/إيقاف/تعليق) | عالية | أزرار تطلق POST/PATCH للباك إند ثم تحديث القائمة أو إعادة التوجيه | الأزرار حالياً بدون `onClick` أو ربط API |
| فلترة وبحث (حسب المواصفات) | متوسطة | فلاتر حسب الحالة/التاريخ في قوائم المطاعم، السائقين، الطلبات | لا توجد حقول فلترة أو استعلام query params |
| إدارة الأدوار (واجهة صلاحيات) | متوسطة | واجهة لربط الأدوار والصلاحيات إن وُجدت في الباك إند | `settings/roles` يعرض جدولاً ثابتاً فقط |
| تحسينات تجربة (تحميل، أخطاء، تفريغ) | متوسطة | استخدام EmptyState عند عدم وجود بيانات، رسائل خطأ من API | لا معالجة لحالات loading/error من شبكة |

### 3.2 باك إند — المتبقي

| البند | الأولوية | التفصيل | الدليل على النقص |
|--------|----------|----------|-------------------|
| مصادقة أدمن وأدوار | عالية جداً | نوع مستخدم/جدول أدمن + أدوار (مثل Super Admin, Ops, Finance, Support, Quality) + Guard يتحقق من الدور | Auth الحالي للعميل/التاجر/السائق؛ لا endpoint تسجيل دخول أدمن ولا تحقق دور |
| Audit Logs | عالية جداً | جدول `audit_logs` (user_id, action, entity, entity_id, old_value, new_value, reason, created_at) + كتابة تلقائية عند الموافقة/الرفض/التعديل | لا جدول ولا خدمة audit في المشروع |
| Dashboard حقيقي | عالية | إحصائيات (طلبات اليوم، مطاعم نشطة، سائقون، شكاوى) + آخر الطلبات من DB | AdminService.getDashboard() يرجع رسالة ثابتة فقط |
| قوائم للادمن (مطاعم، سائقون، طلبات، مدفوعات، شكاوى) | عالية | GET مع فلترة وحماية بأدوار (مثلاً فقط Ops/Super يرون الموافقات) | لا endpoints مثل GET /admin/vendors, /admin/drivers, /admin/orders... |
| تفاصيل للادمن (مطعم/سائق/طلب/شكوى) | عالية | GET by id مع صلاحيات | لا GET /admin/vendors/:id أو ما يماثله |
| موافقة/رفض مطاعم (طلبات التسجيل) | عالية | قائمة طلبات تسجيل + approve/reject/needs_changes مع سبب + audit | قد تكون جزء من Vendors؛ تحتاج ربط صريح بـ audit والصلاحيات |
| موافقة/رفض سائقين | عالية | نفس الفكرة مع suspend/probation وaudit | موجود جزئياً في Drivers؛ يحتاج توحيد مع audit والأدوار |
| إدارة طلبات (إلغاء، إعادة تعيين سائق) | عالية | PATCH من الأدمن حسب الصلاحية | لا endpoints إدارة طلبات للادمن |
| مصالحة مدفوعات للادمن | متوسطة | تقارير/مصالحة جاهزة للـ Finance | Payments موجود؛ يحتاج endpoints تقارير ومصالحة للادمن |
| مراقبة (Monitoring) | متوسطة | قراءة إحصائيات وتأخير ورفض وإلغاء (بدون تعديل) | لا تجميع جاهز لهذه المقاييس لـ GET /admin/monitoring |
| Risk Engine (قواعد) | متوسطة | قواعد بسيطة (flag/suspend/review) وربطها بـ audit | لا وحدة risk أو قواعد في الباك إند |
| إعدادات المنصة (ساعات، مناطق، رسوم) | متوسطة | CRUD إعدادات عامة مع صلاحيات | لا جدول/endpoints إعدادات أدمن |

---

## 4. النسب والأولويات (تقديرية)

### فرونت إند (Admin Panel)

| المجال | منفذ | متبقي | نسبة التنفيذ |
|--------|------|--------|---------------|
| هيكل المسارات والصفحات | كامل | — | 100% |
| الثيم والمكونات الموحدة | كامل | — | 100% |
| واجهات القوائم والتفاصيل (UI فقط) | كامل | — | 100% |
| ربط API وجلب بيانات حية | — | كامل | 0% |
| مصادقة وحماية مسارات | — | كامل | 0% |
| إجراءات (موافقة، رفض، إلخ) | — | كامل | 0% |
| فلترة وبحث | — | كامل | 0% |

**نسبة إجمالية الفرونت إند:** تقريباً **75%** واجهات جاهزة، **25%** ربط بيانات ومصادقة وإجراءات.

### باك إند

| المجال | منفذ | متبقي | نسبة التنفيذ |
|--------|------|--------|---------------|
| وحدة Admin (هيكل) | موجودة | — | 100% |
| Dashboard API حقيقي | — | كامل | 0% |
| مصادقة أدمن + أدوار | — | كامل | 0% |
| Audit Logs | — | كامل | 0% |
| Endpoints قوائم (vendors, drivers, orders, payments, disputes) | — | كامل | 0% |
| Endpoints تفاصيل وإجراءات (موافقة/رفض/إلخ) | — | كامل | 0% |
| Monitoring / Risk / إعدادات | — | كامل | 0% |

**نسبة إجمالية الباك إند للإدارة:** تقريباً **5%** (endpoint واحد stub)، **95%** متبقي.

---

## 5. ملاحظات وتحسينات مقترحة

### 5.1 ملاحظات

1. **لوحة الإدارة تعمل بشكل مستقل على المنفذ 3002** بدون اتصال بالباك إند؛ مناسب للتطوير والتصميم، وغير كافٍ للتشغيل الفعلي.
2. **الثيم موحد** مع تطبيقات العميل وويب المطاعم (Primary Sunset Orange, Accent Gold, Secondary Charcoal) — مناسب للعلامة الموحدة.
3. **لا يوجد ملف `.env` أو `.env.local`** في admin_panel لربط عنوان الـ API (يُفضّل إضافته عند بدء الربط).
4. **الباك إند** يخدم تطبيقات العميل والسائق والتاجر؛ وحدة Admin الحالية لا تستخدم أيًا من وحدات Vendors/Drivers/Orders بشكل منظم للقراءة أو الموافقات.
5. **الأدوار والصلاحيات** مُعرّفة في المستند (ADMIN_PANEL_STRUCTURE) ولم تُنفّذ في الباك إند ولا في الفرونت (إخفاء عناصر حسب الدور).

### 5.2 تحسينات مقترحة (فرونت إند)

1. **إضافة طبقة API موحدة:** إنشاء `lib/api/client.ts` (أو `services/api.ts`) يستخدم `NEXT_PUBLIC_API_URL` ويرسل التوكن في الهيدر، واستخدامها من جميع الصفحات.
2. **حماية المسارات:** Middleware في Next.js يتحقق من وجود JWT ويوجه غير المسجلين إلى `/auth/login`.
3. **حالات التحميل والأخطاء:** استخدام React Query أو SWR مع عرض loading وEmptyState ورسائل خطأ من الـ API.
4. **إخفاء حسب الدور:** بعد استلام دور المستخدم (من JWT أو من endpoint مثل `/me`)، إخفاء عناصر القائمة والأزرار التي لا يسمح بها دوره.

### 5.3 تحسينات مقترحة (باك إند)

1. **مصادقة الأدمن:** إما توسيع User/Entity بدور `admin` أو جدول `admin_users` مع علاقة بأدوار، وإصدار JWT يحتوي على الدور.
2. **جدول Audit:** إنشاء migration لـ `audit_logs` وخدمة تكتب فيه عند أي موافقة/رفض/تعديل من الأدمن.
3. **Guards للأدوار:** Guard يتحقق من وجود دور أدمن والصلاحية المطلوبة قبل استدعاء Admin controllers أو endpoints الموافقات.
4. **تقسيم واضح:** تجميع كل endpoints الإدارة تحت بادئة مثل `/admin` (قوائم، تفاصيل، إجراءات) مع إعادة استخدام خدمات Vendors/Drivers/Orders بدل تكرار المنطق.

---

## 6. الخلاصة

| العنصر | الحالة | الإثبات |
|--------|--------|---------|
| **فرونت إند: واجهات وصفحات وثيم** | منفذ | 19+ صفحة + مكونات + tailwind + ثيم موحد |
| **فرونت إند: بيانات حية وربط API** | غير منفذ | لا fetch/axios ولا .env API في المصدر |
| **فرونت إند: مصادقة حقيقية** | غير منفذ | Login وهمي وعدم حماية مسارات |
| **باك إند: وحدة Admin** | منفذ جزئياً | GET /admin/dashboard فقط (stub) |
| **باك إند: مصادقة أدمن + أدوار + Audit + قوائم وإجراءات** | غير منفذ | لا جداول/خدمات/endpoints للإدارة |

**الخطوة التالية المقترحة:** البدء بربط الفرونت إند بالباك إند عبر (1) مصادقة أدمن في الباك إند وإصدار JWT، (2) إعداد `NEXT_PUBLIC_API_URL` وعميل API في الفرونت إند، (3) تنفيذ Dashboard API حقيقي وجلب بيانات لوحة التحكم من DB، ثم توسيع القوائم والتفاصيل والإجراءات وAudit حسب الأولويات أعلاه.
