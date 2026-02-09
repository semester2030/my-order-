# 🔧 خطوات حل المشكلة - خطوة بخطوة

## 🔴 المشكلة

1. **الطلب لم يصل للسائق** (Driver App: "No jobs available")
2. **حالة الطلب لم تتغير عند العميل** (Customer App: "Order Placed")

---

## ✅ الحل السريع

### **الخطوة 1: تحقق من Order و Job Offer**

شغّل:
```bash
psql -d customer_app -f backend/CHECK_ORDER_AND_JOB.sql
```

أو نفّذ مباشرة:
```sql
-- 1. ابحث عن Order
SELECT id, order_number, status FROM orders 
WHERE order_number = 'ORD-2026-000013';

-- 2. تحقق من Job Offer
SELECT id, order_id, status, expires_at 
FROM job_offers 
WHERE order_id IN (
  SELECT id FROM orders WHERE order_number = 'ORD-2026-000013'
);
```

---

### **الخطوة 2: أنشئ Job Offer يدوياً**

شغّل:
```bash
psql -d customer_app -f backend/CREATE_JOB_OFFER_FOR_ORDER.sql
```

أو نفّذ مباشرة:
```sql
INSERT INTO job_offers (
  id, order_id, status, delivery_fee, driver_earnings,
  pickup_latitude, pickup_longitude,
  delivery_latitude, delivery_longitude,
  estimated_distance, estimated_duration,
  expires_at, created_at, updated_at
)
SELECT 
  gen_random_uuid(),
  o.id,
  'pending',
  o.delivery_fee,
  o.delivery_fee * 0.8,
  v.latitude,
  v.longitude,
  a.latitude,
  a.longitude,
  5.0,
  15,
  NOW() + INTERVAL '10 minutes',
  NOW(),
  NOW()
FROM orders o
JOIN vendors v ON v.id = o.vendor_id
JOIN addresses a ON a.id = o.address_id
WHERE o.order_number = 'ORD-2026-000013'
  AND NOT EXISTS (
    SELECT 1 FROM job_offers jo WHERE jo.order_id = o.id
  );
```

---

### **الخطوة 3: تحقق من Driver Online**

```sql
SELECT phone_number, status, is_online 
FROM drivers 
WHERE phone_number = '0500756756';
```

يجب أن يكون:
- ✅ `status = 'approved'`
- ✅ `is_online = true` (فعّل من التطبيق)

---

### **الخطوة 4: أعد تحميل Jobs في Driver App**

1. في **Driver App**
2. اذهب إلى **Jobs Screen**
3. **اسحب للأسفل** (Pull to Refresh)
4. يجب أن يظهر **Job Offer** ✅

---

### **الخطوة 5: تحديث Customer App**

1. في **Customer App**
2. اذهب إلى **Order Tracking Screen**
3. **اسحب للأسفل** (Pull to Refresh)
4. يجب أن ترى **Status = "Out for Delivery"** ✅

---

## 🎯 النتيجة المتوقعة

بعد تنفيذ الخطوات:

1. ✅ **Driver App**: يظهر Job Offer
2. ✅ **Customer App**: يرى Status = "Out for Delivery" (بعد refresh)
3. ✅ **Vendor Dashboard**: Status = "Out for Delivery"

---

## ⚠️ ملاحظات مهمة

1. **Job Offer Expiry:**
   - Job Offers تنتهي بعد **10 دقائق**
   - إذا انتهت، أنشئ واحدة جديدة

2. **Driver Must Be Online:**
   - السائق يجب أن يكون **Online** لاستقبال Job Offers
   - تحقق من `is_online = true`

3. **Order Status Flow:**
   - يجب أن يكون: `PENDING → CONFIRMED → PREPARING → READY → OUT_FOR_DELIVERY → DELIVERED`
   - لا تتخطى `READY` مباشرة إلى `OUT_FOR_DELIVERY`

---

**تاريخ**: 28 يناير 2026
