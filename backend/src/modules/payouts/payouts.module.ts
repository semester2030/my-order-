import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Vendor } from '../vendors/entities/vendor.entity';
import { VendorPayoutProfile } from './entities/vendor-payout-profile.entity';
import { PayoutRequest } from './entities/payout-request.entity';
import { PayoutsService } from './payouts.service';
import { PAYOUT_GATEWAY } from './gateway/payout-gateway.port';
import { MockPayoutGateway } from './gateway/mock-payout.gateway';
import { NotImplementedPayoutGateway } from './gateway/not-implemented-payout.gateway';
import type { PayoutConfig } from '../../config/payout.config';

@Module({
  imports: [
    ConfigModule,
    TypeOrmModule.forFeature([VendorPayoutProfile, PayoutRequest, Vendor]),
  ],
  providers: [
    PayoutsService,
    {
      provide: PAYOUT_GATEWAY,
      useFactory: (configService: ConfigService) => {
        const cfg = configService.get<PayoutConfig>('payout');
        const p = (cfg?.provider ?? 'mock').trim().toLowerCase();
        if (p === 'mock') {
          return new MockPayoutGateway();
        }
        return new NotImplementedPayoutGateway(p);
      },
      inject: [ConfigService],
    },
  ],
  exports: [PayoutsService, TypeOrmModule],
})
export class PayoutsModule {}
