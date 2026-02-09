# 🏢 نظام تسجيل المطاعم (Vendor Registration System) - B2B

**التاريخ:** 25 يناير 2026  
**النوع:** Business-to-Business (B2B) Registration  
**الهدف:** تسجيل شامل وآمن للمطاعم الفاخرة مع جميع الوثائق المطلوبة

---

## 📋 **البيانات المطلوبة لتسجيل المطعم**

### **1. البيانات الأساسية (Basic Information)**
- ✅ **اسم المطعم** - Restaurant Name (Required)
- ✅ **الاسم التجاري** - Trade Name (Required)
- ✅ **نوع المطعم** - Restaurant Type (Fine Dining, Premium Casual, Gourmet Desserts)
- ✅ **الوصف** - Description (Rich Text)
- ✅ **رقم الهاتف** - Phone Number (Required)
- ✅ **البريد الإلكتروني** - Email (Required, Unique)
- ✅ **الموقع الإلكتروني** - Website (Optional)

---

### **2. بيانات السجل التجاري (Commercial Registration)**
- ✅ **رقم السجل التجاري** - Commercial Registration Number (Required, Unique)
- ✅ **تاريخ الإصدار** - Issue Date (Required)
- ✅ **تاريخ الانتهاء** - Expiry Date (Required)
- ✅ **صورة السجل التجاري** - Commercial Registration Image (Required, PDF/Image)
- ✅ **التحقق من السجل** - Verification Status (Pending, Verified, Rejected)

---

### **3. بيانات الموقع (Location Information)**
- ✅ **العنوان الكامل** - Full Address (Required)
- ✅ **المدينة** - City (Required)
- ✅ **المنطقة** - District (Required)
- ✅ **الرمز البريدي** - Postal Code (Optional)
- ✅ **الإحداثيات** - Coordinates (Latitude, Longitude) (Required)
- ✅ **خريطة الموقع** - Map Picker (Interactive)

---

### **4. الشهادات والتراخيص (Certificates & Licenses)**

#### **أ) شهادة الصحة (Health Certificate)**
- ✅ **رقم الشهادة** - Certificate Number (Required)
- ✅ **تاريخ الإصدار** - Issue Date (Required)
- ✅ **تاريخ الانتهاء** - Expiry Date (Required)
- ✅ **صورة الشهادة** - Certificate Image (Required, PDF/Image)
- ✅ **حالة التحقق** - Verification Status

#### **ب) رخصة البلدية (Municipal License)**
- ✅ **رقم الرخصة** - License Number (Required)
- ✅ **تاريخ الإصدار** - Issue Date (Required)
- ✅ **تاريخ الانتهاء** - Expiry Date (Required)
- ✅ **صورة الرخصة** - License Image (Required, PDF/Image)
- ✅ **حالة التحقق** - Verification Status

#### **ج) شهادة السلامة الغذائية (Food Safety Certificate)**
- ✅ **رقم الشهادة** - Certificate Number (Optional)
- ✅ **تاريخ الإصدار** - Issue Date (Optional)
- ✅ **تاريخ الانتهاء** - Expiry Date (Optional)
- ✅ **صورة الشهادة** - Certificate Image (Optional, PDF/Image)

#### **د) شهادات أخرى (Other Certificates)**
- ✅ **قائمة الشهادات** - Array of Certificates
- ✅ **نوع الشهادة** - Certificate Type
- ✅ **رقم الشهادة** - Certificate Number
- ✅ **التواريخ** - Issue/Expiry Dates
- ✅ **الصورة** - Certificate Image

---

### **5. بيانات الاتصال (Contact Information)**
- ✅ **المالك/المدير** - Owner/Manager Name (Required)
- ✅ **رقم هاتف المالك** - Owner Phone (Required)
- ✅ **بريد المالك** - Owner Email (Required)
- ✅ **رقم الهوية** - ID Number (Required)
- ✅ **صورة الهوية** - ID Image (Required, PDF/Image)

