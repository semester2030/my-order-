# Admin Panel — منصة الإدارة الشاملة

منصة ويب واحدة للإدارة: موافقات، تشغيل، مراقبة، تحكم، منع تلاعب، وسجلات.

## الهيكل (هيكل احترافي دقيق شامل)

```
admin_panel/
├── app/
│   ├── auth/              ← تسجيل دخول الأدمن
│   │   └── login/
│   ├── dashboard/         ← لوحة رئيسية حسب الدور
│   ├── vendors/           ← إدارة المطاعم + الموافقات
│   │   ├── applications/  ← طلبات تسجيل المطاعم (Approve / Reject / Needs changes)
│   │   └── [id]/          ← تفاصيل مطعم
│   ├── drivers/           ← إدارة السائقين + الموافقات
│   │   ├── applications/  ← طلبات تسجيل السائقين (Approve / Reject / Suspend / Probation)
│   │   └── [id]/          ← تفاصيل سائق
│   ├── orders/            ← الطلبات (عرض، تتبع، تدخل)
│   │   ├── live/          ← طلبات حية
│   │   └── [id]/          ← تفاصيل طلب
│   ├── payments/          ← المدفوعات والمصالحة
│   │   └── reconciliation/
│   ├── disputes/          ← الشكاوى وحلها
│   │   └── [id]/
│   ├── monitoring/        ← المراقبة اليومية (حرجة)
│   ├── risk_engine/       ← قواعد منع التلاعب
│   ├── settings/          ← إعدادات المنصة والأدوار
│   │   └── roles/
│   └── audit_logs/        ← سجل كل فعل (قانوني + تشغيلي)
├── components/
│   ├── layout/            ← Sidebar, Header, RoleGuard
│   ├── vendors/
│   ├── drivers/
│   ├── orders/
│   └── ...
└── lib/
    ├── api/                ← استدعاءات Backend
    ├── auth/               ← صلاحيات وأدوار
    └── constants/          ← أدوار، صلاحيات
```

## الأدوار (Roles)

| الدور         | الوحدات الظاهرة                    |
|--------------|-------------------------------------|
| Super Admin  | الكل                               |
| Ops Admin    | Vendors, Drivers, Orders, Monitoring |
| Finance      | Payments                            |
| Support      | Orders, Disputes, Monitoring        |
| Quality      | Vendors, Drivers (قراءة + تقييم)   |

## التشغيل (لاحقاً)

```bash
cd admin_panel
npm install
npm run dev
```

الربط مع Backend عبر متغير بيئة `NEXT_PUBLIC_API_URL`.
