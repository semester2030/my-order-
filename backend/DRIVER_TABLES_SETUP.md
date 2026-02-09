# 🗄️ Driver Tables Setup Guide

**التاريخ:** 25 يناير 2026  
**الهدف:** إعداد جداول Driver و JobOffer في قاعدة البيانات

---

## 🎯 **الخيارات المتاحة:**

### **Option 1: TypeORM Synchronize (Development)** ⭐⭐⭐⭐⭐

#### **الإعداد الحالي:**
```typescript
// backend/src/config/database.config.ts
synchronize: configService.get<string>('NODE_ENV') === 'development',
```

#### **الاستخدام:**
1. ✅ تأكد أن `NODE_ENV=development` في `.env`
2. ✅ شغل Backend: `npm run start:dev`
3. ✅ TypeORM سينشئ الجداول تلقائياً

#### **المزايا:**
- ✅ تلقائي - لا يحتاج SQL scripts
- ✅ يحدث الجداول تلقائياً عند تغيير Entities
- ✅ مناسب للـ development

#### **التحذيرات:**
- ⚠️ **لا تستخدم في Production!**
- ⚠️ قد يحذف البيانات عند تغيير structure

---

### **Option 2: Manual SQL Script** ⭐⭐⭐⭐

#### **الاستخدام:**
1. ✅ افتح PostgreSQL client (psql, pgAdmin, etc.)
2. ✅ شغل الملف: `CREATE_DRIVER_TABLES.sql`
3. ✅ تأكد من أن `synchronize: false` في production

#### **المزايا:**
- ✅ تحكم كامل
- ✅ آمن في Production
- ✅ يمكن مراجعته قبل التنفيذ

#### **الملفات:**
- ✅ `CREATE_DRIVER_TABLES.sql` - SQL script كامل

---

## 📋 **الجداول المطلوبة:**

### **1. Drivers Table**
- ✅ جميع الحقول المطلوبة
- ✅ Relations مع Users
- ✅ Indexes للأداء

### **2. Job Offers Table**
- ✅ Job offers للـ drivers
- ✅ Relations مع Orders و Drivers
- ✅ Indexes للأداء

### **3. Enums**
- ✅ `driver_status` enum
- ✅ `license_type` enum
- ✅ `vehicle_type` enum
- ✅ `job_status` enum

---

## 🔧 **خطوات التنفيذ:**

### **Development (Synchronize):**

1. ✅ تأكد من `.env`:
   ```env
   NODE_ENV=development
   DATABASE_HOST=localhost
   DATABASE_PORT=5432
   DATABASE_USER=postgres
   DATABASE_PASSWORD=your_password
   DATABASE_NAME=customer_app
   ```

2. ✅ شغل Backend:
   ```bash
   cd backend
   npm run start:dev
   ```

3. ✅ TypeORM سينشئ الجداول تلقائياً

---

### **Production (Manual SQL):**

1. ✅ تأكد من `.env`:
   ```env
   NODE_ENV=production
   synchronize: false
   ```

2. ✅ شغل SQL script:
   ```bash
   psql -U postgres -d customer_app -f CREATE_DRIVER_TABLES.sql
   ```

   أو في pgAdmin:
   - افتح Query Tool
   - انسخ محتوى `CREATE_DRIVER_TABLES.sql`
   - شغل Query

3. ✅ تحقق من الجداول:
   ```sql
   \dt drivers
   \dt job_offers
   ```

---

## ✅ **التحقق:**

### **Check Tables:**
```sql
-- Check drivers table
SELECT * FROM drivers LIMIT 1;

-- Check job_offers table
SELECT * FROM job_offers LIMIT 1;

-- Check enums
SELECT enumlabel FROM pg_enum WHERE enumtypid = 'driver_status'::regtype;
```

---

## ⚠️ **ملاحظات مهمة:**

1. ⚠️ **Development:** استخدم `synchronize: true`
2. ⚠️ **Production:** استخدم `synchronize: false` + Manual SQL
3. ⚠️ **Backup:** احفظ backup قبل أي تغييرات
4. ⚠️ **Testing:** اختبر في development أولاً

---

## 🎯 **التوصية:**

- ✅ **Development:** استخدم TypeORM synchronize (أسهل)
- ✅ **Production:** استخدم Manual SQL script (أكثر أماناً)

---

**جاهز للاستخدام!** ✅
