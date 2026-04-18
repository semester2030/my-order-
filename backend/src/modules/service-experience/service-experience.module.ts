import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ServiceReview } from './entities/service-review.entity';
import { ServiceQualityTicket } from './entities/service-quality-ticket.entity';
import { ServiceExperienceService } from './service-experience.service';
import { ServiceExperienceController } from './service-experience.controller';
import { EventRequest } from '../event-requests/entities/event-request.entity';
import { Order } from '../orders/entities/order.entity';
import { Vendor } from '../vendors/entities/vendor.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      ServiceReview,
      ServiceQualityTicket,
      EventRequest,
      Order,
      Vendor,
    ]),
  ],
  controllers: [ServiceExperienceController],
  providers: [ServiceExperienceService],
  exports: [ServiceExperienceService],
})
export class ServiceExperienceModule {}
