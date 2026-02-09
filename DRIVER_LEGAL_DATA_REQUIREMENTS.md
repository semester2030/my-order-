# 📋 Driver Legal Data Requirements - البيانات القانونية المطلوبة من السائق

**التاريخ:** 25 يناير 2026  
**الهدف:** تحديد البيانات القانونية المطلوبة من السائق للامتثال القانوني

---

## 🎯 **نظرة عامة**

لضمان الامتثال القانوني في المملكة العربية السعودية (أو أي دولة أخرى)، يجب جمع البيانات التالية من السائق:

---

## 📋 **البيانات القانونية المطلوبة**

### 🔴 **1. بيانات الهوية الشخصية (Personal Identity)** - إلزامي

#### **أ) معلومات أساسية:**
```typescript
{
  fullName: string;              // ✅ الاسم الكامل (من الهوية الوطنية)
  nationalId: string;            // ✅ رقم الهوية الوطنية (10 أرقام)
  dateOfBirth: Date;             // ✅ تاريخ الميلاد
  gender: 'male' | 'female';     // ✅ الجنس
  nationality: string;           // ✅ الجنسية (سعودي / غير سعودي)
}
```

**لماذا إلزامي:**
- ✅ **الهوية الوطنية** - مطلوب قانونياً للتحقق من الهوية
- ✅ **تاريخ الميلاد** - للتحقق من العمر (يجب أن يكون 18+)
- ✅ **الجنسية** - قد تختلف المتطلبات حسب الجنسية

---

### 🔴 **2. بيانات الرخصة (Driver License)** - إلزامي

#### **أ) معلومات الرخصة:**
```typescript
{
  licenseNumber: string;          // ✅ رقم الرخصة
  licenseType: string;           // ✅ نوع الرخصة (خاص / عام / نقل)
  licenseIssueDate: Date;        // ✅ تاريخ الإصدار
  licenseExpiryDate: Date;       // ✅ تاريخ الانتهاء
  licenseIssuingAuthority: string; // ✅ الجهة المصدرة (إدارة المرور)
  licensePhoto: string;          // ✅ صورة الرخصة (front + back)
}
```

**لماذا إلزامي:**
- ✅ **التحقق القانوني** - يجب التحقق من صحة الرخصة
- ✅ **تاريخ الانتهاء** - يجب التحقق من عدم انتهاء الرخصة
- ✅ **نوع الرخصة** - يجب أن تكون مناسبة (نقل للبضائع)

---

### 🔴 **3. بيانات المركبة (Vehicle Information)** - إلزامي

#### **أ) معلومات المركبة:**
```typescript
{
  vehicleType: 'motorcycle' | 'car' | 'van' | 'truck'; // ✅ نوع المركبة
  vehicleMake: string;            // ✅ الشركة المصنعة (تويوتا، هوندا، إلخ)
  vehicleModel: string;           // ✅ الموديل
  vehicleYear: number;            // ✅ سنة الصنع
  vehicleColor: string;           // ✅ لون المركبة
  plateNumber: string;           // ✅ رقم اللوحة
  plateRegion: string;           // ✅ منطقة اللوحة (الرياض، جدة، إلخ)
  vehicleRegistrationNumber: string; // ✅ رقم تسجيل المركبة
  vehicleRegistrationExpiry: Date;  // ✅ تاريخ انتهاء التسجيل
  vehiclePhoto: string;          // ✅ صورة المركبة (front + side)
}
```

**لماذا إلزامي:**
- ✅ **التحقق من المركبة** - يجب التحقق من صحة المركبة
- ✅ **رقم اللوحة** - للتعريف بالمركبة
- ✅ **تاريخ انتهاء التسجيل** - يجب التحقق من عدم انتهاء التسجيل

---

### 🔴 **4. بيانات التأمين (Insurance Information)** - إلزامي

#### **أ) معلومات التأمين:**
```typescript
{
  insuranceCompany: string;       // ✅ شركة التأمين
  insurancePolicyNumber: string;  // ✅ رقم وثيقة التأمين
  insuranceStartDate: Date;       // ✅ تاريخ بداية التأمين
  insuranceExpiryDate: Date;      // ✅ تاريخ انتهاء التأمين
  insuranceCoverageType: string;  // ✅ نوع التغطية (تأمين شامل / ثالث)
  insurancePhoto: string;         // ✅ صورة وثيقة التأمين
}
```

**لماذا إلزامي:**
- ✅ **الامتثال القانوني** - التأمين إلزامي قانونياً
- ✅ **الحماية** - حماية السائق والعملاء
- ✅ **تاريخ الانتهاء** - يجب التحقق من عدم انتهاء التأمين

