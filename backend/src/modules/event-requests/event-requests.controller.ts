import { Controller, Post, Get, Body, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { EventRequestsService } from './event-requests.service';
import { CreateEventRequestDto } from './dto/create-event-request.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { User } from '../users/entities/user.entity';

@ApiTags('event-requests')
@Controller('event-requests')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class EventRequestsController {
  constructor(private readonly eventRequestsService: EventRequestsService) {}

  @Post()
  @ApiOperation({ summary: 'Create event request (احجز الطباخ / طلب طباخة)' })
  async create(@Request() req: { user: User }, @Body() dto: CreateEventRequestDto) {
    return this.eventRequestsService.create(req.user.id, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get my event requests' })
  async getMine(@Request() req: { user: User }) {
    return this.eventRequestsService.findByUser(req.user.id);
  }
}
