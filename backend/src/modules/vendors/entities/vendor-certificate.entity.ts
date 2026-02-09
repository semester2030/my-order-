import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Vendor } from './vendor.entity';
import { CertificateType, VerificationStatus } from '../enums';

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

  @Column({ name: 'verified_at', nullable: true, type: 'timestamp' })
  verifiedAt: Date | null;

  @Column({ name: 'verified_by', nullable: true })
  verifiedBy: string | null; // Admin ID

  @Column({ name: 'rejection_reason', nullable: true, type: 'text' })
  rejectionReason: string | null;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Relations
  @ManyToOne(() => Vendor, (vendor) => vendor.certificates, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'vendor_id' })
  vendor: Vendor;
}
