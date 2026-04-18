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
import { Vendor } from '../../vendors/entities/vendor.entity';
import { VideoAsset } from './video-asset.entity';
import { CartItem } from '../../cart/entities/cart-item.entity';
import { OrderItem } from '../../orders/entities/order-item.entity';

@Entity('menu_items')
export class MenuItem {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'vendor_id' })
  vendorId: string;

  @Column()
  name: string;

  @Column({ nullable: true })
  description: string;

  /** null = بدون سعر معروض (مطبخ منزلي — التسعير عند الطلب/التفاوض) */
  @Column('decimal', { precision: 10, scale: 2, nullable: true })
  price: number | null;

  @Column({ nullable: true })
  image: string;

  @Column({ default: false, name: 'is_signature' })
  isSignature: boolean;

  @Column({ default: true, name: 'is_available' })
  isAvailable: boolean;

  /** طبخ منزلي: عنصر عرض/إعلان تعريفي — الصورة اختيارية عند الإنشاء */
  @Column({ default: false, name: 'profile_promo' })
  profilePromo: boolean;

  @Column({ default: 0, name: 'order_count' })
  orderCount: number;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;

  // Relations
  @ManyToOne(() => Vendor, (vendor) => vendor.menuItems, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'vendor_id' })
  vendor: Vendor;

  @OneToMany(() => VideoAsset, (videoAsset) => videoAsset.menuItem)
  videoAssets: VideoAsset[];

  @OneToMany(() => CartItem, (cartItem) => cartItem.menuItem)
  cartItems: CartItem[];

  @OneToMany(() => OrderItem, (orderItem) => orderItem.menuItem)
  orderItems: OrderItem[];
}
