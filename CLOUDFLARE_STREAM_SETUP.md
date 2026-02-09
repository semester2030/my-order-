# Cloudflare Stream Setup - دليل شامل

## 📋 المتطلبات

### 1. حساب Cloudflare
- ✅ حساب Cloudflare Pro أو أعلى (لـ Stream)
- ✅ API Token مع صلاحيات Stream

### 2. إعدادات Stream
- ✅ تفعيل Stream في Dashboard
- ✅ الحصول على Account ID
- ✅ إنشاء API Token

---

## 🔐 إعدادات الأمان

### ✅ Unlisted + Signed URLs (موصى به)

**لماذا:**
- **Unlisted**: الفيديوهات لا تظهر في قائمة عامة
- **Signed URLs**: URLs مؤقتة (انتهاء صلاحية)
- **Security**: منع الوصول غير المصرح

**التنفيذ:**
```typescript
// كل فيديو:
{
  requireSignedURLs: true,
  allowedOrigins: ['your-app-domain.com'],
  unlisted: true
}
```

---

## 📡 API Endpoints

### 1. POST /videos/upload/init

**الوصف:** يبدأ عملية رفع الفيديو

**Request:**
```json
{
  "menuItemId": "uuid",
  "fileName": "dish-video.mp4",
  "fileSize": 10485760
}
```

**Response:**
```json
{
  "uploadId": "uuid",
  "uploadUrl": "https://api.cloudflare.com/client/v4/accounts/{account_id}/stream/upload",
  "expiresAt": "2024-01-01T12:00:00Z"
}
```

**Implementation:**
```typescript
// videos.controller.ts
@Post('upload/init')
async initUpload(@Body() dto: InitUploadDto) {
  return this.videosService.initUpload(dto);
}
```

---

### 2. POST /videos/upload/complete

**الوصف:** يكمل رفع الفيديو ويحفظ البيانات

**Request:**
```json
{
  "uploadId": "uuid",
  "menuItemId": "uuid",
  "cloudflareAssetId": "asset-id-from-cloudflare"
}
```

**Response:**
```json
{
  "id": "uuid",
  "menuItemId": "uuid",
  "playbackUrl": "https://customer-{account_id}.cloudflarestream.com/{asset_id}/manifest/video.m3u8",
  "thumbnailUrl": "https://customer-{account_id}.cloudflarestream.com/{asset_id}/thumbnails/thumbnail.jpg",
  "duration": 30,
  "status": "ready"
}
```

**Implementation:**
```typescript
// videos.controller.ts
@Post('upload/complete')
async completeUpload(@Body() dto: CompleteUploadDto) {
  return this.videosService.completeUpload(dto);
}
```

---

## 🗄️ Database Schema

### VideoAsset Entity

```typescript
// video-asset.entity.ts
@Entity('video_assets')
export class VideoAsset {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column('uuid')
  menuItemId: string;

  @ManyToOne(() => MenuItem, menuItem => menuItem.videoAssets)
  menuItem: MenuItem;

  @Column()
  cloudflareAssetId: string;

  @Column()
  playbackUrl: string;  // Signed HLS URL

  @Column({ nullable: true })
  thumbnailUrl: string;

  @Column('int')
  duration: number;  // بالثواني

  @Column({
    type: 'enum',
    enum: ['processing', 'ready', 'failed'],
    default: 'processing'
  })
  status: VideoStatus;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

### MenuItem Entity (تحديث)

```typescript
// menu-item.entity.ts
@Entity('menu_items')
export class MenuItem {
  // ... existing fields

  @OneToMany(() => VideoAsset, videoAsset => videoAsset.menuItem)
  videoAssets: VideoAsset[];

  @Column({ nullable: true })
  primaryVideoAssetId: string;  // الفيديو الرئيسي للعرض
}
```

---

## 🔧 Implementation Details

### 1. Cloudflare Stream Service

```typescript
// cloudflare-stream.service.ts
@Injectable()
export class CloudflareStreamService {
  private readonly accountId: string;
  private readonly apiToken: string;

  async initUpload(fileName: string, fileSize: number) {
    // Call Cloudflare API
    // Return upload URL
  }

  async getAssetDetails(assetId: string) {
    // Get playback URL, thumbnail, duration
  }

  async generateSignedURL(assetId: string, expiresIn: number = 3600) {
    // Generate signed URL with expiration
  }
}
```

### 2. Videos Service

```typescript
// videos.service.ts
@Injectable()
export class VideosService {
  constructor(
    private cloudflareStream: CloudflareStreamService,
    private videoAssetRepo: Repository<VideoAsset>,
  ) {}

  async initUpload(dto: InitUploadDto) {
    // 1. Validate file
    // 2. Call Cloudflare init
    // 3. Return upload URL
  }

  async completeUpload(dto: CompleteUploadDto) {
    // 1. Get asset details from Cloudflare
    // 2. Save to database
    // 3. Link to MenuItem
    // 4. Return video asset
  }
}
```

---

## 🔄 Workflow الكامل

### 1. Upload Flow

```
Client → POST /videos/upload/init
  ↓
Backend → Cloudflare API (init upload)
  ↓
Backend → Return upload URL
  ↓
Client → Upload video to Cloudflare
  ↓
Cloudflare → Process video
  ↓
Client → POST /videos/upload/complete
  ↓
Backend → Get asset details from Cloudflare
  ↓
Backend → Save to database
  ↓
Backend → Link to MenuItem
```

### 2. Playback Flow

```
Client → GET /feed (or /menu/:id)
  ↓
Backend → Get MenuItems with VideoAssets
  ↓
Backend → Generate signed URLs (if needed)
  ↓
Backend → Return feed with signed URLs
  ↓
Client → Play video from signed URL
```

---

## 🔐 Security Best Practices

### 1. Signed URLs
- ✅ كل playback URL مؤقت (1-24 ساعة)
- ✅ Token-based access
- ✅ IP whitelist (اختياري)

### 2. Access Control
- ✅ Unlisted videos only
- ✅ Domain restrictions
- ✅ Rate limiting

### 3. API Security
- ✅ API Token في environment variables
- ✅ لا تعرض Token في logs
- ✅ HTTPS فقط

---

## 📊 Monitoring

### Metrics to Track
- ✅ Upload success rate
- ✅ Processing time
- ✅ Playback errors
- ✅ Bandwidth usage

### Alerts
- ✅ Failed uploads
- ✅ Processing delays
- ✅ High error rate

---

## ✅ Checklist

- [ ] حساب Cloudflare Pro أو أعلى
- [ ] تفعيل Stream
- [ ] إنشاء API Token
- [ ] إعداد VideosModule
- [ ] ربط VideoAsset بـ MenuItem
- [ ] تنفيذ /upload/init
- [ ] تنفيذ /upload/complete
- [ ] Signed URLs implementation
- [ ] Error handling
- [ ] Monitoring setup

---

## 🎯 التوصيات

1. **استخدم Unlisted + Signed URLs** ✅
2. **احفظ VideoAsset في قاعدة البيانات** ✅
3. **ربط واضح بـ MenuItem** ✅
4. **Error handling شامل** ✅
5. **Monitoring و Alerts** ✅
