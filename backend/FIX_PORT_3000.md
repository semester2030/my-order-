# إصلاح مشكلة Port 3000

## المشكلة:
```
Error: listen EADDRINUSE: address already in use :::3000
```

## الحل:

### الطريقة 1: إيقاف العملية (الأفضل)

```bash
# ابحث عن العملية
lsof -ti:3000

# أوقفها
kill -9 $(lsof -ti:3000)
```

### الطريقة 2: استخدام port آخر

عدل `backend/src/main.ts`:

```typescript
await app.listen(3001); // بدلاً من 3000
```

ثم عدل `vendor-web/.env.local`:

```
NEXT_PUBLIC_API_URL=http://localhost:3001/api
```

---

## بعد الإصلاح:

1. أعد تشغيل Backend: `npm run start:dev`
2. تأكد من أن Frontend يعمل: `http://localhost:3001`
3. جرب تسجيل الدخول
