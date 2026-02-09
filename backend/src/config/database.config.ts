import { TypeOrmModuleOptions } from '@nestjs/typeorm';
import { ConfigService } from '@nestjs/config';

/** يفضّل استخدام DATABASE_URL على المنصات السحابية (Render, Railway, إلخ). */
function parseDatabaseUrl(url: string): Partial<TypeOrmModuleOptions> {
  try {
    const u = new URL(url);
    return {
      host: u.hostname,
      port: parseInt(u.port || '5432', 10),
      username: u.username,
      password: u.password,
      database: u.pathname.replace(/^\//, '') || 'customer_app',
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
  return {
    type: 'postgres',
    host: fromUrl.host ?? configService.get<string>('DATABASE_HOST', 'localhost'),
    port: fromUrl.port ?? configService.get<number>('DATABASE_PORT', 5432),
    username: fromUrl.username ?? configService.get<string>('DATABASE_USER', 'postgres'),
    password: fromUrl.password ?? configService.get<string>('DATABASE_PASSWORD', 'password'),
    database: fromUrl.database ?? configService.get<string>('DATABASE_NAME', 'customer_app'),
    entities: [__dirname + '/../**/*.entity{.ts,.js}'],
    synchronize: configService.get<string>('NODE_ENV') === 'development',
    logging: configService.get<string>('NODE_ENV') === 'development',
  };
};
