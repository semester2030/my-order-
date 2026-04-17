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
  /** شواء خارجي عند العميل — نفس متطلبات العنوان كالطبخ الميداني */
  GRILLING = 'grilling',
}

export enum EventRequestStatus {
  PENDING = 'pending',
  /** طبخ منزلي: المطبخ أرسل سعراً وانتظر إجراء العميل/الدفع */
  QUOTED = 'quoted',
  /** طبخ منزلي: العميل أعلن التحويل — بانتظار تحقق الإدارة */
  PAYMENT_PENDING = 'payment_pending',
  /** طبخ منزلي: بعد التحقق من الدفع — قيد التحضير (أو كاش عند الاستلام حسب السياسة) */
  ACCEPTED = 'accepted',
  /** طبخ منزلي: جاهز للاستلام */
  READY = 'ready',
  /** طبخ منزلي: تم التسليم للعميل أو للوسيط (مندوب) — بانتظار تأكيد استلام العميل */
  HANDED_OVER = 'handed_over',
  /** طبخ منزلي: أكد العميل الاستلام وأُغلق الطلب */
  COMPLETED = 'completed',
  REJECTED = 'rejected',
  CANCELLED = 'cancelled',
}

/** وجبة حجز الولائم/الشوي: غداء أو عشاء فقط. للطبخ المنزلي: إفطار/غداء/عشاء كنافذة زمنية مرجعية. */
export enum ChefMealSlot {
  BREAKFAST = 'breakfast',
  LUNCH = 'lunch',
  DINNER = 'dinner',
}

/** أنواع طلبات الحجز التي تستخدم الوجبة + قيود التعارض */
export const CHEF_BOOKING_TYPES: EventRequestType[] = [
  EventRequestType.POPULAR_COOKING,
  EventRequestType.GRILLING,
];

export function isChefBookingType(t: EventRequestType): boolean {
  return CHEF_BOOKING_TYPES.includes(t);
}

/** وقت مرجعي لطبخ الذبائح/الشواء (النافذة الفعلية ثابتة في المنتج) */
export function scheduledTimeForChefMealSlot(slot: ChefMealSlot): string {
  if (slot === ChefMealSlot.LUNCH) return '10:00:00';
  return '16:00:00';
}

/** وقت مرجعي للطبخ المنزلي عند اختيار فطور/غداء/عشاء (يمكن للعميل أيضاً اختيار وقت حر) */
export function scheduledTimeForHomeCookingPresetSlot(slot: ChefMealSlot): string {
  switch (slot) {
    case ChefMealSlot.BREAKFAST:
      return '08:00:00';
    case ChefMealSlot.LUNCH:
      return '12:30:00';
    case ChefMealSlot.DINNER:
      return '19:00:00';
    default:
      return '12:30:00';
  }
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

  /** غداء/عشاء — لطبخ الذبائح والشواء فقط */
  @Column({
    type: 'enum',
    enum: ChefMealSlot,
    name: 'meal_slot',
    nullable: true,
  })
  mealSlot: ChefMealSlot | null;

  @Column({ default: 1, name: 'guests_count' })
  guestsCount: number;

  /** للطبخ الشعبي: [{name, price?}] */
  @Column({ type: 'jsonb', nullable: true, name: 'add_ons' })
  addOns: { name: string; price?: number }[] | null;

  /** للطبخ المنزلي: معرّفات الأطباق المختارة من القائمة */
  @Column({ type: 'jsonb', nullable: true, name: 'dish_ids' })
  dishIds: string[] | null;

  /** للطبخ المنزلي: أطباق مخصصة بنص حر (مثال: كبسة لحم، إدام، سلطة) */
  @Column({ type: 'text', nullable: true, name: 'custom_dish_names' })
  customDishNames: string | null;

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

  /** سعر عرض المطبخ المنزلي (ريال) */
  @Column({
    type: 'decimal',
    precision: 12,
    scale: 2,
    nullable: true,
    name: 'quoted_amount',
  })
  quotedAmount: string | null;

  @Column({ type: 'text', nullable: true, name: 'quote_notes' })
  quoteNotes: string | null;

  @Column({ name: 'quoted_at', type: 'timestamptz', nullable: true })
  quotedAt: Date | null;

  @Column({ type: 'text', nullable: true, name: 'payment_reference' })
  paymentReference: string | null;

  @Column({ name: 'payment_declared_at', type: 'timestamptz', nullable: true })
  paymentDeclaredAt: Date | null;

  @Column({ name: 'payment_verified_at', type: 'timestamptz', nullable: true })
  paymentVerifiedAt: Date | null;

  @Column({ name: 'payment_verified_by_admin_id', type: 'uuid', nullable: true })
  paymentVerifiedByAdminId: string | null;

  @Column({ name: 'ready_at', type: 'timestamptz', nullable: true })
  readyAt: Date | null;

  @Column({ name: 'handed_over_at', type: 'timestamptz', nullable: true })
  handedOverAt: Date | null;

  @Column({ type: 'text', nullable: true, name: 'handover_notes' })
  handoverNotes: string | null;

  @Column({ name: 'completed_at', type: 'timestamptz', nullable: true })
  completedAt: Date | null;

  /** رمز إتمام يظهر للعميل وللإدارة بعد تأكيد الاستلام (مثال: HC-260329-...) */
  @Column({
    type: 'varchar',
    length: 32,
    nullable: true,
    name: 'completion_certificate_code',
  })
  completionCertificateCode: string | null;

  /** آخر موعد لرد الطبّاخ (طبخ ذبائح / شواء فقط) — بعده يُلغى الطلب تلقائياً إن بقي pending */
  @Column({ name: 'respond_by', type: 'timestamptz', nullable: true })
  respondBy: Date | null;

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
