import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Vendor } from '../../vendors/entities/vendor.entity';

export const EVENT_SERVICE_TYPES = [
  'buffet',
  'desserts',
  'drinks',
  'staff',
] as const;
export const EVENT_TYPES = [
  'wedding',
  'graduation',
  'henna',
  'engagement',
  'other',
] as const;

@Entity('event_offers')
export class EventOffer {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'vendor_id' })
  vendorId: string;

  @Column({ name: 'service_type' })
  serviceType: string; // buffet, desserts, drinks, staff

  @Column({ name: 'event_type' })
  eventType: string; // wedding, graduation, henna, engagement, other

  @Column({ nullable: true })
  title: string | null;

  @Column({ type: 'text', nullable: true })
  description: string | null;

  @Column({
    name: 'price_per_person',
    type: 'decimal',
    precision: 10,
    scale: 2,
    nullable: true,
  })
  pricePerPerson: number | null;

  @Column({
    name: 'price_total',
    type: 'decimal',
    precision: 10,
    scale: 2,
    nullable: true,
  })
  priceTotal: number | null;

  @Column({ name: 'min_guests', default: 1 })
  minGuests: number;

  @Column({ name: 'max_guests', type: 'int', nullable: true })
  maxGuests: number | null;

  @Column({ name: 'is_active', default: true })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  @ManyToOne(() => Vendor)
  @JoinColumn({ name: 'vendor_id' })
  vendor: Vendor;
}
