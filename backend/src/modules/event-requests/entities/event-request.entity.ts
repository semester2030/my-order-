import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Vendor } from '../../vendors/entities/vendor.entity';
import { Address } from '../../addresses/entities/address.entity';

export enum EventRequestType {
  POPULAR_COOKING = 'popular_cooking',
  HOME_COOKING = 'home_cooking',
}

export enum EventRequestStatus {
  PENDING = 'pending',
  ACCEPTED = 'accepted',
  REJECTED = 'rejected',
  CANCELLED = 'cancelled',
}

@Entity('event_requests')
export class EventRequest {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id' })
  userId: string;

  @Column({ name: 'vendor_id' })
  vendorId: string;

  @Column({ name: 'address_id', nullable: true })
  addressId: string | null;

  @Column({
    type: 'enum',
    enum: EventRequestType,
    name: 'request_type',
  })
  requestType: EventRequestType;

  @Column({ type: 'date', name: 'scheduled_date' })
  scheduledDate: string;

  @Column({ type: 'time', name: 'scheduled_time' })
  scheduledTime: string;

  @Column({ default: 1, name: 'guests_count' })
  guestsCount: number;

  /** للطبخ الشعبي: [{name, price?}] */
  @Column({ type: 'jsonb', nullable: true, name: 'add_ons' })
  addOns: { name: string; price?: number }[] | null;

  /** للطبخ المنزلي: معرّفات الأطباق المختارة */
  @Column({ type: 'jsonb', nullable: true, name: 'dish_ids' })
  dishIds: string[] | null;

  /** للطبخ المنزلي: true = توصيل، false = استلام */
  @Column({ default: false, nullable: true })
  delivery: boolean | null;

  @Column({ type: 'text', nullable: true })
  notes: string | null;

  @Column({
    type: 'enum',
    enum: EventRequestStatus,
    default: EventRequestStatus.PENDING,
  })
  status: EventRequestStatus;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @ManyToOne(() => User)
  @JoinColumn({ name: 'user_id' })
  user: User;

  @ManyToOne(() => Vendor)
  @JoinColumn({ name: 'vendor_id' })
  vendor: Vendor;

  @ManyToOne(() => Address, { nullable: true })
  @JoinColumn({ name: 'address_id' })
  address: Address | null;
}