---

### 🟡 **5. بيانات الاتصال (Contact Information)** - إلزامي

#### **أ) معلومات الاتصال:**
```typescript
{
  phoneNumber: string;            // ✅ رقم الجوال (للتحقق)
  email?: string;                // ⚠️ البريد الإلكتروني (اختياري)
  emergencyContactName: string;  // ✅ اسم جهة الاتصال في الطوارئ
  emergencyContactPhone: string; // ✅ رقم جهة الاتصال في الطوارئ
  address: {                     // ✅ العنوان
    street: string;
    city: string;
    region: string;
    postalCode?: string;
  };
}
```

**لماذا إلزامي:**
- ✅ **الاتصال** - للتواصل مع السائق
- ✅ **الطوارئ** - للاتصال في حالات الطوارئ
- ✅ **العنوان** - للتحقق من العنوان

---

### 🟡 **6. بيانات البنك (Banking Information)** - إلزامي للدفع

#### **أ) معلومات البنك:**
```typescript
{
  bankName: string;              // ✅ اسم البنك
  accountNumber: string;         // ✅ رقم الحساب
  accountHolderName: string;     // ✅ اسم صاحب الحساب
  iban?: string;                 // ⚠️ IBAN (إن وجد)
  swiftCode?: string;            // ⚠️ SWIFT Code (إن وجد)
}
```

**لماذا إلزامي:**
- ✅ **الدفع** - لدفع الأرباح للسائق
- ✅ **التحقق** - للتحقق من صحة الحساب

---

### 🟢 **7. بيانات صحية (Health Information)** - اختياري (موصى به)

#### **أ) معلومات صحية:**
```typescript
{
  hasMedicalConditions: boolean;  // ⚠️ هل لديه حالات صحية؟
  medicalConditions?: string[];  // ⚠️ الحالات الصحية (إن وجدت)
  bloodType?: string;            // ⚠️ فصيلة الدم (للطوارئ)
  allergies?: string[];          // ⚠️ الحساسيات (إن وجدت)
}
```

**لماذا موصى به:**
- ⚠️ **الطوارئ** - للاستجابة في حالات الطوارئ
- ⚠️ **الصحة** - لضمان سلامة السائق

---

### 🔴 **8. موافقات قانونية (Legal Consents)** - إلزامي

#### **أ) الموافقات:**
```typescript
{
  termsAndConditionsAccepted: boolean;  // ✅ الموافقة على الشروط والأحكام
  termsAcceptedAt: Date;               // ✅ تاريخ الموافقة
  privacyPolicyAccepted: boolean;      // ✅ الموافقة على سياسة الخصوصية
  privacyAcceptedAt: Date;              // ✅ تاريخ الموافقة
  backgroundCheckConsent: boolean;     // ✅ الموافقة على فحص الخلفية
  locationTrackingConsent: boolean;    // ✅ الموافقة على تتبع الموقع
  dataProcessingConsent: boolean;       // ✅ الموافقة على معالجة البيانات
}
```

**لماذا إلزامي:**
- ✅ **الامتثال القانوني** - مطلوب قانونياً (GDPR, CCPA, إلخ)
- ✅ **الشفافية** - يجب إعلام السائق بما يتم جمعه
- ✅ **الموافقة** - يجب الحصول على موافقة صريحة

---

### 🔴 **9. بيانات التحقق (Verification Data)** - إلزامي

#### **أ) معلومات التحقق:**
```typescript
{
  identityVerified: boolean;     // ✅ تم التحقق من الهوية
  identityVerifiedAt?: Date;     // ✅ تاريخ التحقق
  identityVerifiedBy?: string;   // ✅ من قام بالتحقق
  licenseVerified: boolean;      // ✅ تم التحقق من الرخصة
  licenseVerifiedAt?: Date;       // ✅ تاريخ التحقق
  vehicleVerified: boolean;       // ✅ تم التحقق من المركبة
  vehicleVerifiedAt?: Date;      // ✅ تاريخ التحقق
  insuranceVerified: boolean;     // ✅ تم التحقق من التأمين
  insuranceVerifiedAt?: Date;     // ✅ تاريخ التحقق
  backgroundCheckPassed: boolean; // ✅ تم اجتياز فحص الخلفية
  backgroundCheckDate?: Date;     // ✅ تاريخ فحص الخلفية
  status: 'pending' | 'approved' | 'rejected' | 'suspended'; // ✅ الحالة
}
```

