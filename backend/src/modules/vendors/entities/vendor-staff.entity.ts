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
import { StaffRole } from '../enums';

@Entity('vendor_staff')
export class VendorStaff {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'vendor_id' })
  vendorId: string;

  @Column({ name: 'user_id', unique: true })
  userId: string; // Reference to User entity

  @Column({ type: 'enum', enum: StaffRole })
  role: StaffRole;

  @Column({ name: 'permissions', type: 'simple-array', nullable: true })
  permissions: string[]; // Array of permission strings

  @Column({ default: true, name: 'is_active' })
  isActive: boolean;

  @Column({ name: 'invited_by', nullable: true })
  invitedBy: string | null; // Staff ID who invited

  @Column({ name: 'invited_at', nullable: true, type: 'timestamp' })
  invitedAt: Date | null;

  @Column({ name: 'accepted_at', nullable: true, type: 'timestamp' })
  acceptedAt: Date | null;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Relations
  @ManyToOne(() => Vendor, (vendor) => vendor.staff, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'vendor_id' })
  vendor: Vendor;
}
