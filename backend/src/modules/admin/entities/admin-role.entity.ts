import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  OneToMany,
} from 'typeorm';
import { AdminUser } from './admin-user.entity';

@Entity('admin_roles')
export class AdminRole {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true, length: 100 })
  name: string;

  /** slug: super_admin | ops | finance | support | quality */
  @Column({ unique: true, length: 50 })
  slug: string;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @OneToMany(() => AdminUser, (admin) => admin.role)
  admins: AdminUser[];
}