**لماذا إلزامي:**
- ✅ **التحقق** - يجب التحقق من جميع البيانات
- ✅ **الأمان** - لضمان أمان المنصة
- ✅ **المسؤولية** - لتحديد المسؤولية

---

### 🟡 **10. بيانات إضافية (Additional Data)** - موصى به

#### **أ) معلومات إضافية:**
```typescript
{
  profilePhoto: string;           // ⚠️ صورة شخصية
  languages: string[];            // ⚠️ اللغات المتحدثة (عربي، إنجليزي)
  experienceYears: number;        // ⚠️ سنوات الخبرة
  previousEmployer?: string;     // ⚠️ صاحب العمل السابق
  references?: {                  // ⚠️ المراجع
    name: string;
    phone: string;
    relationship: string;
  }[];
}
```

**لماذا موصى به:**
- ⚠️ **التحقق** - للتحقق من الخبرة
- ⚠️ **المراجع** - للتحقق من السجل

---

## 📊 **ملخص البيانات المطلوبة**

| Category | Required? | Priority | Notes |
|----------|----------|----------|-------|
| **Personal Identity** | ✅ Yes | 🔴 Critical | الهوية الوطنية، تاريخ الميلاد |
| **Driver License** | ✅ Yes | 🔴 Critical | رقم الرخصة، تاريخ الانتهاء |
| **Vehicle Information** | ✅ Yes | 🔴 Critical | رقم اللوحة، نوع المركبة |
| **Insurance** | ✅ Yes | 🔴 Critical | وثيقة التأمين، تاريخ الانتهاء |
| **Contact Information** | ✅ Yes | 🔴 Critical | رقم الجوال، جهة الاتصال |
| **Banking Information** | ✅ Yes | 🟡 High | للدفع |
| **Health Information** | ⚠️ Optional | 🟢 Low | موصى به |
| **Legal Consents** | ✅ Yes | 🔴 Critical | الموافقات القانونية |
| **Verification Data** | ✅ Yes | 🔴 Critical | التحقق من البيانات |
| **Additional Data** | ⚠️ Optional | 🟢 Low | موصى به |

---

## 🗄️ **Database Schema Proposal**

### **Driver Entity:**
```typescript
@Entity('drivers')
export class Driver {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  // User relation
  @OneToOne(() => User, { cascade: true })
  @JoinColumn()
  user: User;

  // Personal Identity
  @Column()
  fullName: string;

  @Column({ unique: true })
  nationalId: string;

  @Column()
  dateOfBirth: Date;

  @Column()
  gender: 'male' | 'female';

  @Column()
  nationality: string;

  // Driver License
  @Column({ unique: true })
  licenseNumber: string;

  @Column()
  licenseType: string;

  @Column()
  licenseIssueDate: Date;

  @Column()
  licenseExpiryDate: Date;

  @Column()
  licenseIssuingAuthority: string;

  @Column('text', { nullable: true })
  licensePhotoFront: string;

  @Column('text', { nullable: true })
  licensePhotoBack: string;

  // Vehicle Information
  @Column()
  vehicleType: string;

  @Column()
  vehicleMake: string;

  @Column()
  vehicleModel: string;

  @Column()
  vehicleYear: number;

  @Column()
  vehicleColor: string;

  @Column({ unique: true })
  plateNumber: string;

  @Column()
  plateRegion: string;

  @Column()
  vehicleRegistrationNumber: string;

  @Column()
  vehicleRegistrationExpiry: Date;

  @Column('text', { nullable: true })
  vehiclePhoto: string;

  // Insurance
  @Column()
  insuranceCompany: string;

  @Column()
  insurancePolicyNumber: string;

  @Column()
  insuranceStartDate: Date;

  @Column()
  insuranceExpiryDate: Date;

  @Column()
  insuranceCoverageType: string;

  @Column('text', { nullable: true })
  insurancePhoto: string;

  // Contact
  @Column()
  phoneNumber: string;

  @Column({ nullable: true })
  email: string;

  @Column()
  emergencyContactName: string;

  @Column()
  emergencyContactPhone: string;

  @Column('json')
  address: {
    street: string;
    city: string;
    region: string;
    postalCode?: string;
  };

  // Banking
  @Column()
  bankName: string;

  @Column()
  accountNumber: string;

  @Column()
  accountHolderName: string;

  @Column({ nullable: true })
  iban: string;

  @Column({ nullable: true })
  swiftCode: string;

  // Health (Optional)
  @Column({ default: false })
  hasMedicalConditions: boolean;

  @Column('json', { nullable: true })
  medicalConditions: string[];

  @Column({ nullable: true })
  bloodType: string;

  @Column('json', { nullable: true })
  allergies: string[];

  // Legal Consents
  @Column({ default: false })
  termsAndConditionsAccepted: boolean;

  @Column({ nullable: true })
  termsAcceptedAt: Date;

  @Column({ default: false })
  privacyPolicyAccepted: boolean;

  @Column({ nullable: true })
  privacyAcceptedAt: Date;

  @Column({ default: false })
  backgroundCheckConsent: boolean;

  @Column({ default: false })
  locationTrackingConsent: boolean;

  @Column({ default: false })
  dataProcessingConsent: boolean;

  // Verification
  @Column({ default: false })
  identityVerified: boolean;

  @Column({ nullable: true })
  identityVerifiedAt: Date;

  @Column({ nullable: true })
  identityVerifiedBy: string;

  @Column({ default: false })
  licenseVerified: boolean;

  @Column({ nullable: true })
  licenseVerifiedAt: Date;

  @Column({ default: false })
  vehicleVerified: boolean;

  @Column({ nullable: true })
  vehicleVerifiedAt: Date;

  @Column({ default: false })
  insuranceVerified: boolean;

  @Column({ nullable: true })
  insuranceVerifiedAt: Date;

  @Column({ default: false })
  backgroundCheckPassed: boolean;

  @Column({ nullable: true })
  backgroundCheckDate: Date;

  @Column({ default: 'pending' })
  status: 'pending' | 'approved' | 'rejected' | 'suspended';

  // Timestamps
  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
```

