# مطبخ البيت | Home Kitchen — الموقع الإلكتروني

موقع إلكتروني احترافي ثنائي اللغة (عربي/إنجليزي) يشرح منصة مطبخ البيت وخدماتها بالتفصيل.

## المحتوى

- **من نحن** — تعريف بالمنصة وأهدافها
- **خدماتنا** — أربع فئات مفصلة:
  1. **الطبخ المنزلي** — وجبات جاهزة
  2. **الطبخ الشعبي** — الطباخ يأتي عندك (ذبايح، ولائم)
  3. **المناسبات الخاصة** — تخرج، زواج، ولائم
  4. **الشوي** — وجبات شوي جاهزة
- **كيف يعمل** — خطوات الاستخدام
- **من نخدم** — العملاء، الطباخون، مقدمو المناسبات
- **حمّل التطبيق** — روابط التحميل (قريباً)

## النشر على Netlify

### الطريقة 1: السحب والإفلات
1. ادخل إلى [app.netlify.com](https://app.netlify.com)
2. اسحب مجلد `website` وأفلته في منطقة "Deploy"
3. الموقع سيعمل فوراً على رابط مثل `random-name.netlify.app`

### الطريقة 2: ربط Git
1. ارفع المشروع إلى GitHub
2. في Netlify: New site from Git → اختر المستودع
3. **Build settings:**
   - Base directory: `website`
   - Publish directory: `website` (أو `.` إذا كان المستودع = مجلد website فقط)
   - Build command: اتركه فارغاً (موقع ثابت)

### الطريقة 3: Netlify CLI
```bash
cd website
npx netlify deploy --prod --dir=.
```

## ربط الدومين (عند الحصول عليه)

1. في Netlify: Site settings → Domain management
2. Add custom domain
3. اتبع التعليمات لتحديث DNS عند مزود الدومين

## ربط التطبيق

بعد النشر، حدّث الرابط في التطبيق:
- الملف: `customer_app/lib/core/config/app_urls.dart`
- غيّر `websiteBaseUrl` إلى رابط موقعك على Netlify (مثل `https://your-site.netlify.app`)

---

## الملفات

```
website/
├── index.html      # الصفحة الرئيسية (كل المحتوى)
├── privacy.html    # سياسة الخصوصية
├── terms.html      # الشروط والأحكام
├── css/styles.css  # التنسيقات
├── js/main.js      # التفاعل والترجمة
├── netlify.toml    # إعدادات Netlify
└── README.md       # هذا الملف
```
