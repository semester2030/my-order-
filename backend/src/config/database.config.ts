import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';

interface ParsedDbUrl {
  host?: string;
  port?: number;
  username?: string;
  password?: string;
  database?: string;
}

/** يفضّل استخدام DATABASE_URL على المنصات السحابية (Render, Railway, إلخ). */
function parseDatabaseUrl(url: string): ParsedDbUrl {
  try {
    const u = new URL(url);
    const database = u.pathname.replace(/^\//, '') || 'customer_app';
    return {
      host: u.hostname,
      port: parseInt(u.port || '5432', 10),
      username: u.username,
      password: u.password,
      database: database,
    };
  } catch {
    return {};
  }
}

export const getDatabaseConfig = (
  configService: ConfigService,
): TypeOrmModuleOptions => {
  const url = configService.get<string>('DATABASE_URL');
  const fromUrl = url ? parseDatabaseUrl(url) : {};
  const database =
    (fromUrl.database ?? configService.get<string>('DATABASE_NAME', 'customer_app')) as string;
  return {
    type: 'postgres',
    host: fromUrl.host ?? configService.get<string>('DATABASE_HOST', 'localhost'),
    port: fromUrl.port ?? configService.get<number>('DATABASE_PORT', 5432),
    username: fromUrl.username ?? configService.get<string>('DATABASE_USER', 'postgres'),
    password: fromUrl.password ?? configService.get<string>('DATABASE_PASSWORD', 'password'),
    database,
    entities: [__dirname + '/../**/*.entity{.ts,.js}'],
    migrations: [__dirname + '/../migrations/*{.ts,.js}'],
    migrationsTableName: 'migrations',
    synchronize: configService.get<string>('NODE_ENV') === 'development',
    logging: configService.get<string>('NODE_ENV') === 'development',
  };
};
