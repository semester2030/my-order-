import {
  Column,
  CreateDateColumn,
  Entity,
  JoinColumn,
  ManyToOne,
  PrimaryGeneratedColumn,
  UpdateDateColumn,
} from 'typeorm';
import { Vendor } from '../../vendors/entities/vendor.entity';

/** حالة توثيق مقدّم الخدمة لاستلام التحويلات — توسّع لاحقاً مع KYC من الـ PSP */
export enum VendorPayoutProfileStatus {
  UNVERIFIED = 'unverified',
  PENDING_KYC = 'pending_kyc',
  VERIFIED = 'verified',
  SUSPENDED = 'suspended',
}

/**
 * ملف مالي لكل مقدّم خدمة — ربط لاحق بـ connected account عند PSP.
 * الآيبان الأساسي يبقى على جدول vendors؛ هنا مرجع التوثيق والمزوّد فقط.
 */
@Entity('vendor_payout_profiles')
export class VendorPayoutProfile {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'vendor_id', type: 'uuid', unique: true })
  vendorId: string;

  @ManyToOne(() => Vendor, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'vendor_id' })
  vendor: Vendor;

  @Column({
    type: 'enum',
    enum: VendorPayoutProfileStatus,
    enumName: 'vendor_payout_profile_status_enum',
    name: 'verification_status',
    default: VendorPayoutProfileStatus.UNVERIFIED,
  })
  verificationStatus: VendorPayoutProfileStatus;

  /** معرّف الحساب المرتبط عند PSP (Stripe Connect account id, …) */
  @Column({
    name: 'external_connected_account_id',
    type: 'varchar',
    length: 255,
    nullable: true,
  })
  externalConnectedAccountId: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;
}
