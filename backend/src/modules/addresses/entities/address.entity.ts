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

@Entity('addresses')
export class Address {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id' })
  userId: string;

  @Column()
  label: string; // Home, Work, etc.

  @Column({ name: 'street_address' })
  streetAddress: string;

  @Column({ nullable: true })
  building: string;

  @Column({ nullable: true })
  floor: string;

  @Column({ nullable: true })
  apartment: string;

  @Column()
  city: string;

  @Column({ nullable: true })
  district: string;

  @Column({ name: 'postal_code', nullable: true })
  postalCode: string;

  @Column('decimal', { precision: 10, scale: 8, name: 'latitude' })
  latitude: number;

  @Column('decimal', { precision: 11, scale: 8, name: 'longitude' })
  longitude: number;

  @Column({ default: false, name: 'is_default' })
  isDefault: boolean;

  @Column({ default: true, name: 'is_active' })
  isActive: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Relations
  @ManyToOne(() => User, (user) => user.addresses, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'user_id' })
  user: User;
}
