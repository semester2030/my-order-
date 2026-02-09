# القرار المعماري وخطة التنفيذ — لوحة الإدارة (Admin)

**تاريخ القرار:** يناير ٢٠٢٥  
**المرجع:** نقاش المعمارية + ADMIN_PANEL_STRUCTURE + ADMIN_PANEL_STATUS_REPORT

---

## 0. القرار المعماري (أساس كل شيء)

| القرار | التفاصيل |
|--------|----------|
| **Admin API منفصل** | كل إجراءات الإدارة تحت **`/api/admin/*`** فقط |
| **عدم الخلط** | لا توضع Admin actions داخل `/vendors` أو `/drivers` مباشرة؛ الأدمن يقرأ ويغيّر **عبر Admin endpoints فقط** |
| **الفوائد** | RBAC واضح، Audit logging موحّد، منع تلاعب داخلي، فصل صلاحيات |

---

## القرار: مصدر حسابات الأدمن

**السؤال:** هل الأدمن يكونون في جدول مستقل أم داخل `users` مع `role = admin`؟

**القرار المعتمد: (1) جدول مستقل `admin_users`**

| الخيار | القرار | السبب المختصر |
|--------|--------|----------------|
| **(1) جدول مستقل `admin_users` + `admin_roles`** | ✅ معتمد | حدود أمان أوضح، JWT و Guards خاصة بالأدمن، صلاحيات وأدوار منفصلة عن العملاء/التجار/السائقين، أسهل للـ Audit (actor_type = admin دائماً) |
| (2) داخل `users` مع role = admin | ❌ غير معتمد | يخلط هويات المنصة (عميل/تاجر/سائق/أدمن) في جدول واحد، ويصعب فصل سياسات كلمة المرور والـ session عن باقي المستخدمين |

**النتيجة:** تنفيذ **DB schema**: `admin_users` + `admin_roles` (أو permissions حسب الحاجة)، و **JWT خاص بالإدارة** صادر عن `POST /api/admin/auth/login` فقط.

---

## المراحل الأربع (ترتيب التنفيذ)

### المرحلة 1 — Admin Auth + RBAC + Route Protection (ضرورية جداً)

**الهدف:** بدونها اللوحة مجرد UI؛ بعدها تصبح "تطبيق إدارة فعلي".

**Backend (NestJS):**
- جدولان: `admin_users`، `admin_roles` (ربط many-to-many أو role_id في admin_users).
- **POST** `/api/admin/auth/login` — يرجع JWT (يحتوي: `sub`, `role`, `permissions` اختياري).
- **POST** `/api/admin/auth/refresh` — تجديد التوكن.
- **Guards:** `AdminJwtGuard`، `RolesGuard` (التحقق من الدور قبل دخول Admin controllers).

**Frontend (Next.js):**
- تسجيل دخول حقيقي → استلام التوكن.
- تخزين التوكن: **HttpOnly cookie (مفضل)** أو localStorage كبداية.
- **Middleware:** أي طلب إلى `/dashboard/*` بدون توكن صالح → إعادة توجيه إلى `/auth/login`.

---

### المرحلة 2 — Audit Logs (قبل أي أزرار موافقة/رفض)

**الهدف:** أي تعديل إداري موثّق؛ بدون Audit تعرّض المنصة لمشاكل تشغيلية وقانونية.

**Backend:**
- جدول `audit_logs` مع حقول مقترحة:
  - `id`, `actor_type` (= admin), `actor_id`, `action` (APPROVE_VENDOR / REJECT_DRIVER / …), `entity_type`, `entity_id`, `old_value` (JSONB), `new_value` (JSONB), `reason` (اختياري), `ip` / `user_agent` (اختياري), `created_at`.
- **AuditService.log(...)** — يُستدعى داخل **أي** Admin action (موافقة، رفض، تغيير حالة، إلخ).

---

### المرحلة 3 — Dashboard حقيقي + Lists (قراءة فقط)

**الهدف:** اللوحة تعرض الواقع المباشر قبل تنفيذ أزرار التعديل.

**Backend (Read-only):**
- **GET** `/api/admin/dashboard` — طلبات اليوم، طلبات معلقة، مطاعم Pending، سائقون Pending، orders live count، payment issues count.
- **GET** `/api/admin/vendors?status=...`, **GET** `/api/admin/vendors/:id`.
- **GET** `/api/admin/drivers?status=...`, **GET** `/api/admin/drivers/:id`.
- **GET** `/api/admin/orders?status=...&dateFrom=...`, **GET** `/api/admin/orders/:id`.
- **GET** `/api/admin/payments?...`, **GET** `/api/admin/disputes?...` (إن وجد).

**Frontend:**
- استبدال الـ Mock بـ **SWR أو React Query**.
- معالجة حالات **Loading / Empty / Error**.

---

### المرحلة 4 — Actions (Approve / Reject / Suspend / Force Status) + Risk Flags

**الهدف:** الإدارة قادرة على التدخل؛ كل Action = Audit log إلزامي.

**Actions المطلوبة (MVP):**
- **Vendors:** POST approve, reject (مع reason), suspend.
- **Drivers:** POST approve, reject, suspend.
- **Orders (Ops):** POST force-status؛ لاحقاً reassign-driver، refund (بصلاحية Finance فقط).

**منع التلاعب (MVP):**
- **RBAC:** من يوافق؟ من يرجع فلوس؟
- **Audit:** كل شيء مسجل.
- **Rule Flags (قائمة بسيطة):** vendor reject rate عالي، driver cancellations عالي، order stuck أكثر من X دقيقة، payment failed webhooks — تظهر في `/risk_engine` بدون AI.

---

## أسرع مسار (أول 48 ساعة)

1. **Admin Auth** + HttpOnly cookie (أو localStorage) + Middleware حماية `/dashboard/*`.
2. **Admin Dashboard حقيقي** (حتى لو أرقام قليلة من DB).
3. **Pending approvals lists** (vendors / drivers) **read-only** من `/api/admin/*`.

**ثم:** تنفيذ Approve/Reject + استدعاء **AuditService.log** في كل إجراء.

---

## الخلاصة

| البند | الحالة |
|--------|--------|
| قرار المعمارية | ✅ Admin API تحت `/api/admin/*` فقط؛ عدم الخلط مع /vendors أو /drivers |
| قرار مصدر الأدمن | ✅ **(1) جدول مستقل `admin_users` + `admin_roles`** |
| ترتيب المراحل | 1 → Auth/RBAC، 2 → Audit، 3 → Dashboard + Lists، 4 → Actions + Risk Flags |
| أول خطوة تنفيذ | DB schema + migrations لـ admin_users و admin_roles و audit_logs؛ ثم NestJS auth/guards؛ ثم Next.js login + middleware |

هذا المستند يُستخدم كمرجع لمواصفات التنفيذ (DB schema، NestJS modules/controllers/guards، Next.js auth flow، وأول 5 endpoints).
