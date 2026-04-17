# 📍 أين يجب إضافة Cloudflare Credentials؟

## ✅ **الإجابة الصحيحة: في Backend فقط**

### **الموقع الصحيح:**
```
backend/.env
```

### **القيم المطلوبة (عناصر نائبة — لا تلصق أسراراً حقيقية في Git):**
```env
CLOUDFLARE_ACCOUNT_ID=YOUR_CLOUDFLARE_ACCOUNT_ID
CLOUDFLARE_API_TOKEN=YOUR_CLOUDFLARE_API_TOKEN
```

**للتطوير المحلي:** انسخ الملف إلى `backend/.env` واملأ القيم من لوحة Cloudflare ومن Render؛ **لا ترفع** `.env` إلى Git (يجب أن يكون في `.gitignore`).

---

## ❌ **أين لا يجب إضافتها:**

### 1. ❌ **Vendor Web App** (`vendor-web/.env.local`)
- **لا تضيفها هنا**
- Vendor Web App يستدعي Backend API فقط
- لا يتصل مباشرة مع Cloudflare

### 2. ❌ **Customer App** (Flutter)
- **لا تضيفها هنا**
- Customer App يعرض الفيديوهات فقط
- لا يحتاج Cloudflare credentials

---

## 🔒 **لماذا في Backend فقط؟**

### **1. الأمان:**
- API Token سري جداً
- إذا وُضع في Frontend، يمكن لأي شخص رؤيته
- في Backend، محمي على السيرفر فقط

### **2. البنية المعمارية:**
```
Vendor Web App (Frontend)
    ↓
    API Call: POST /api/videos/upload/init
    ↓
Backend (NestJS)
    ↓
    Uses CLOUDFLARE_API_TOKEN (مخفي)
    ↓
Cloudflare Stream API
```

### **3. الممارسات الأمنية:**
- ✅ Secrets في Backend فقط
- ✅ Frontend لا يعرف API Keys
- ✅ Backend يتحكم في جميع الاتصالات الخارجية

---

## 📋 **كيف يعمل النظام:**

### **1. Vendor Web App (Frontend):**
```typescript
// vendor-web/components/menu/add-menu-item-modal.tsx
const initResponse = await videosApi.initUpload({
  menuItemId,
  fileName: file.name,
  fileSize: file.size,
})
// ✅ يستدعي Backend API فقط
// ❌ لا يعرف Cloudflare Token
```

### **2. Backend (NestJS):**
```typescript
// backend/src/modules/videos/cloudflare/cloudflare-stream.service.ts
constructor(private configService: ConfigService) {
  this.accountId = this.configService.get<string>('CLOUDFLARE_ACCOUNT_ID');
  this.apiToken = this.configService.get<string>('CLOUDFLARE_API_TOKEN');
  // ✅ يقرأ من .env
  // ✅ محمي على السيرفر
}
```

### **3. Cloudflare Stream:**
```typescript
// Backend يتصل مباشرة مع Cloudflare
this.client.post('/direct_upload', {...})
// ✅ يستخدم Token المخفي
```

---

## ✅ **الخلاصة:**

| المكان | يجب إضافة Credentials؟ | السبب |
|-------|----------------------|--------|
| **Backend** (`backend/.env`) | ✅ **نعم** | الموقع الصحيح - محمي على السيرفر |
| **Vendor Web App** | ❌ لا | يستدعي Backend فقط |
| **Customer App** | ❌ لا | يعرض الفيديوهات فقط |

---

## 🎯 **ما تم إضافته:**

✅ **الموقع الصحيح للقيم الحقيقية:**
- محلياً: `backend/.env` (غير مرفوع إلى Git)
- إنتاج: متغيرات البيئة في **Render** فقط

**كل شيء جاهز بعد** تعبئة `.env` محلياً أو Render وإعادة النشر.