---

### **6. بيانات الحساب البنكي (Banking Information)**
- ✅ **اسم البنك** - Bank Name (Required)
- ✅ **رقم الحساب** - Account Number (Required)
- ✅ **IBAN** - IBAN Number (Required)
- ✅ **اسم صاحب الحساب** - Account Holder Name (Required)
- ✅ **صورة كشف الحساب** - Bank Statement (Optional, PDF/Image)

---

### **7. بيانات الدفع (Payment Information)**
- ✅ **طريقة الدفع المفضلة** - Preferred Payment Method
- ✅ **جدولة الدفع** - Payout Schedule (Weekly, Bi-weekly, Monthly)
- ✅ **نسبة العمولة** - Commission Rate (من النظام)

---

### **8. بيانات التوصيل (Delivery Information)**
- ✅ **مناطق التوصيل** - Delivery Zones (Array of Zones)
- ✅ **رسوم التوصيل** - Delivery Fee (Per Zone)
- ✅ **وقت التوصيل المتوقع** - Estimated Delivery Time
- ✅ **نطاق التوصيل** - Delivery Radius (KM)

---

### **9. بيانات الوسائط (Media Information)**
- ✅ **Logo** - Restaurant Logo (Required, Image)
- ✅ **Cover Image** - Cover Image (Required, Image)
- ✅ **صور المطعم** - Restaurant Images (Array, 3-10 images)
- ✅ **فيديو المطعم** - Restaurant Video (Optional)

---

### **10. بيانات الحساب (Account Information)**
- ✅ **اسم المستخدم** - Username (Required, Unique)
- ✅ **كلمة المرور** - Password (Required, Min 8 chars)
- ✅ **تأكيد كلمة المرور** - Confirm Password (Required)
- ✅ **موافقة على الشروط** - Terms & Conditions (Required, Checkbox)
- ✅ **موافقة على سياسة الخصوصية** - Privacy Policy (Required, Checkbox)

---

## 🏗️ **الهيكل في الباك إند**

### **1. Vendor Entity (تحديث)**

