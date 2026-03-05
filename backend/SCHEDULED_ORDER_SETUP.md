# إعداد الطلب المسبق — خطوة واحدة مطلوبة

## تشغيل SQL يدوياً (مرة واحدة)

قبل استخدام ميزة الطلب المسبق، شغّل الملف التالي على قاعدة البيانات:

```bash
# محلياً (استبدل customer_app باسم قاعدة بياناتك)
psql -d customer_app -f src/migrations/manual-add-scheduled-order-columns.sql

# على Render: من Render Dashboard → Shell → أو اتصل بقاعدة البيانات وانسخ محتوى الملف
```

**ملاحظة:** الملف آمن للتشغيل المتكرر (`ADD COLUMN IF NOT EXISTS`).

---

## لا توجد Migration تلقائية

لم نضف ملف Migration في مجلد migrations — لن يُشغّل أي شيء تلقائياً على جهازك. التشغيل يدوي فقط عند الحاجة.
