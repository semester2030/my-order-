import {
  Controller,
  Post,
  Body,
  Get,
  Param,
  UseGuards,
  Request,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { PaymentsService } from './payments.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { User } from '../users/entities/user.entity';
import { InitiatePaymentDto } from './dto/initiate-payment.dto';
import { InitiateHomeCookingCardPaymentDto } from './dto/initiate-home-cooking-card-payment.dto';
import { ConfirmPaymentDto } from './dto/confirm-payment.dto';

@ApiTags('payments')
@Controller('payments')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class PaymentsController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Post('initiate')
  @ApiOperation({ summary: 'Initiate payment for an order' })
  async initiatePayment(
    @Request() req: { user: User },
    @Body() dto: InitiatePaymentDto,
  ) {
    return this.paymentsService.initiatePayment(req.user.id, dto);
  }

  @Post('initiate-home-cooking')
  @ApiOperation({
    summary: 'Initiate card payment for a quoted home-cooking event_request',
  })
  async initiateHomeCookingCardPayment(
    @Request() req: { user: User },
    @Body() dto: InitiateHomeCookingCardPaymentDto,
  ) {
    return this.paymentsService.initiateHomeCookingCardPayment(
      req.user.id,
      dto,
    );
  }

  @Post('confirm')
  @ApiOperation({
    summary: 'Confirm payment (dev mock only)',
    description:
      'في الإنتاج مرفوض. في التطوير: يتطلّب PAYMENT_DEV_ALLOW_CLIENT_CONFIRM_MOCK=true والمزوّد mock؛ لا يُعتمد على transactionId من العميل.',
  })
  async confirmPayment(
    @Request() req: { user: User },
    @Body() dto: ConfirmPaymentDto,
  ) {
    return this.paymentsService.confirmPayment(req.user.id, dto);
  }

  @Get('order/:orderId')
  @ApiOperation({ summary: 'Get payments for an order' })
  async getOrderPayments(
    @Request() req: { user: User },
    @Param('orderId') orderId: string,
  ) {
    return this.paymentsService.getOrderPayments(orderId, req.user.id);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get payment details' })
  async getPayment(@Request() req: { user: User }, @Param('id') id: string) {
    return this.paymentsService.getPayment(id, req.user.id);
  }
}
