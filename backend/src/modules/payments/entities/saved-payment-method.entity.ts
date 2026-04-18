import {
  Column,
  CreateDateColumn,
  Entity,
  PrimaryGeneratedColumn,
} from 'typeorm';

@Entity('saved_payment_methods')
export class SavedPaymentMethod {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ name: 'user_id', type: 'uuid' })
  userId: string;

  /** حالياً دائماً mada — جاهز لتوسيع لاحقاً */
  @Column({ type: 'varchar', length: 32, default: 'mada' })
  brand: string;

  /** مرجع المزوّد (mock أو Stripe payment_method إلخ) */
  @Column({ name: 'gateway_payment_method_id', type: 'varchar', length: 255 })
  gatewayPaymentMethodId: string;

  @Column({ type: 'char', length: 4 })
  last4: string;

  @Column({ name: 'exp_month', type: 'smallint' })
  expMonth: number;

  @Column({ name: 'exp_year', type: 'smallint' })
  expYear: number;

  @Column({ name: 'holder_name', type: 'varchar', length: 200 })
  holderName: string;

  @CreateDateColumn({ name: 'created_at', type: 'timestamptz' })
  createdAt: Date;
}
