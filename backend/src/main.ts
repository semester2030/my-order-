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

  // CORS
  app.enableCors();

  // Swagger documentation
  const config = new DocumentBuilder()
    .setTitle('Customer API')
    .setDescription('Premium food delivery API')
    .setVersion('1.0')
    .addBearerAuth()
    .build();
  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  const port = process.env.PORT || 3001;
  await app.listen(port);
  console.log(`Application is running on: http://localhost:${port}`);
  console.log(`API endpoints available at: http://localhost:${port}/api`);
  console.log(`📧 Email (Resend): ${process.env.RESEND_API_KEY ? 'CONFIGURED' : 'NOT CONFIGURED - set RESEND_API_KEY'}`);
}

bootstrap();
