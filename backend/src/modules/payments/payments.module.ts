import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { PaymentsController } from './payments.controller';
import { PaymentsWebhookController } from './payments-webhook.controller';
import { PaymentsService } from './payments.service';
import { Payment } from './entities/payment.entity';
import { SavedPaymentMethod } from './entities/saved-payment-method.entity';
import { SavedPaymentMethodsService } from './saved-payment-methods.service';
import { Order } from '../orders/entities/order.entity';
import { EventRequest } from '../event-requests/entities/event-request.entity';
import { PAYMENT_GATEWAY } from './gateway/payment-gateway.port';
import { MockPaymentGateway } from './gateway/mock-payment.gateway';
import type { PaymentConfig } from '../../config/payment.config';

@Module({
  imports: [
    ConfigModule,
    TypeOrmModule.forFeature([Payment, Order, EventRequest, SavedPaymentMethod]),
  ],
  controllers: [PaymentsController, PaymentsWebhookController],
  providers: [
    PaymentsService,
    SavedPaymentMethodsService,
    {
      provide: PAYMENT_GATEWAY,
      useFactory: (configService: ConfigService) => {
        const cfg = configService.get<PaymentConfig>('payment');
        const p = (cfg?.provider ?? 'mock').trim().toLowerCase();
        if (p !== 'mock') {
          throw new Error(
            `Unsupported PAYMENT_PROVIDER "${p}". Use "mock" until a real gateway adapter is registered.`,
          );
        }
        return new MockPaymentGateway();
      },
      inject: [ConfigService],
    },
  ],
  exports: [PaymentsService, SavedPaymentMethodsService, TypeOrmModule],
})
export class PaymentsModule {}
