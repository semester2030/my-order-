# إعداد إرسال رمز OTP (جاهز للإنتاج)

## الحل المعتمد: Resend

تم دمج **Resend** لإرسال رموز OTP إلى البريد الإلكتروني. الخدمة مجانية لحد 3,000 رسالة/شهر.

---

## الإعداد على Render

### 1. إنشاء حساب Resend

1. ادخل إلى [resend.com](https://resend.com)
2. سجّل حساباً مجانياً
3. من لوحة التحكم: **API Keys** → **Create API Key**
4. انسخ المفتاح (يبدأ بـ `re_`)

### 2. إضافة المتغيرات على Render

في **Environment** لمشروعك أضف:

| Key | Value |
|-----|-------|
| `RESEND_API_KEY` | `re_xxxxxxxxxxxx` (المفتاح من Resend) |
| `RESEND_FROM` | (مهم للإنتاج) عنوان من دومينك، مثال: `My Order <noreply@yourdomain.com>` |

**للاختبار:** بدون `RESEND_FROM` يُستخدم `onboarding@resend.dev` — قد لا يصل البريد إلى Outlook/Gmail (يُحجب كـ spam).

**للإنتاج:** أضف دومينك وتحقق منه في Resend (Domains → Add Domain)، ثم استخدم عنواناً منه.

### 3. حفظ وإعادة النشر

بعد إضافة المتغيرات، اضغط **Save, rebuild, and deploy**.

---

## البريد لا يصل؟ استكشاف الأخطاء

### 1. تحقق من سجلات Resend
- ادخل [resend.com](https://resend.com) → **Logs** أو **Emails**
- ابحث عن الرسالة المرسلة إلى بريدك
- انظر حالة التسليم: Delivered / Bounced / Failed

### 2. مجلد spam
تفقد مجلد **الرسائل غير المرغوبة** في Outlook.

### 3. عنوان المرسل بدون دومين
`onboarding@resend.dev` غالباً يُحجب من مزودي البريد. الحل: أضف دومينك في Resend:
- Resend → **Domains** → **Add Domain**
- أضف دومينك (مثلاً `myorder.com`) واتبع تعليمات DNS
- بعد التحقق، عيّن `RESEND_FROM=My Order <noreply@myorder.com>`

### 4. حل مؤقت: OTP_FORCE_WHITELIST
إذا أرسل Resend بنجاح لكن البريد لا يصل، أضف بريدك للمتغير:

```
OTP_FORCE_WHITELIST=cy-20@outlook.com
```

سيظهر الرمز في التطبيق مباشرة. استخدمه للتجربة فقط وليس للإنتاج.

---

## المتغيرات

| المتغير | الغرض |
|--------|-------|
| `RESEND_API_KEY` | مفتاح Resend (مطلوب) |
| `RESEND_FROM` | عنوان المرسل (مُفضل للإنتاج) |
| `OTP_DEV_WHITELIST` | عرض OTP في التطبيق عند عدم وجود Resend |
| `OTP_FORCE_WHITELIST` | عرض OTP حتى مع إرسال البريد (عند مشاكل التسليم) |
