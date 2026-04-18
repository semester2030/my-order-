import { Module, forwardRef } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { JwtModule } from '@nestjs/jwt';
import { PassportModule } from '@nestjs/passport';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';
import { AdminUsersController } from './admin-users.controller';
import { AdminUsersService } from './admin-users.service';
import { AdminAuthController } from './admin-auth.controller';
import { AdminAuthService } from './admin-auth.service';
import { AdminJwtStrategy } from './strategies/admin-jwt.strategy';
import { AdminJwtGuard } from './guards/admin-jwt.guard';
import { RolesGuard } from './guards/roles.guard';
import { AdminUser, AdminRole, AuditLog } from './entities';
import { AuditService } from './audit.service';
import { Vendor } from '../vendors/entities/vendor.entity';
import { VendorStaff } from '../vendors/entities/vendor-staff.entity';
import { Driver } from '../drivers/entities/driver.entity';
import { Order } from '../orders/entities/order.entity';
import { Payment } from '../payments/entities/payment.entity';
import { EventRequest } from '../event-requests/entities/event-request.entity';
import { PrivateEventRequest } from '../private-events/entities/private-event-request.entity';
import { EventOffer } from '../private-events/entities/event-offer.entity';
import { VendorsModule } from '../vendors/vendors.module';
import { EventRequestsModule } from '../event-requests/event-requests.module';
import { ServiceExperienceModule } from '../service-experience/service-experience.module';

@Module({
  imports: [
    forwardRef(() => VendorsModule),
    EventRequestsModule,
    ServiceExperienceModule,
    TypeOrmModule.forFeature([
      AdminUser,
      AdminRole,
      AuditLog,
      Vendor,
      VendorStaff,
      Driver,
      Order,
      Payment,
      EventRequest,
      PrivateEventRequest,
      EventOffer,
    ]),
    PassportModule,
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
  ],
  controllers: [AdminController, AdminAuthController, AdminUsersController],
  providers: [
    AdminService,
    AdminUsersService,
    AdminAuthService,
    AuditService,
    AdminJwtStrategy,
    AdminJwtGuard,
    RolesGuard,
  ],
  exports: [
    AdminService,
    AdminUsersService,
    AdminAuthService,
    AuditService,
    AdminJwtGuard,
    RolesGuard,
  ],
})
export class AdminModule {}
