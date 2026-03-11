import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EventOffer } from './entities/event-offer.entity';
import { PrivateEventRequest } from './entities/private-event-request.entity';
import { PrivateEventsService } from './private-events.service';
import { PrivateEventsController } from './private-events.controller';
import { Vendor } from '../vendors/entities/vendor.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([EventOffer, PrivateEventRequest, Vendor]),
  ],
  controllers: [PrivateEventsController],
  providers: [PrivateEventsService],
  exports: [PrivateEventsService],
})
export class PrivateEventsModule {}
