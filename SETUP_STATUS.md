# حالة الإعداد الحالية والخطوات المطلوبة

## ✅ الوضع الحالي:

### ما هو موجود:
- ✅ PostgreSQL 14 مثبت (via Homebrew)
- ✅ Node.js v25.1.0 موجود
- ✅ npm 11.6.2 موجود
- ✅ المشروع في: `/Users/fayez/Desktop/my order/backend`

### المشاكل:
- ❌ مشكلة صلاحيات في Homebrew (لا يمكن تثبيت packages جديدة)
- ❌ PostgreSQL غير مشغل
- ❌ Node 25 قد يسبب مشاكل مع NestJS/TypeORM (يحتاج Node 20)

---

## 🔧 الحلول المطلوبة:

### الحل 1: إصلاح صلاحيات Homebrew (يحتاج sudo)

```bash
sudo chown -R fayez /opt/homebrew
sudo chown -R fayez /Users/fayez/Library/Caches/Homebrew
sudo chown -R fayez /Users/fayez/Library/Logs/Homebrew
```

**بعد ذلك:**
```bash
brew install nvm
```

---

### الحل 2: تثبيت nvm مباشرة (بدون Homebrew)

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

**ثم:**
```bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 20
nvm use 20
```

---

### الحل 3: تشغيل PostgreSQL يدوياً

**الطريقة 1: عبر pg_ctl**
```bash
# حذف ملف lock القديم أولاً
rm /opt/homebrew/var/postgresql@14/postmaster.pid

# تشغيل PostgreSQL
pg_ctl -D /opt/homebrew/var/postgresql@14 start
```

**الطريقة 2: عبر System Preferences**
- افتح System Preferences
- ابحث عن PostgreSQL
- شغّل Service

**التحقق:**
```bash
pg_isready
```

---

## 📋 الخطوات الموصى بها (بالترتيب):

### الخطوة 1: إصلاح صلاحيات Homebrew
```bash
sudo chown -R fayez /opt/homebrew /Users/fayez/Library/Caches/Homebrew /Users/fayez/Library/Logs/Homebrew
```

### الخطوة 2: تثبيت nvm
```bash
brew install nvm
# أو
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
```

### الخطوة 3: تثبيت Node 20
```bash
nvm install 20
nvm use 20
node -v  # يجب أن يظهر v20.x.x
```

### الخطوة 4: تشغيل PostgreSQL
```bash
# حذف lock file
rm /opt/homebrew/var/postgresql@14/postmaster.pid 2>/dev/null

# تشغيل PostgreSQL
pg_ctl -D /opt/homebrew/var/postgresql@14 start

# التحقق
pg_isready
```

### الخطوة 5: إنشاء قاعدة البيانات
```bash
createdb customer_app
psql -l | grep customer_app
```

### الخطوة 6: تجهيز .env و data-source.ts
(سأقوم بذلك بعد تأكيد الخطوات السابقة)

---

## ⚠️ ملاحظات مهمة:

1. **صلاحيات Homebrew:** تحتاج sudo لإصلاحها
2. **PostgreSQL:** يحتاج تشغيل يدوي بسبب مشكلة lock file
3. **Node 20:** مهم لتجنب مشاكل NestJS/TypeORM
4. **nvm:** يمكن تثبيته مباشرة بدون Homebrew

---

## 🎯 الخطوات السريعة (بدون sudo):

إذا لم تستطع استخدام sudo، يمكنك:

1. **تثبيت nvm مباشرة:**
```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
source ~/.zshrc
nvm install 20
nvm use 20
```

2. **تشغيل PostgreSQL:**
```bash
rm /opt/homebrew/var/postgresql@14/postmaster.pid 2>/dev/null
pg_ctl -D /opt/homebrew/var/postgresql@14 start
```

3. **إنشاء قاعدة البيانات:**
```bash
createdb customer_app
```

---

## ✅ بعد إتمام الخطوات:

أرسل لي مخرجات هذه الأوامر:
```bash
pg_isready
node -v
pwd
```

وسأكمل باقي الخطوات (تجهيز .env و data-source.ts و Migration).
