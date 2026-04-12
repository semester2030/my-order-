import { NestFactory } from '@nestjs/core';
import { ValidationPipe, RequestMethod } from '@nestjs/common';
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { DataSource } from 'typeorm';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Run pending migrations on startup (no Shell or local run needed on Render)
  try {
    const dataSource = app.get(DataSource);
    const pending = await dataSource.showMigrations();
    if (pending) {
      await dataSource.runMigrations();
      console.log('Migrations completed.');
    }
  } catch (err: any) {
    console.error('Migrations failed:', err?.message ?? err);
    throw err;
  }

  // Set global prefix for all routes; exclude root GET so / returns health
  app.setGlobalPrefix('api', {
    exclude: [{ path: '', method: RequestMethod.GET }],
  });

  // Global validation pipe
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      forbidNonWhitelisted: true,
      transform: true,
    }),
  );

  // CORS — يدعم لوحة الإدارة على منفذ آخر + طلبات مع credentials عند الحاجة
  const corsOrigins = process.env.CORS_ORIGINS?.split(',')
    .map((s) => s.trim())
    .filter(Boolean);
  app.enableCors({
    origin: corsOrigins?.length ? corsOrigins : true,
    credentials: true,
    methods: ['GET', 'HEAD', 'PUT', 'PATCH', 'POST', 'DELETE', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
  });

  // Swagger documentation
  const config = new DocumentBuilder()
    .setTitle('My Order API')
    .setDescription(
      'واجهات تطبيق العملاء ومقدّمي الخدمة: طبّاخ منزلي، طبخ ذبائح، شواء خارجي، المناسبات والحفلات (بوفيه وولائم). (لا يوجد نموذج «مطعم» في المنتج.)',
    )
    .setVersion('1.0')
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  const port = process.env.PORT || 3001;
  await app.listen(port);
  console.log(`Application is running on: http://localhost:${port}`);
  console.log(`API endpoints available at: http://localhost:${port}/api`);
  console.log(
    `📧 Email (Resend): ${process.env.RESEND_API_KEY ? 'CONFIGURED' : 'NOT CONFIGURED - set RESEND_API_KEY'}`,
  );
}

bootstrap();