```typescript
// backend/src/modules/vendors/entities/vendor.entity.ts

@Entity('vendors')
export class Vendor {
  // Basic Info
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  name: string;

  @Column({ name: 'trade_name', unique: true })
  tradeName: string;

  @Column({ type: 'enum', enum: VendorType })
  type: VendorType;

  @Column({ type: 'text', nullable: true })
  description: string;

  @Column({ name: 'phone_number' })
  phoneNumber: string;

  @Column({ unique: true })
  email: string;

  @Column({ nullable: true })
  website: string;

  // Commercial Registration
  @Column({ name: 'commercial_registration_number', unique: true })
  commercialRegistrationNumber: string;

  @Column({ name: 'commercial_registration_issue_date', type: 'date' })
  commercialRegistrationIssueDate: Date;

  @Column({ name: 'commercial_registration_expiry_date', type: 'date' })
  commercialRegistrationExpiryDate: Date;

  @Column({ name: 'commercial_registration_image' })
  commercialRegistrationImage: string;

  @Column({
    type: 'enum',
    enum: VerificationStatus,
    default: VerificationStatus.PENDING,
    name: 'commercial_registration_status',
  })
  commercialRegistrationStatus: VerificationStatus;

  // Location
  @Column('decimal', { precision: 10, scale: 8 })
  latitude: number;

  @Column('decimal', { precision: 11, scale: 8 })
  longitude: number;

  @Column()
  address: string;

  @Column()
  city: string;

  @Column({ nullable: true })
  district: string;

  @Column({ name: 'postal_code', nullable: true })
  postalCode: string;

  // Certificates
  @Column({ name: 'health_certificate_number', nullable: true })
  healthCertificateNumber: string;

  @Column({ name: 'health_certificate_issue_date', type: 'date', nullable: true })
  healthCertificateIssueDate: Date;

  @Column({ name: 'health_certificate_expiry_date', type: 'date', nullable: true })
  healthCertificateExpiryDate: Date;

  @Column({ name: 'health_certificate_image', nullable: true })
  healthCertificateImage: string;

  @Column({
    type: 'enum',
    enum: VerificationStatus,
    default: VerificationStatus.PENDING,
    name: 'health_certificate_status',
  })
  healthCertificateStatus: VerificationStatus;

  @Column({ name: 'municipal_license_number', nullable: true })
  municipalLicenseNumber: string;

  @Column({ name: 'municipal_license_issue_date', type: 'date', nullable: true })
  municipalLicenseIssueDate: Date;

  @Column({ name: 'municipal_license_expiry_date', type: 'date', nullable: true })
  municipalLicenseExpiryDate: Date;

  @Column({ name: 'municipal_license_image', nullable: true })
  municipalLicenseImage: string;

  @Column({
    type: 'enum',
    enum: VerificationStatus,
    default: VerificationStatus.PENDING,
    name: 'municipal_license_status',
  })
  municipalLicenseStatus: VerificationStatus;

  // Contact Info
  @Column({ name: 'owner_name' })
  ownerName: string;

  @Column({ name: 'owner_phone' })
  ownerPhone: string;

  @Column({ name: 'owner_email' })
  ownerEmail: string;

  @Column({ name: 'owner_id_number' })
  ownerIdNumber: string;

  @Column({ name: 'owner_id_image' })
  ownerIdImage: string;

  // Banking
  @Column({ name: 'bank_name', nullable: true })
  bankName: string;

  @Column({ name: 'bank_account_number', nullable: true })
  bankAccountNumber: string;

  @Column({ nullable: true })
  iban: string;

  @Column({ name: 'account_holder_name', nullable: true })
  accountHolderName: string;

  // Media
  @Column({ nullable: true })
  logo: string;

  @Column({ nullable: true })
  cover: string;

  @Column('simple-array', { nullable: true, name: 'restaurant_images' })
  restaurantImages: string[];

  // Status
  @Column({
    type: 'enum',
    enum: VendorStatus,
    default: VendorStatus.PENDING_APPROVAL,
    name: 'registration_status',
  })
  registrationStatus: VendorStatus;

  @Column({ default: true, name: 'is_active' })
  isActive: boolean;

  @Column({ default: true, name: 'is_accepting_orders' })
  isAcceptingOrders: boolean;

  // Timestamps
  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @Column({ name: 'approved_at', nullable: true })
  approvedAt: Date;

  @Column({ name: 'approved_by', nullable: true })
  approvedBy: string; // Admin ID

  // Relations
  @OneToMany(() => MenuItem, (menuItem) => menuItem.vendor)
  menuItems: MenuItem[];

  @OneToMany(() => Order, (order) => order.vendor)
  orders: Order[];

  @OneToMany(() => VendorCertificate, (cert) => cert.vendor)
  certificates: VendorCertificate[];
}
```

---

### **2. Vendor Certificate Entity (جديد)**

```typescript
// backend/src/modules/vendors/entities/vendor-certificate.entity.ts

@Entity('vendor_certificates')
export class VendorCertificate {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'vendor_id' })
  vendorId: string;

  @Column({ type: 'enum', enum: CertificateType })
  type: CertificateType;

  @Column({ name: 'certificate_number' })
  certificateNumber: string;

  @Column({ name: 'issue_date', type: 'date' })
  issueDate: Date;

  @Column({ name: 'expiry_date', type: 'date' })
  expiryDate: Date;

  @Column({ name: 'certificate_image' })
  certificateImage: string;

  @Column({
    type: 'enum',
    enum: VerificationStatus,
    default: VerificationStatus.PENDING,
  })
  status: VerificationStatus;

  @Column({ name: 'verified_at', nullable: true })
  verifiedAt: Date;

  @Column({ name: 'verified_by', nullable: true })
  verifiedBy: string; // Admin ID

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @ManyToOne(() => Vendor, (vendor) => vendor.certificates)
  @JoinColumn({ name: 'vendor_id' })
  vendor: Vendor;
}
```

