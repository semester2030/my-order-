import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToOne,
  JoinColumn,
  OneToMany,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Order } from '../../orders/entities/order.entity';
import {
  DriverStatus,
  LicenseType,
  VehicleType,
  VerificationStatus,
} from '../enums/driver-status.enum';

@Entity('drivers')
export class Driver {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  // User relation
  @OneToOne(() => User, { cascade: true })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @Column({ name: 'user_id', unique: true })
  userId: string;

  // Personal Identity
  @Column({ name: 'full_name', nullable: true })
  fullName: string | null;

  @Column({ name: 'national_id', unique: true })
  nationalId: string;

  @Column({ name: 'date_of_birth', type: 'date', nullable: true })
  dateOfBirth: Date | null;

  @Column({ type: 'enum', enum: ['male', 'female'], nullable: true })
  gender: 'male' | 'female' | null;

  @Column({ nullable: true })
  nationality: string | null;

  // Driver License
  @Column({ name: 'license_number', unique: true, nullable: true })
  licenseNumber: string | null;

  @Column({
    name: 'license_type',
    type: 'enum',
    enum: LicenseType,
    nullable: true,
  })
  licenseType: LicenseType | null;

  @Column({ name: 'license_issue_date', type: 'date', nullable: true })
  licenseIssueDate: Date | null;

  @Column({ name: 'license_expiry_date', type: 'date', nullable: true })
  licenseExpiryDate: Date | null;

  @Column({ name: 'license_issuing_authority', nullable: true })
  licenseIssuingAuthority: string | null;

  @Column({ name: 'license_photo_front', type: 'text', nullable: true })
  licensePhotoFront: string | null;

  @Column({ name: 'license_photo_back', type: 'text', nullable: true })
  licensePhotoBack: string | null;

  // Vehicle Information
  @Column({
    name: 'vehicle_type',
    type: 'enum',
    enum: VehicleType,
    nullable: true,
  })
  vehicleType: VehicleType | null;

  @Column({ name: 'vehicle_make', nullable: true })
  vehicleMake: string | null;

  @Column({ name: 'vehicle_model', nullable: true })
  vehicleModel: string | null;

  @Column({ name: 'vehicle_year', type: 'int', nullable: true })
  vehicleYear: number | null;

  @Column({ name: 'vehicle_color', nullable: true })
  vehicleColor: string | null;

  @Column({ name: 'plate_number', unique: true, nullable: true })
  plateNumber: string | null;

  @Column({ name: 'plate_region', nullable: true })
  plateRegion: string | null;

  @Column({ name: 'vehicle_registration_number', nullable: true })
  vehicleRegistrationNumber: string | null;

  @Column({ name: 'vehicle_registration_expiry', type: 'date', nullable: true })
  vehicleRegistrationExpiry: Date | null;

  @Column({ name: 'vehicle_photo', type: 'text', nullable: true })
  vehiclePhoto: string | null;

  @Column({ name: 'vehicle_authorization_photo', type: 'text', nullable: true })
  vehicleAuthorizationPhoto: string | null; // For lease/rental

  // Insurance
  @Column({ name: 'insurance_company', nullable: true })
  insuranceCompany: string | null;

  @Column({ name: 'insurance_policy_number', nullable: true })
  insurancePolicyNumber: string | null;

  @Column({ name: 'insurance_start_date', type: 'date', nullable: true })
  insuranceStartDate: Date | null;

  @Column({ name: 'insurance_expiry_date', type: 'date', nullable: true })
  insuranceExpiryDate: Date | null;

  @Column({ name: 'insurance_coverage_type', nullable: true })
  insuranceCoverageType: string | null;

  @Column({ name: 'insurance_photo', type: 'text', nullable: true })
  insurancePhoto: string | null;

  // Contact
  @Column({ name: 'phone_number' })
  phoneNumber: string;

  @Column({ nullable: true })
  email: string | null;

  @Column({ name: 'emergency_contact_name', nullable: true })
  emergencyContactName: string | null;

  @Column({ name: 'emergency_contact_phone', nullable: true })
  emergencyContactPhone: string | null;

  @Column('jsonb', { nullable: true })
  address: {
    street: string;
    city: string;
    region: string;
    postalCode?: string;
  } | null;

  // Banking
  @Column({ name: 'bank_name', nullable: true })
  bankName: string | null;

  @Column({ name: 'account_number', nullable: true })
  accountNumber: string | null;

  @Column({ name: 'account_holder_name', nullable: true })
  accountHolderName: string | null;

