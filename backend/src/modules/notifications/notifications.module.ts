import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { NotificationsController } from './notifications.controller';
import { NotificationsService } from './notifications.service';
import { FcmModule } from './fcm/fcm.module';
import { DriverNotificationsService } from './driver/driver-notifications.service';
import { Driver } from '../drivers/entities/driver.entity';

@Module({
  imports: [
    FcmModule,
    TypeOrmModule.forFeature([Driver]),
  ],
  controllers: [NotificationsController],
  providers: [NotificationsService, DriverNotificationsService],
  exports: [NotificationsService, DriverNotificationsService],
})
export class NotificationsModule {}
