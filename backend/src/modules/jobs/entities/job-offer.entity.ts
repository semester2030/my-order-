import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { Order } from '../../orders/entities/order.entity';
import { Driver } from '../../drivers/entities/driver.entity';

export enum JobStatus {
  PENDING = 'pending', // Available for drivers
  ACCEPTED = 'accepted', // Accepted by a driver
  REJECTED = 'rejected', // Rejected by driver
  EXPIRED = 'expired', // Expired (no driver accepted in time)
  CANCELLED = 'cancelled', // Cancelled by system/vendor
}

@Entity('job_offers')
export class JobOffer {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'order_id', unique: true })
  orderId: string;

  @Column({
    type: 'enum',
    enum: JobStatus,
    default: JobStatus.PENDING,
  })
  status: JobStatus;

  @Column({ name: 'accepted_by_driver_id', nullable: true })
  acceptedByDriverId: string | null;

  @Column({ name: 'expires_at', type: 'timestamp' })
  expiresAt: Date; // Job expires if not accepted

  @Column({ name: 'accepted_at', type: 'timestamp', nullable: true })
  acceptedAt: Date | null;

  @Column({ name: 'rejected_at', type: 'timestamp', nullable: true })
  rejectedAt: Date | null;

  @Column('decimal', {
    precision: 10,
    scale: 2,
    name: 'delivery_fee',
  })
  deliveryFee: number;

  @Column('decimal', {
    precision: 10,
    scale: 2,
    name: 'driver_earnings',
  })
  driverEarnings: number;

  @Column('decimal', {
    precision: 10,
    scale: 8,
    name: 'pickup_latitude',
  })
  pickupLatitude: number;

  @Column('decimal', {
    precision: 11,
    scale: 8,
    name: 'pickup_longitude',
  })
  pickupLongitude: number;

  @Column('decimal', {
    precision: 10,
    scale: 8,
    name: 'delivery_latitude',
  })
  deliveryLatitude: number;

  @Column('decimal', {
    precision: 11,
    scale: 8,
    name: 'delivery_longitude',
  })
  deliveryLongitude: number;

  @Column({ name: 'estimated_distance', type: 'decimal', precision: 10, scale: 2 })
  estimatedDistance: number; // in kilometers

  @Column({ name: 'estimated_duration', type: 'int' })
  estimatedDuration: number; // in minutes

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Relations
  @ManyToOne(() => Order, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'order_id' })
  order: Order;

  @ManyToOne(() => Driver, { nullable: true })
  @JoinColumn({ name: 'accepted_by_driver_id' })
  acceptedByDriver: Driver | null;
}
