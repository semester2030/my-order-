import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
} from 'typeorm';
import { MenuItem } from '../../menu/entities/menu-item.entity';
import { Order } from '../../orders/entities/order.entity';
import { VendorCertificate } from './vendor-certificate.entity';
import { VendorStaff } from './vendor-staff.entity';
import { VendorStatus, VerificationStatus } from '../enums';

export enum VendorType {
  FINE_DINING = 'fine_dining',
  PREMIUM_CASUAL = 'premium_casual',
  GOURMET_DESSERTS = 'gourmet_desserts',
}

@Entity('vendors')
export class Vendor {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  // Basic Information
  @Column({ unique: true })
  name: string;

  @Column({ name: 'trade_name', unique: true, nullable: true })
  tradeName: string | null;

  @Column({ type: 'enum', enum: VendorType, default: VendorType.PREMIUM_CASUAL })
  type: VendorType;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Column({ unique: true })
  email: string;

  @Column({ name: 'phone_number' })
  phoneNumber: string;

  @Column({ nullable: true })
  website: string | null;

  // Commercial Registration
  @Column({ name: 'commercial_registration_number', unique: true, nullable: true })
  commercialRegistrationNumber: string | null;

  @Column({ name: 'commercial_registration_issue_date', type: 'date', nullable: true })
  commercialRegistrationIssueDate: Date | null;

  @Column({ name: 'commercial_registration_expiry_date', type: 'date', nullable: true })
  commercialRegistrationExpiryDate: Date | null;

  @Column({ name: 'commercial_registration_image', nullable: true })
  commercialRegistrationImage: string | null;

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
  district: string | null;

  @Column({ name: 'postal_code', nullable: true })
  postalCode: string | null;

  // Delivery
  @Column('simple-array', { nullable: true, name: 'delivery_zones' })
  deliveryZones: string[] | null; // Array of zone IDs

  @Column('decimal', { precision: 10, scale: 2, default: 0, name: 'delivery_fee' })
  deliveryFee: number;

  @Column({ name: 'delivery_radius', type: 'int', default: 10 })
  deliveryRadius: number; // in kilometers

  @Column({ name: 'estimated_delivery_time', type: 'int', default: 30 })
  estimatedDeliveryTime: number; // in minutes

  // Owner Information
  @Column({ name: 'owner_name' })
  ownerName: string;

  @Column({ name: 'owner_phone' })
  ownerPhone: string;

  @Column({ name: 'owner_email' })
  ownerEmail: string;

  @Column({ name: 'owner_id_number', unique: true })
  ownerIdNumber: string;

  @Column({ name: 'owner_id_image' })
  ownerIdImage: string;

  @Column({ name: 'owner_nationality', nullable: true })
  ownerNationality: string | null;

  @Column({ name: 'owner_address', nullable: true, type: 'text' })
  ownerAddress: string | null;

  // Banking Information
  @Column({ name: 'bank_name', nullable: true })
  bankName: string | null;

  @Column({ name: 'bank_account_number', nullable: true })
  bankAccountNumber: string | null;

  @Column({ nullable: true })
  iban: string | null;

  @Column({ name: 'account_holder_name', nullable: true })
  accountHolderName: string | null;

  @Column({ name: 'bank_statement', nullable: true })
  bankStatement: string | null;

  @Column({ name: 'swift_code', nullable: true })
  swiftCode: string | null;

  // Media
  @Column({ nullable: true })
  logo: string | null;

  @Column({ nullable: true })
  cover: string | null;

  @Column('simple-array', { nullable: true, name: 'restaurant_images' })
  restaurantImages: string[] | null;

  @Column({ name: 'restaurant_video', nullable: true })
  restaurantVideo: string | null;

  // Working Hours (stored as JSON)
  @Column({ name: 'working_hours', type: 'jsonb', nullable: true })
  workingHours: {
    day: string;
    open: string;
    close: string;
    isOpen: boolean;
  }[] | null;

  // Status
  @Column({
    type: 'enum',
    enum: VendorStatus,
    default: VendorStatus.PENDING_APPROVAL,
    name: 'registration_status',
  })
  registrationStatus: VendorStatus;

  @Column({ default: false, name: 'is_active' })
  isActive: boolean;

  @Column({ default: false, name: 'is_accepting_orders' })
  isAcceptingOrders: boolean;

  @Column({ name: 'provider_category', nullable: true })
  providerCategory: string | null;

  /** للطبخ الشعبي: خدمات إضافية (جريش، قرصان، ادامات…) — JSON: [{ name, price }] */
  @Column({ name: 'popular_cooking_add_ons', type: 'jsonb', nullable: true })
  popularCookingAddOns: { name: string; price: number }[] | null;

  // Ratings
  @Column('decimal', { precision: 3, scale: 2, default: 0, name: 'rating' })
  rating: number;

  @Column({ default: 0, name: 'rating_count' })
  ratingCount: number;

  // Approval
  @Column({ name: 'approved_at', nullable: true, type: 'timestamp' })
  approvedAt: Date | null;

  @Column({ name: 'approved_by', nullable: true })
  approvedBy: string | null; // Admin ID

  @Column({ name: 'rejection_reason', nullable: true, type: 'text' })
  rejectionReason: string | null;

  // Timestamps
  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Relations
  @OneToMany(() => MenuItem, (menuItem) => menuItem.vendor)
  menuItems: MenuItem[];

  @OneToMany(() => Order, (order) => order.vendor)
  orders: Order[];

  @OneToMany(() => VendorCertificate, (certificate) => certificate.vendor)
  certificates: VendorCertificate[];

  @OneToMany(() => VendorStaff, (staff) => staff.vendor)
  staff: VendorStaff[];
}
