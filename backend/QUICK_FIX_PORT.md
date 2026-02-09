# إصلاح Port 3000 - حل سريع

## المشكلة:
Port 3000 مستخدم ولا يمكن إيقاف العملية.

## الحل السريع:

### **استخدم port 3001 للـ Backend:**

1. **عدل `backend/src/main.ts`:**
   ```typescript
   const port = process.env.PORT || 3001; // بدلاً من 3000
   ```

2. **عدل `vendor-web/.env.local`:**
   ```
   NEXT_PUBLIC_API_URL=http://localhost:3001/api
   ```

3. **أعد تشغيل Backend:**
   ```bash
   cd backend
   npm run start:dev
   ```

4. **أعد تشغيل Frontend:**
   ```bash
   cd vendor-web
   npm run dev
   ```

---

## أو: أوقف العملية يدوياً

```bash
# ابحث عن العملية
lsof -ti:3000

# أوقفها (قد تحتاج sudo)
sudo kill -9 $(lsof -ti:3000)
```

---

**بعد الإصلاح، كل شيء سيعمل!** ✅
