import {
  Controller,
  Post,
  Get,
  Body,
  UseGuards,
  Request,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { PrivateEventsService } from './private-events.service';
import { CreatePrivateEventRequestDto } from './dto/create-private-event-request.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { User } from '../users/entities/user.entity';

@ApiTags('private-event-requests')
@Controller('private-event-requests')
export class PrivateEventsController {
  constructor(private readonly privateEventsService: PrivateEventsService) {}

  @Post()
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'إنشاء طلب مناسبة خاصة' })
  async create(
    @Request() req: { user: User },
    @Body() dto: CreatePrivateEventRequestDto,
  ) {
    return this.privateEventsService.createPrivateEventRequest(
      req.user.id,
      dto,
    );
  }

  @Get()
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'طلبات المناسبات والحفلات الخاصة بي' })
  async getMine(@Request() req: { user: User }) {
    return this.privateEventsService.findPrivateEventRequestsByUser(
      req.user.id,
    );
  }
}