---

### **3. Enums**

```typescript
// backend/src/modules/vendors/enums/vendor-status.enum.ts

export enum VendorStatus {
  PENDING_APPROVAL = 'pending_approval',
  UNDER_REVIEW = 'under_review',
  APPROVED = 'approved',
  REJECTED = 'rejected',
  SUSPENDED = 'suspended',
}

// backend/src/modules/vendors/enums/verification-status.enum.ts

export enum VerificationStatus {
  PENDING = 'pending',
  VERIFIED = 'verified',
  REJECTED = 'rejected',
  EXPIRED = 'expired',
}

// backend/src/modules/vendors/enums/certificate-type.enum.ts

export enum CertificateType {
  HEALTH = 'health',
  MUNICIPAL = 'municipal',
  FOOD_SAFETY = 'food_safety',
  OTHER = 'other',
}
```

---

### **4. DTOs**

```typescript
// backend/src/modules/vendors/dto/register-vendor.dto.ts

export class RegisterVendorDto {
  // Basic Info
  @IsString()
  @IsNotEmpty()
  name: string;

  @IsString()
  @IsNotEmpty()
  tradeName: string;

  @IsEnum(VendorType)
  type: VendorType;

  @IsString()
  @IsOptional()
  description?: string;

  @IsString()
  @IsNotEmpty()
  @Matches(/^[0-9+\-\s()]+$/)
  phoneNumber: string;

  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsUrl()
  @IsOptional()
  website?: string;

  // Commercial Registration
  @IsString()
  @IsNotEmpty()
  commercialRegistrationNumber: string;

  @IsDateString()
  @IsNotEmpty()
  commercialRegistrationIssueDate: string;

  @IsDateString()
  @IsNotEmpty()
  commercialRegistrationExpiryDate: string;

  // Location
  @IsNumber()
  @IsNotEmpty()
  latitude: number;

  @IsNumber()
  @IsNotEmpty()
  longitude: number;

  @IsString()
  @IsNotEmpty()
  address: string;

  @IsString()
  @IsNotEmpty()
  city: string;

  @IsString()
  @IsOptional()
  district?: string;

  @IsString()
  @IsOptional()
  postalCode?: string;

  // Contact Info
  @IsString()
  @IsNotEmpty()
  ownerName: string;

  @IsString()
  @IsNotEmpty()
  ownerPhone: string;

  @IsEmail()
  @IsNotEmpty()
  ownerEmail: string;

  @IsString()
  @IsNotEmpty()
  ownerIdNumber: string;

  // Account
  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  username: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  password: string;

  @IsBoolean()
  @IsNotEmpty()
  @IsTrue()
  termsAccepted: boolean;

  @IsBoolean()
  @IsNotEmpty()
  @IsTrue()
  privacyAccepted: boolean;
}
```

---

### **5. Controller**

```typescript
// backend/src/modules/vendors/vendors.controller.ts

@Controller('vendors')
export class VendorsController {
  constructor(private readonly vendorsService: VendorsService) {}

  @Post('register')
  @ApiOperation({ summary: 'Register new vendor' })
  @UseInterceptors(FileFieldsInterceptor([
    { name: 'commercialRegistration', maxCount: 1 },
    { name: 'healthCertificate', maxCount: 1 },
    { name: 'municipalLicense', maxCount: 1 },
    { name: 'ownerId', maxCount: 1 },
    { name: 'logo', maxCount: 1 },
    { name: 'cover', maxCount: 1 },
    { name: 'restaurantImages', maxCount: 10 },
  ]))
  async register(
    @Body() dto: RegisterVendorDto,
    @UploadedFiles() files: {
      commercialRegistration?: Express.Multer.File[];
      healthCertificate?: Express.Multer.File[];
      municipalLicense?: Express.Multer.File[];
      ownerId?: Express.Multer.File[];
      logo?: Express.Multer.File[];
      cover?: Express.Multer.File[];
      restaurantImages?: Express.Multer.File[];
    },
  ) {
    return this.vendorsService.register(dto, files);
  }

  @Get('registration-status/:id')
  @ApiOperation({ summary: 'Check registration status' })
  async getRegistrationStatus(@Param('id') id: string) {
    return this.vendorsService.getRegistrationStatus(id);
  }
}
```

