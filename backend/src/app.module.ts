import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { getDatabaseConfig } from './config/database.config.js';
import { AppController } from './app.controller';

// Modules
import { EmailModule } from './modules/email/email.module';
import { AuthModule } from './modules/auth/auth.module';
import { UsersModule } from './modules/users/users.module';
import { AddressesModule } from './modules/addresses/addresses.module';
import { VendorsModule } from './modules/vendors/vendors.module';
import { MenuModule } from './modules/menu/menu.module';
import { VideosModule } from './modules/videos/videos.module';
import { FeedModule } from './modules/feed/feed.module';
import { CartModule } from './modules/cart/cart.module';
import { OrdersModule } from './modules/orders/orders.module';
import { DeliveryModule } from './modules/delivery/delivery.module';
import { DriversModule } from './modules/drivers/drivers.module';
import { JobsModule } from './modules/jobs/jobs.module';
import { PaymentsModule } from './modules/payments/payments.module';
import { NotificationsModule } from './modules/notifications/notifications.module';
import { AdminModule } from './modules/admin/admin.module';

@Module({
  controllers: [AppController],
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) =>
        getDatabaseConfig(configService),
      inject: [ConfigService],
    }),
    // Core modules
    EmailModule,
    AuthModule,
    UsersModule,
    AddressesModule,
    VendorsModule,
    MenuModule,
    VideosModule,
    FeedModule,
    CartModule,
    OrdersModule,
    DeliveryModule,
    DriversModule,
    JobsModule,
    PaymentsModule,
    NotificationsModule,
    AdminModule,
  ],
})
export class AppModule {}
