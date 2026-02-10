/**
 * Run from backend folder: npm run create-admin
 * Creates admin_roles and admin_users tables if missing (synchronize), seeds default roles, then creates first admin user.
 * Uses DATABASE_URL if set (e.g. from Render), otherwise DATABASE_HOST/PORT/USER/PASSWORD/NAME from .env
 */
import 'dotenv/config';
import { DataSource } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { AdminRole } from '../entities/admin-role.entity';
import { AdminUser } from '../entities/admin-user.entity';

const DEFAULT_EMAIL = 'admin@platform.com';
const DEFAULT_PASSWORD = 'Admin@123';
const SALT_ROUNDS = 10;

const DEFAULT_ROLES = [
  { name: 'Super Admin', slug: 'super_admin' },
  { name: 'Operations', slug: 'ops' },
  { name: 'Finance', slug: 'finance' },
  { name: 'Support', slug: 'support' },
  { name: 'Quality', slug: 'quality' },
];

async function run() {
  const dbUrl = process.env.DATABASE_URL?.trim();
  const dataSource = new DataSource({
    type: 'postgres',
    ...(dbUrl
      ? { url: dbUrl, ssl: { rejectUnauthorized: false } }
      : {
          host: process.env.DATABASE_HOST || 'localhost',
          port: Number(process.env.DATABASE_PORT ?? 5432),
          username: process.env.DATABASE_USER || 'postgres',
          password: process.env.DATABASE_PASSWORD || undefined,
          database: process.env.DATABASE_NAME || 'customer_app',
        }),
    entities: [AdminRole, AdminUser],
    synchronize: true,
  });

  await dataSource.initialize();
  const roleRepo = dataSource.getRepository(AdminRole);
  const userRepo = dataSource.getRepository(AdminUser);

  let superAdminRole = await roleRepo.findOne({
    where: { slug: 'super_admin' },
  });
  if (!superAdminRole) {
    await roleRepo.insert(DEFAULT_ROLES);
    superAdminRole = await roleRepo.findOne({
      where: { slug: 'super_admin' },
    });
    if (!superAdminRole) {
      console.error('Failed to create default roles.');
      await dataSource.destroy();
      process.exit(1);
    }
    console.log('Created default admin roles.');
  }

  const existing = await userRepo.findOne({ where: { email: DEFAULT_EMAIL } });
  if (existing) {
    console.log('Admin user already exists:', DEFAULT_EMAIL);
    await dataSource.destroy();
    process.exit(0);
    return;
  }

  const passwordHash = await bcrypt.hash(DEFAULT_PASSWORD, SALT_ROUNDS);
  await userRepo.insert({
    email: DEFAULT_EMAIL,
    passwordHash,
    roleId: superAdminRole.id,
    name: 'Super Admin',
    isActive: true,
  });

  console.log('Created admin user:', DEFAULT_EMAIL, '(password:', DEFAULT_PASSWORD + ')');
  await dataSource.destroy();
  process.exit(0);
}

run().catch((err) => {
  console.error(err);
  process.exit(1);
});
