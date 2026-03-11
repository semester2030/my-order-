import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Vendor } from '../../vendors/entities/vendor.entity';
import { Address } from '../../addresses/entities/address.entity';

export type PrivateEventRequestService = {
  serviceType: string; // buffet, desserts, drinks, staff
  guestsCount: number;
  notes?: string;
};

@Entity('private_event_requests')
export class PrivateEventRequest {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id' })
  userId: string;

  @Column({ name: 'vendor_id' })
  vendorId: string;

  @Column({ name: 'address_id', nullable: true })
  addressId: string | null;

  @Column({ name: 'event_type' })
  eventType: string; // wedding, graduation, henna, engagement, other

  @Column({ name: 'event_date', type: 'date' })
  eventDate: string;

  @Column({ name: 'event_time', type: 'time' })
  eventTime: string;

  @Column({ name: 'guests_count', default: 1 })
  guestsCount: number;

  @Column({ type: 'jsonb' })
  services: PrivateEventRequestService[];

  @Column({ type: 'text', nullable: true })
  notes: string | null;

  @Column({ default: 'pending' })
  status: string; // pending, accepted, rejected, cancelled

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

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
