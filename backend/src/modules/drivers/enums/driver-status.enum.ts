export enum DriverStatus {
  PENDING = 'pending', // Application submitted
  UNDER_REVIEW = 'under_review', // Documents being reviewed
  DOCUMENTS_REQUESTED = 'documents_requested', // Additional documents needed
  APPROVED = 'approved', // Approved and active
  REJECTED = 'rejected', // Application rejected
  SUSPENDED = 'suspended', // Temporarily suspended
  INACTIVE = 'inactive', // Driver inactive
}

export enum LicenseType {
  PRIVATE = 'private', // خاص
  PUBLIC = 'public', // عام
  TRANSPORT = 'transport', // نقل
}

export enum VehicleType {
  MOTORCYCLE = 'motorcycle', // دراجة نارية
  CAR = 'car', // سيارة
  VAN = 'van', // فان
  TRUCK = 'truck', // شاحنة
}

export enum VerificationStatus {
  PENDING = 'pending',
  VERIFIED = 'verified',
  REJECTED = 'rejected',
}
