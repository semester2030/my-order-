# إنشاء أول مستخدم أدمن

**لا حاجة لـ migration:run في التطوير.** الباك إند يستخدم `synchronize: true` في development، فجداول `admin_roles` و `admin_users` تُنشأ تلقائياً عند تشغيل السيرفر (`npm run start:dev`).

1. شغّل الباك إند مرة واحدة حتى يكتمل التشغيل (ليُنشئ TypeORM الجداول): من مجلد **backend** نفّذ `npm run start:dev`.
2. من مجلد **backend** (وليس admin_panel) شغّل:
   ```bash
   cd ../backend
   npm run create-admin
   ```
   (إذا كنت داخل admin_panel استخدم `cd ../backend` أولاً.)
3. أو إدراج يدوي في DB:
   - احصل على `id` من جدول `admin_roles` حيث `slug = 'super_admin'`
   - أنشئ hash لكلمة المرور باستخدام bcrypt (مثلاً من Node: `require('bcrypt').hashSync('YourPassword', 10)`)
   - أدرج صفاً في `admin_users` (email, password_hash, role_id, name, is_active)

الافتراضي في السكربت: `admin@platform.com` / `Admin@123` (غيّر في بيئة الإنتاج).
