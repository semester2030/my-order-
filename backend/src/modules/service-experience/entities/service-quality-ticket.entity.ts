import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Vendor } from '../../vendors/entities/vendor.entity';
import {
  ServiceReviewSubjectType,
  QualityTicketStatus,
} from '../service-experience.constants';

@Entity('service_quality_tickets')
@Index('IDX_service_quality_tickets_status_created', ['status', 'createdAt'])
export class ServiceQualityTicket {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'subject_type', type: 'varchar', length: 32 })
  subjectType: ServiceReviewSubjectType;

  @Column({ name: 'subject_id', type: 'uuid' })
  subjectId: string;

  @Column({ name: 'customer_user_id', type: 'uuid' })
  customerUserId: string;

  @Column({ name: 'vendor_id', type: 'uuid' })
  vendorId: string;

  @Column({ type: 'varchar', length: 64 })
  category: string;

  @Column({ name: 'private_message', type: 'text' })
  privateMessage: string;

  @Column({ name: 'detail_scores', type: 'jsonb', nullable: true })
  detailScores: Record<string, number> | null;

  @Column({
    type: 'varchar',
    length: 32,
    default: QualityTicketStatus.OPEN,
  })
  status: QualityTicketStatus;

  @Column({ name: 'admin_notes', type: 'text', nullable: true })
  adminNotes: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at', type: 'timestamptz' })
  updatedAt: Date;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'customer_user_id' })
  customer: User;

  @ManyToOne(() => Vendor, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'vendor_id' })
  vendor: Vendor;
}
