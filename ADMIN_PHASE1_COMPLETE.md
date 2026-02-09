# إكمال المرحلة 1 — Auth + RBAC + حماية المسارات

**تاريخ الإكمال:** يناير ٢٠٢٥  
**المرجع:** ADMIN_IMPLEMENTATION_PLAN — المرحلة 1

---

## ما تم تنفيذه

### باك إند (NestJS)

| البند | الملف / المسار |
|--------|-----------------|
| جداول DB | `admin_roles`, `admin_users` (entities + migration) |
| Migration | `1738040000000-CreateAdminRolesAndUsers.ts` — إنشاء الجداول + إدراج أدوار افتراضية (super_admin, ops, finance, support, quality) |
| Admin Auth | **POST** `/api/admin/auth/login` (email, password) — يرجع JWT + admin info |
| | **POST** `/api/admin/auth/refresh` — تجديد التوكن (Bearer مطلوب) |
| | **GET** `/api/admin/auth/me` — التحقق من التوكن وإرجاع بيانات الأدمن |
| JWT للأدمن | `AdminJwtStrategy` — يتحقق من `type = 'admin'` في الـ payload |
| Guards | `AdminJwtGuard` (AuthGuard 'admin-jwt'), `RolesGuard` + `@Roles(...)` |
| حماية مسارات Admin | كل controller تحت `/api/admin` (ما عدا login) محمي بـ `AdminJwtGuard`؛ `AdminController` (dashboard) يستخدم `AdminJwtGuard` |

### فرونت إند (Next.js — admin_panel)

| البند | الملف / المسار |
|--------|-----------------|
| متغير بيئة | `.env.local.example` — `NEXT_PUBLIC_API_URL` |
| عميل API | `lib/api/client.ts` — adminLogin, adminRefresh, adminMe, setAdminToken, clearAdminToken, getAuthHeaders |
| تخزين التوكن | localStorage + cookie `admin_token` (للمiddleware) |
| تسجيل دخول حقيقي | `app/auth/login/page.tsx` — نموذج email + password، POST إلى `/api/admin/auth/login`، تخزين التوكن، redirect إلى `from` أو `/dashboard` |
| Middleware | `middleware.ts` — حماية `/dashboard` و `/dashboard/*`؛ بدون توكن → redirect إلى `/auth/login`؛ مع توكن على `/auth/login` → redirect إلى `/dashboard` |

---

## تشغيل المرحلة 1

**ملاحظة:** لا حاجة لـ `migration:run` في بيئة التطوير. الباك إند يستخدم `synchronize: true` في development فيُنشئ جداول `admin_roles` و `admin_users` تلقائياً عند أول تشغيل.

### 1. الباك إند

```bash
cd backend
# إنشاء .env إذا لم يكن موجوداً (JWT_SECRET، DATABASE_*)
npm run start:dev
```

انتظر حتى يبدأ السيرفر (ليُنشئ TypeORM الجداول تلقائياً). ثم في **طرفية أخرى** أنشئ أول مستخدم أدمن:

من مجلد **backend** (وليس من admin_panel):

```bash
cd ../backend
npm run create-admin
```

أو من جذر المشروع (مجلد "my order"):

```bash
cd backend
npm run create-admin
```

**مهم:** إذا كنت داخل `admin_panel` فاستخدم `cd ../backend` أولاً. السكربت يعمل فقط من داخل مجلد backend.

أو تشغيل السكربت بعد إيقاف السيرفر (الجداول تبقى موجودة).

المستخدم التجريبي الافتراضي (بعد تشغيل السكربت):

- **البريد:** `admin@platform.com`
- **كلمة المرور:** `Admin@123`

### 2. الفرونت إند

```bash
cd admin_panel
cp .env.local.example .env.local   # وتعديل NEXT_PUBLIC_API_URL إذا لزم (مثلاً http://localhost:3001)
npm run dev
```

افتح `http://localhost:3002` → إعادة توجيه إلى `/auth/login` إن لم يكن هناك توكن. سجّل الدخول بالحساب أعلاه → إعادة توجيه إلى `/dashboard`.

---

## معيار الإنجاز

- أدمن يسجّل دخولاً بحساب من DB.
- بدون تسجيل دخول لا يمكن فتح `/dashboard` أو أي مسار تحته (يتم التوجيه إلى `/auth/login`).
- طلبات API إلى `/api/admin/*` (ما عدا login) تتطلب `Authorization: Bearer <token>` وتوكن من نوع أدمن.

---

## الخطوة التالية

المرحلة 2: **Audit Logs** — جدول `audit_logs` + `AuditService.log` قبل أي أزرار موافقة/رفض.