---

## 🔒 **Security & Privacy Considerations**

### **1. Data Encryption:**
- ✅ **Sensitive Data** - تشفير البيانات الحساسة (nationalId, licenseNumber, accountNumber)
- ✅ **Photos** - تخزين الصور بشكل آمن (S3, Cloud Storage)

### **2. Data Access:**
- ✅ **Role-Based Access** - فقط Admin يمكنه رؤية جميع البيانات
- ✅ **Driver Access** - السائق يمكنه رؤية بياناته فقط

### **3. Data Retention:**
- ✅ **Retention Policy** - تحديد مدة الاحتفاظ بالبيانات
- ✅ **Deletion** - إمكانية حذف البيانات عند الطلب (GDPR)

### **4. Compliance:**
- ✅ **GDPR** - الامتثال لـ GDPR (إن كان مطبقاً)
- ✅ **Local Laws** - الامتثال للقوانين المحلية

---

## 📋 **Registration Flow**

### **Step 1: Basic Information**
1. ✅ Full Name
2. ✅ National ID
3. ✅ Date of Birth
4. ✅ Phone Number

### **Step 2: Driver License**
1. ✅ License Number
2. ✅ License Type
3. ✅ License Photos (Front + Back)
4. ✅ Expiry Date

### **Step 3: Vehicle Information**
1. ✅ Vehicle Type
2. ✅ Plate Number
3. ✅ Vehicle Photos
4. ✅ Registration Expiry

### **Step 4: Insurance**
1. ✅ Insurance Company
2. ✅ Policy Number
3. ✅ Insurance Photo
4. ✅ Expiry Date

### **Step 5: Banking**
1. ✅ Bank Name
2. ✅ Account Number
3. ✅ Account Holder Name

### **Step 6: Legal Consents**
1. ✅ Terms & Conditions
2. ✅ Privacy Policy
3. ✅ Background Check Consent
4. ✅ Location Tracking Consent

### **Step 7: Verification (Admin)**
1. ✅ Identity Verification
2. ✅ License Verification
3. ✅ Vehicle Verification
4. ✅ Insurance Verification
5. ✅ Background Check

---

## 🎯 **الخلاصة**

### ✅ **البيانات الإلزامية:**
1. ✅ **Personal Identity** - الهوية الوطنية، تاريخ الميلاد
2. ✅ **Driver License** - رقم الرخصة، تاريخ الانتهاء
3. ✅ **Vehicle Information** - رقم اللوحة، نوع المركبة
4. ✅ **Insurance** - وثيقة التأمين، تاريخ الانتهاء
5. ✅ **Contact Information** - رقم الجوال، جهة الاتصال
6. ✅ **Banking Information** - للدفع
7. ✅ **Legal Consents** - الموافقات القانونية
8. ✅ **Verification Data** - التحقق من البيانات

### ⚠️ **البيانات الاختيارية (موصى بها):**
1. ⚠️ **Health Information** - للطوارئ
2. ⚠️ **Additional Data** - المراجع، الخبرة

---

**هذه هي البيانات القانونية المطلوبة للامتثال القانوني!** ✅