  @Column({ nullable: true })
  iban: string | null;

  @Column({ name: 'swift_code', nullable: true })
  swiftCode: string | null;

  // Health (Optional)
  @Column({ name: 'has_medical_conditions', default: false })
  hasMedicalConditions: boolean;

  @Column('simple-array', { nullable: true, name: 'medical_conditions' })
  medicalConditions: string[] | null;

  @Column({ name: 'blood_type', nullable: true })
  bloodType: string | null;

  @Column('simple-array', { nullable: true })
  allergies: string[] | null;

  // Legal Consents
  @Column({ name: 'terms_and_conditions_accepted', default: false })
  termsAndConditionsAccepted: boolean;

  @Column({ name: 'terms_accepted_at', type: 'timestamp', nullable: true })
  termsAcceptedAt: Date | null;

  @Column({ name: 'privacy_policy_accepted', default: false })
  privacyPolicyAccepted: boolean;

  @Column({ name: 'privacy_accepted_at', type: 'timestamp', nullable: true })
  privacyAcceptedAt: Date | null;

  @Column({ name: 'background_check_consent', default: false })
  backgroundCheckConsent: boolean;

  @Column({ name: 'location_tracking_consent', default: false })
  locationTrackingConsent: boolean;

  @Column({ name: 'data_processing_consent', default: false })
  dataProcessingConsent: boolean;

  // Verification
  @Column({ name: 'identity_verified', default: false })
  identityVerified: boolean;

  @Column({ name: 'identity_verified_at', type: 'timestamp', nullable: true })
  identityVerifiedAt: Date | null;

  @Column({ name: 'identity_verified_by', nullable: true })
  identityVerifiedBy: string | null;

  @Column({ name: 'identity_rejection_reason', type: 'text', nullable: true })
  identityRejectionReason: string | null;

  @Column({ name: 'license_verified', default: false })
  licenseVerified: boolean;

  @Column({ name: 'license_verified_at', type: 'timestamp', nullable: true })
  licenseVerifiedAt: Date | null;

  @Column({ name: 'license_rejection_reason', type: 'text', nullable: true })
  licenseRejectionReason: string | null;

  @Column({ name: 'vehicle_verified', default: false })
  vehicleVerified: boolean;

  @Column({ name: 'vehicle_verified_at', type: 'timestamp', nullable: true })
  vehicleVerifiedAt: Date | null;

  @Column({ name: 'vehicle_rejection_reason', type: 'text', nullable: true })
  vehicleRejectionReason: string | null;

  @Column({ name: 'insurance_verified', default: false })
  insuranceVerified: boolean;

  @Column({ name: 'insurance_verified_at', type: 'timestamp', nullable: true })
  insuranceVerifiedAt: Date | null;

  @Column({ name: 'insurance_rejection_reason', type: 'text', nullable: true })
  insuranceRejectionReason: string | null;

  @Column({ name: 'background_check_passed', default: false })
  backgroundCheckPassed: boolean;

  @Column({ name: 'background_check_date', type: 'timestamp', nullable: true })
  backgroundCheckDate: Date | null;

  // Status
  @Column({
    type: 'enum',
    enum: DriverStatus,
    default: DriverStatus.PENDING,
  })
  status: DriverStatus;

  @Column({ name: 'rejection_reason', type: 'text', nullable: true })
  rejectionReason: string | null;

  // Availability
  @Column({ name: 'is_online', default: false })
  isOnline: boolean;

  @Column({ name: 'last_online_at', type: 'timestamp', nullable: true })
  lastOnlineAt: Date | null;

  // Location (current)
  @Column('decimal', {
    precision: 10,
    scale: 8,
    nullable: true,
    name: 'current_latitude',
  })
  currentLatitude: number | null;

  @Column('decimal', {
    precision: 11,
    scale: 8,
    nullable: true,
    name: 'current_longitude',
  })
  currentLongitude: number | null;

  @Column({ name: 'last_location_update', type: 'timestamp', nullable: true })
  lastLocationUpdate: Date | null;

  // FCM Token for push notifications
  @Column({ name: 'fcm_token', nullable: true })
  fcmToken: string | null;

  // Profile
  @Column({ name: 'profile_photo', type: 'text', nullable: true })
  profilePhoto: string | null;

  @Column('simple-array', { nullable: true })
  languages: string[] | null;

  @Column({ name: 'experience_years', type: 'int', nullable: true })
  experienceYears: number | null;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Relations
  @OneToMany(() => Order, (order) => order.driver)
  orders: Order[];
}
