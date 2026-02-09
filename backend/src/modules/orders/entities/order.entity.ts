import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  OneToMany,
} from 'typeorm';
import { User } from '../../users/entities/user.entity';
import { Vendor } from '../../vendors/entities/vendor.entity';
import { Address } from '../../addresses/entities/address.entity';
import { Driver } from '../../drivers/entities/driver.entity';
import { OrderItem } from './order-item.entity';
import { Payment } from '../../payments/entities/payment.entity';

export enum OrderStatus {
  PENDING = 'pending',
  CONFIRMED = 'confirmed',
  PREPARING = 'preparing',
  READY = 'ready',
  OUT_FOR_DELIVERY = 'out_for_delivery',
  DELIVERED = 'delivered',
  CANCELLED = 'cancelled',
}

@Entity('orders')
export class Order {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id' })
  userId: string;

  @Column({ name: 'vendor_id' })
  vendorId: string;

  @Column({ name: 'address_id' })
  addressId: string;

  @Column({ unique: true, name: 'order_number' })
  orderNumber: string; // e.g., ORD-2024-001

  @Column({
    type: 'enum',
    enum: OrderStatus,
    default: OrderStatus.PENDING,
  })
  status: OrderStatus;

  @Column('decimal', { precision: 10, scale: 2, name: 'subtotal' })
  subtotal: number;

  @Column('decimal', {
    precision: 10,
    scale: 2,
    default: 0,
    name: 'delivery_fee',
  })
  deliveryFee: number;

  @Column('decimal', { precision: 10, scale: 2 })
  total: number;

  @Column({ nullable: true, name: 'estimated_delivery_time' })
  estimatedDeliveryTime: Date;

  @Column({ nullable: true, name: 'delivered_at' })
  deliveredAt: Date;

  @Column({ nullable: true, name: 'driver_id' })
  driverId: string;

  @Column('decimal', {
    precision: 10,
    scale: 8,
    nullable: true,
    name: 'driver_latitude',
  })
  driverLatitude: number;

  @Column('decimal', {
    precision: 11,
    scale: 8,
    nullable: true,
    name: 'driver_longitude',
  })
  driverLongitude: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Relations
  @ManyToOne(() => User, (user) => user.orders, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;

  @ManyToOne(() => Vendor, (vendor) => vendor.orders)
  @JoinColumn({ name: 'vendor_id' })
  vendor: Vendor;

  @ManyToOne(() => Address, { onDelete: 'SET NULL' })
  @JoinColumn({ name: 'address_id' })
  address: Address;

  @ManyToOne(() => Driver, { nullable: true })
  @JoinColumn({ name: 'driver_id' })
  driver: Driver | null;

  @OneToMany(() => OrderItem, (orderItem) => orderItem.order, { cascade: true })
  items: OrderItem[];

  @OneToMany(() => Payment, (payment) => payment.order)
  payments: Payment[];
}
