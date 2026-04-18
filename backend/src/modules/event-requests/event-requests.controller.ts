import {
  Controller,
  Post,
  Get,
  Body,
  Param,
  UseGuards,
  Request,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { EventRequestsService } from './event-requests.service';
import { CreateEventRequestDto } from './dto/create-event-request.dto';
import { DeclareHomeCookingPaymentDto } from './dto/declare-home-cooking-payment.dto';
import { HandoverHomeCookingDto } from './dto/handover-home-cooking.dto';
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
  async create(
    @Request() req: { user: User },
    @Body() dto: CreateEventRequestDto,
  ) {
    return this.eventRequestsService.create(req.user.id, dto);
  }

  @Get()
  @ApiOperation({ summary: 'Get my event requests' })
  async getMine(@Request() req: { user: User }) {
    return this.eventRequestsService.findByUser(req.user.id);
  }

  @Post(':id/declare-home-cooking-payment')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary:
      'إعلان تحويل بنكي لطلب طبخ منزلي (بعد عرض السعر — ينتقل لانتظار تحقق الإدارة)',
  })
  async declareHomeCookingPayment(
    @Request() req: { user: User },
    @Param('id') id: string,
    @Body() dto: DeclareHomeCookingPaymentDto,
  ) {
    return this.eventRequestsService.declareHomeCookingPaymentByCustomer(
      req.user.id,
      id,
      dto,
    );
  }

  @Post(':id/confirm-home-cooking-receipt')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary:
      'تأكيد استلام طلب الطبخ المنزلي — إغلاق الطلب وإصدار رمز إتمام للأرشفة والإدارة',
  })
  async confirmHomeCookingReceipt(
    @Request() req: { user: User },
    @Param('id') id: string,
  ) {
    return this.eventRequestsService.confirmHomeCookingReceiptByCustomer(
      req.user.id,
      id,
    );
  }

  @Post(':id/confirm-service-completion')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary:
      'تأكيد إتمام خدمة حجز الطبّاخ (ذبائح/شواء) — بعد القبول؛ يُفعّل التقييم',
  })
  async confirmChefServiceCompletion(
    @Request() req: { user: User },
    @Param('id') id: string,
  ) {
    return this.eventRequestsService.confirmChefServiceCompletionByCustomer(
      req.user.id,
      id,
    );
  }

  @Post(':id/cancel')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'إلغاء طلب حجز/طباخة (قيد الانتظار فقط)' })
  async cancel(
    @Request() req: { user: User },
    @Param('id') id: string,
  ) {
    return this.eventRequestsService.cancelByCustomer(req.user.id, id);
  }

  @Get(':id')
  @ApiOperation({ summary: 'تفاصيل طلبي (حسب المعرّف)' })
  async getOne(@Request() req: { user: User }, @Param('id') id: string) {
    return this.eventRequestsService.findOneByUser(req.user.id, id);
  }
}
