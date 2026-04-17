import {
  Body,
  Controller,
  Headers,
  HttpCode,
  Post,
} from '@nestjs/common';
import { ApiOperation, ApiTags, ApiHeader } from '@nestjs/swagger';
import { PaymentsService } from './payments.service';
import { PaymentWebhookDto } from './dto/payment-webhook.dto';

@ApiTags('payments')
@Controller('payments')
export class PaymentsWebhookController {
  constructor(private readonly paymentsService: PaymentsService) {}

  @Post('webhook')
  @HttpCode(200)
  @ApiOperation({
    summary: 'PSP webhook — يُكمّل الدفع بعد التحقق من التوقيع والمزوّد',
  })
  @ApiHeader({
    name: 'x-payment-signature',
    required: false,
    description:
      'HMAC-SHA256(hex) لـ paymentId|paymentIntentId|event باستخدام PAYMENT_WEBHOOK_SECRET',
  })
  async paymentWebhook(
    @Headers('x-payment-signature') signature: string | undefined,
    @Body() dto: PaymentWebhookDto,
  ) {
    return this.paymentsService.handlePaymentWebhook(signature, dto);
  }
}
