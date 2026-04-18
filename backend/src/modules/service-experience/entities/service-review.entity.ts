import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
  Unique,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Vendor } from '../../vendors/entities/vendor.entity';
import { ServiceReviewSubjectType } from '../service-experience.constants';

@Entity('service_reviews')
@Unique('UQ_service_reviews_subject_customer', [
  'subjectType',
  'subjectId',
  'customerUserId',
])
@Index('IDX_service_reviews_vendor_created', ['vendorId', 'createdAt'])
export class ServiceReview {
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

  @Column({ type: 'smallint' })
  stars: number;

  @Column({ name: 'public_comment', type: 'text', nullable: true })
  publicComment: string | null;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;

  @ManyToOne(() => User, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'customer_user_id' })
  customer: User;

  @ManyToOne(() => Vendor, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'vendor_id' })
  vendor: Vendor;
}
