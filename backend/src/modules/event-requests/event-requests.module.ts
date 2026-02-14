import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EventRequestsController } from './event-requests.controller';
import { EventRequestsService } from './event-requests.service';
import { EventRequest } from './entities/event-request.entity';

@Module({
  imports: [TypeOrmModule.forFeature([EventRequest])],
  controllers: [EventRequestsController],
  providers: [EventRequestsService],
  exports: [EventRequestsService],
})
export class EventRequestsModule {}