---

### **6. Service**

```typescript
// backend/src/modules/vendors/vendors.service.ts

@Injectable()
export class VendorsService {
  constructor(
    @InjectRepository(Vendor)
    private readonly vendorRepository: Repository<Vendor>,
    private readonly usersService: UsersService,
    private readonly fileUploadService: FileUploadService,
  ) {}

  async register(dto: RegisterVendorDto, files: any): Promise<Vendor> {
    // 1. Validate email uniqueness
    const existingVendor = await this.vendorRepository.findOne({
      where: { email: dto.email },
    });
    if (existingVendor) {
      throw new ConflictException('Email already registered');
    }

    // 2. Validate commercial registration number
    const existingReg = await this.vendorRepository.findOne({
      where: { commercialRegistrationNumber: dto.commercialRegistrationNumber },
    });
    if (existingReg) {
      throw new ConflictException('Commercial registration number already exists');
    }

    // 3. Upload files
    const uploadedFiles = await this.fileUploadService.uploadMultiple(files);

    // 4. Create vendor account
    const vendor = this.vendorRepository.create({
      ...dto,
      commercialRegistrationImage: uploadedFiles.commercialRegistration?.[0]?.path,
      healthCertificateImage: uploadedFiles.healthCertificate?.[0]?.path,
      municipalLicenseImage: uploadedFiles.municipalLicense?.[0]?.path,
      ownerIdImage: uploadedFiles.ownerId?.[0]?.path,
      logo: uploadedFiles.logo?.[0]?.path,
      cover: uploadedFiles.cover?.[0]?.path,
      restaurantImages: uploadedFiles.restaurantImages?.map(f => f.path),
      registrationStatus: VendorStatus.PENDING_APPROVAL,
    });

    const savedVendor = await this.vendorRepository.save(vendor);

    // 5. Create user account for vendor
    await this.usersService.createVendorUser({
      username: dto.username,
      email: dto.email,
      password: dto.password,
      vendorId: savedVendor.id,
      role: 'vendor',
    });

    // 6. Send notification to admin for review
    await this.notificationService.notifyAdminNewVendorRegistration(savedVendor);

    return savedVendor;
  }

  async getRegistrationStatus(vendorId: string) {
    const vendor = await this.vendorRepository.findOne({
      where: { id: vendorId },
      select: ['id', 'registrationStatus', 'createdAt', 'approvedAt'],
    });

    if (!vendor) {
      throw new NotFoundException('Vendor not found');
    }

    return {
      status: vendor.registrationStatus,
      submittedAt: vendor.createdAt,
      approvedAt: vendor.approvedAt,
      message: this.getStatusMessage(vendor.registrationStatus),
    };
  }

  private getStatusMessage(status: VendorStatus): string {
    const messages = {
      [VendorStatus.PENDING_APPROVAL]: 'Your registration is pending review. We will contact you soon.',
      [VendorStatus.UNDER_REVIEW]: 'Your registration is under review. Please wait for approval.',
      [VendorStatus.APPROVED]: 'Your registration has been approved. You can now log in.',
      [VendorStatus.REJECTED]: 'Your registration has been rejected. Please contact support.',
      [VendorStatus.SUSPENDED]: 'Your account has been suspended. Please contact support.',
    };
    return messages[status];
  }
}
```

---

## 🎨 **الهيكل في Frontend (Next.js)**

### **1. صفحة التسجيل (Registration Page)**
**Route:** `/register`

