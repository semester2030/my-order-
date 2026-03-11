import { Module, forwardRef } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { VendorsController } from './vendors.controller';
import { VendorsService } from './vendors.service';
import { Vendor } from './entities/vendor.entity';
import { VendorCertificate } from './entities/vendor-certificate.entity';
import { VendorStaff } from './entities/vendor-staff.entity';
import { User } from '../users/entities/user.entity';
import { Order } from '../orders/entities/order.entity';
import { MenuItem } from '../menu/entities/menu-item.entity';
import { UsersModule } from '../users/users.module';
import { JobsModule } from '../jobs/jobs.module';
import { PrivateEventsModule } from '../private-events/private-events.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Vendor,
      VendorCertificate,
      VendorStaff,
      User,
      Order,
      MenuItem,
    ]),
    UsersModule,
    forwardRef(() => JobsModule),
    PrivateEventsModule,
  ],
  controllers: [VendorsController],
  providers: [VendorsService],
  exports: [VendorsService, TypeOrmModule],
})
export class VendorsModule {}
