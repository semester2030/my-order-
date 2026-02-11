# نشر الباك اند مجاناً على Render (شهر–شهرين)

## 1) حساب Render
- ادخل إلى https://render.com و سجّل (مجاني).
- اختَر **New +** → **Web Service** و **PostgreSQL** (قاعدة بيانات).

---

## 2) إنشاء قاعدة PostgreSQL
- **New +** → **PostgreSQL**
- Name: `vendor-db` (أو أي اسم)
- Region: اختر الأقرب (مثلاً Frankfurt).
- Free plan → **Create Database**
- بعد الإنشاء: ادخل إلى الـ Database وانسخ **Internal Database URL** (للاستخدام من نفس Render).

---

## 3) ربط المشروع بـ Git (إن لم يكن مربوطاً)
على جهازك في مجلد المشروع:
```bash
cd "/Users/fayez/Desktop/my order"
git init
git add .
git commit -m "Initial"
```
ثم أنشئ repo على **GitHub** واربط:
```bash
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
git branch -M main
git push -u origin main
```

---

## 4) إنشاء Web Service على Render
- **New +** → **Web Service**
- Connect الـ GitHub repo (مجلد المشروع الذي فيه الباك اند).
- إذا الباك اند في مجلد فرعي مثل `backend`:
  - **Root Directory**: `backend`
- إعدادات البناء:
  - **Build Command**: `npm install && npm run build`
  - **Start Command**: `npm run start:prod`
- **Instance Type**: Free

---

## 5) متغيرات البيئة (Environment)
في الـ Web Service → **Environment** أضف:

| Key | Value |
|-----|--------|
| `NODE_ENV` | production |
| `DATABASE_URL` | (الصق **Internal Database URL** من خطوة 2 — من لوحة PostgreSQL في Render) |
| `JWT_SECRET` | (سلسلة عشوائية طويلة، مثلاً 32 حرفاً، لأمان التوكن) |
| `PORT` | 3001 |
| `RESEND_API_KEY` | (مفتاح من [resend.com](https://resend.com) لإرسال OTP بالبريد — **مطلوب للإنتاج**) |
| `RESEND_FROM` | (اختياري) عنوان المرسل، مثال: `My Order <noreply@yourdomain.com>` |

الباك اند يدعم `DATABASE_URL` مباشرة (يُفضّل على Render). لإرسال رموز OTP للبريد، أضف `RESEND_API_KEY` — راجع `docs/OTP_SETUP.md`.

---

## 6) Migrations تُشغَّل تلقائياً عند بدء التطبيق
الباك اند يشتغل الـ migrations تلقائياً عند كل بدء (بما في ذلك أول Deploy على Render). **لا تحتاج Shell ولا تشغيل أي أمر على جهازك.** إذا ظهر في الـ Logs سطر `Migrations completed.` فمعناه أن الجداول محدَّثة. إذا ظهر `Migrations failed:` فتحقق من صحة `DATABASE_URL` في Environment.

---

## 7) إنشاء Web Service (الباك اند)
- من لوحة Render: **New +** → **Web Service**
- **Connect repository**: اختر GitHub ثم المستودع (Repo) الذي فيه مشروعك. إذا المشروع في مجلد فرعي اسمه `backend`، في **Root Directory** اكتب: `backend`
- **Name**: مثلاً `vendor-api` أو `myorder-api`
- **Region**: اختر **نفس منطقة القاعدة** (Oregon US West) حتى تستخدم Internal URL
- **Branch**: `main`
- **Runtime**: Node
- **Build Command**: `npm install && npm run build`
- **Start Command**: `npm run start:prod`
- **Instance Type**: Free
- في **Environment** (متغيرات البيئة) أضف:
  - `NODE_ENV` = `production`
  - `DATABASE_URL` = (الصق **Internal Database URL** من صفحة myorder-db — زر النسخ بجانبه)
  - `JWT_SECRET` = (نص عشوائي طويل، مثلاً 32 حرف)
  - `PORT` = `3001`
- اضغط **Create Web Service**. انتظر حتى ينتهي الـ Build والـ Deploy.

## 8) الرابط النهائي للـ API
بعد النشر، Render يعطيك رابط مثل:
`https://your-service-name.onrender.com`

- الـ API يكون عادة: `https://your-service-name.onrender.com/api`
- هذا الرابط يعمل من أي مكان (جوال، محاكي، جهازك).

---

## 8) ضبط التطبيق (Vendor App)
شغّل التطبيق مع هذا الرابط:
```bash
flutter run --release -d <device_id> --dart-define=API_BASE_URL=https://your-service-name.onrender.com/api
```

أو لبناء للتوزيع: ضع نفس الرابط في إعدادات البناء (مثلاً في CI أو في ملف env للـ release).

---

## استكشاف الأخطاء

### "JavaScript heap out of memory" أو "No open ports detected"
- **السبب:** أمر التشغيل كان `npm run start` (وضع التطوير) فيستهلك ذاكرة كثيرة ولا يربط المنفذ الصحيح.
- **الحل:** في Render → خدمتك → **Settings** (أو **Environment** حسب الواجهة) تأكد أن **Start Command** هو بالضبط:
  ```bash
  npm run start:prod
  ```
  وليس `npm start` أو `nest start`. ثم **Save** واعمل **Manual Deploy**.
- إن استمر نفاد الذاكرة، أضف في **Environment**: `NODE_OPTIONS` = `--max-old-space-size=460`

### Render لا يكتشف المنفذ
- التطبيق يربط بالفعل على `process.env.PORT`. تأكد أن Start Command هو `npm run start:prod` حتى يعمل `node dist/main` ويستمع على المنفذ الذي يعطيه Render.

---

## ملاحظات
- الخطة المجانية: الخدمة "تنام" بعد ~15 دقيقة — أول طلب بعدها قد يأخذ 30–60 ثانية ثم يعمل طبيعي.
- القاعدة المجانية مناسبة لتجربة شهر–شهرين؛ البيانات تُحفظ طالما لم تحذف المشروع.
- بدائل مجانية أخرى: **Railway** (رصيد شهري)، **Fly.io** (حصة مجانية).