#### **البنية:**
```
register/
├── page.tsx                    # Main Registration Page
├── components/
│   ├── BasicInfoStep.tsx       # Step 1: Basic Information
│   ├── CommercialRegStep.tsx   # Step 2: Commercial Registration
│   ├── LocationStep.tsx         # Step 3: Location
│   ├── CertificatesStep.tsx    # Step 4: Certificates
│   ├── ContactInfoStep.tsx     # Step 5: Contact Information
│   ├── BankingStep.tsx         # Step 6: Banking
│   ├── MediaStep.tsx           # Step 7: Media
│   └── AccountStep.tsx         # Step 8: Account
└── hooks/
    └── useVendorRegistration.ts
```

#### **Multi-Step Form:**
- ✅ **Step 1:** Basic Information
- ✅ **Step 2:** Commercial Registration
- ✅ **Step 3:** Location (with Map)
- ✅ **Step 4:** Certificates
- ✅ **Step 5:** Contact Information
- ✅ **Step 6:** Banking Information
- ✅ **Step 7:** Media (Logo, Cover, Images)
- ✅ **Step 8:** Account (Username, Password)

#### **الميزات:**
- ✅ **Progress Bar** - شريط التقدم
- ✅ **Save Draft** - حفظ كمسودة
- ✅ **Validation** - التحقق من كل خطوة
- ✅ **File Upload** - رفع الملفات مع معاينة
- ✅ **Map Picker** - اختيار الموقع من الخريطة
- ✅ **Terms & Conditions** - الموافقة على الشروط

---

### **2. صفحة حالة التسجيل (Registration Status)**
**Route:** `/register/status`

#### **المحتوى:**
- ✅ **حالة التسجيل** - Status Badge
- ✅ **Timeline** - مراحل المراجعة
- ✅ **الوثائق المرفوعة** - Uploaded Documents
- ✅ **ملاحظات** - Admin Notes
- ✅ **Contact Support** - الاتصال بالدعم

---

### **3. صفحة إدارة الوثائق (Documents Management)**
**Route:** `/profile/documents`

#### **الوظائف:**
- ✅ **عرض جميع الوثائق** - View All Documents
- ✅ **رفع وثائق جديدة** - Upload New Documents
- ✅ **تحديث وثائق منتهية** - Update Expired Documents
- ✅ **حالة التحقق** - Verification Status
- ✅ **تنبيهات الانتهاء** - Expiry Alerts

---

## 🔐 **Workflow الموافقة (Approval Workflow)**

### **1. المراحل:**
1. **Pending Approval** - في انتظار المراجعة
2. **Under Review** - قيد المراجعة
3. **Approved** - موافق عليه
4. **Rejected** - مرفوض
5. **Suspended** - معلق

### **2. عملية المراجعة:**
- ✅ **Admin Review** - مراجعة من قبل الإدارة
- ✅ **Document Verification** - التحقق من الوثائق
- ✅ **Background Check** - فحص الخلفية
- ✅ **Approval/Rejection** - الموافقة/الرفض
- ✅ **Notification** - إشعار المطعم

---

## 📋 **Checklist للتنفيذ**

### **Backend:**
- [ ] تحديث Vendor Entity
- [ ] إنشاء VendorCertificate Entity
- [ ] إنشاء Enums (VendorStatus, VerificationStatus, CertificateType)
- [ ] إنشاء DTOs (RegisterVendorDto)
- [ ] تحديث VendorsController
- [ ] تحديث VendorsService
- [ ] إضافة File Upload Service
- [ ] إضافة Admin Approval Endpoints

### **Frontend:**
- [ ] صفحة التسجيل (Multi-step Form)
- [ ] صفحة حالة التسجيل
- [ ] صفحة إدارة الوثائق
- [ ] File Upload Components
- [ ] Map Picker Component
- [ ] Validation Logic

---

**التاريخ:** 25 يناير 2026  
**الحالة:** ✅ **COMPLETE REGISTRATION SYSTEM DESIGN**
