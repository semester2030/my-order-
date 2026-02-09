# كيفية تشغيل Backend

## المشكلة:
```
Error: listen EADDRINUSE: address already in use :::3000
```

## الحل السريع:

### الطريقة 1: إيقاف العملية (الأفضل)

```bash
# ابحث عن العملية
lsof -ti:3000

# أوقفها
kill -9 $(lsof -ti:3000)
```

أو استخدم الـ script:
```bash
chmod +x KILL_PORT_3000.sh
./KILL_PORT_3000.sh
```

### الطريقة 2: استخدام port آخر

عدل `backend/src/main.ts`:
```typescript
const port = process.env.PORT || 3001; // بدلاً من 3000
```

ثم عدل `vendor-web/.env.local`:
```
NEXT_PUBLIC_API_URL=http://localhost:3001/api
```

---

## بعد الإصلاح:

```bash
cd backend
npm run start:dev
```

يجب أن يعمل الآن! ✅
