import { Module, forwardRef } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { PassportModule } from '@nestjs/passport';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { OtpStrategy } from './strategies/otp.strategy';
import { PinStrategy } from './strategies/pin.strategy';
import { JwtStrategy } from './strategies/jwt.strategy';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { VendorOnboardingJwtGuard } from './guards/vendor-onboarding-jwt.guard';
import { VendorOnboardingOrApprovedJwtGuard } from './guards/vendor-onboarding-or-approved-jwt.guard';
import { OtpCacheService } from './services/otp-cache.service';
import { User } from '../users/entities/user.entity';
import { Order } from '../orders/entities/order.entity';
import { Cart } from '../cart/entities/cart.entity';
import { CartItem } from '../cart/entities/cart-item.entity';
import { Address } from '../addresses/entities/address.entity';
import { UsersModule } from '../users/users.module';
import { VendorsModule } from '../vendors/vendors.module';

@Module({
  imports: [
    PassportModule,
    TypeOrmModule.forFeature([User, Order, Cart, CartItem, Address]),
    UsersModule,
    forwardRef(() => VendorsModule),
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
  controllers: [AuthController],
  providers: [
    AuthService,
    OtpCacheService,
    OtpStrategy,
    PinStrategy,
    JwtStrategy,
    JwtAuthGuard,
    VendorOnboardingJwtGuard,
    VendorOnboardingOrApprovedJwtGuard,
  ],
  exports: [
    AuthService,
    JwtAuthGuard,
    VendorOnboardingJwtGuard,
    VendorOnboardingOrApprovedJwtGuard,
  ],
})
export class AuthModule {}
