import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { EventRequestsController } from './event-requests.controller';
import { EventRequestsService } from './event-requests.service';
import { EventRequest } from './entities/event-request.entity';

@Module({
  imports: [ConfigModule, TypeOrmModule.forFeature([EventRequest])],
  controllers: [EventRequestsController],
  providers: [EventRequestsService],
  exports: [EventRequestsService],
})
export class EventRequestsModule {}
