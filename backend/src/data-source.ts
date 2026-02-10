import 'dotenv/config';
import { DataSource } from 'typeorm';

const dbUrl = process.env.DATABASE_URL?.trim();

export default new DataSource({
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
  synchronize: false,
  logging: process.env.NODE_ENV === 'development',
  entities: [__dirname + '/../**/*.entity{.ts,.js}'],
  migrations: [__dirname + '/../migrations/*{.ts,.js}'],
  migrationsTableName: 'migrations',
});
