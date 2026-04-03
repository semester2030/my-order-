import { Module, forwardRef } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { VendorsController } from './vendors.controller';
import { VendorsService } from './vendors.service';
import { EmailModule } from '../email/email.module';
import { Vendor } from './entities/vendor.entity';
import { VendorCertificate } from './entities/vendor-certificate.entity';
import { VendorStaff } from './entities/vendor-staff.entity';
import { User } from '../users/entities/user.entity';
import { Order } from '../orders/entities/order.entity';
import { MenuItem } from '../menu/entities/menu-item.entity';
import { EventRequest } from '../event-requests/entities/event-request.entity';
import { PrivateEventRequest } from '../private-events/entities/private-event-request.entity';
import { EventOffer } from '../private-events/entities/event-offer.entity';
import { Driver } from '../drivers/entities/driver.entity';
import { UsersModule } from '../users/users.module';
import { JobsModule } from '../jobs/jobs.module';
import { PrivateEventsModule } from '../private-events/private-events.module';
import { ApprovedVendorGuard } from './guards/approved-vendor.guard';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Vendor,
      VendorCertificate,
      VendorStaff,
      User,
      Order,
      MenuItem,
      EventRequest,
      PrivateEventRequest,
      EventOffer,
      Driver,
    ]),
    EmailModule,
    JwtModule.registerAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        secret: configService.get<string>('JWT_SECRET'),
        signOptions: {
          expiresIn: configService.get<string>('JWT_EXPIRES_IN', '7d'),
        },
      }),
      inject: [ConfigService],
    }),
    UsersModule,
    forwardRef(() => JobsModule),
    PrivateEventsModule,
  ],
  controllers: [VendorsController],
  providers: [VendorsService, ApprovedVendorGuard],
  exports: [VendorsService, ApprovedVendorGuard, TypeOrmModule],
})
export class VendorsModule {}
