import { Injectable } from '@nestjs/common';
import { randomUUID } from 'crypto';
import type {
  PaymentGatewayPort,
  PaymentGatewayCheckoutSession,
  PaymentGatewayVerifyInput,
  PaymentGatewayVerifyResult,
} from './payment-gateway.port';

@Injectable()
export class MockPaymentGateway implements PaymentGatewayPort {
  static intentIdFor(paymentId: string): string {
    return `mock_pi_${paymentId}`;
  }

  static secretFor(paymentId: string): string {
    return `mock_cs_${paymentId}`;
  }

  async createCheckoutSession(input: {
    paymentId: string;
    amount: number;
    currency: string;
    metadata?: Record<string, string>;
  }): Promise<PaymentGatewayCheckoutSession> {
    const paymentIntentId = MockPaymentGateway.intentIdFor(input.paymentId);
    const clientSecret = MockPaymentGateway.secretFor(input.paymentId);
    return {
      paymentIntentId,
      clientSecret,
      raw: {
        provider: 'mock',
        amount: input.amount,
        currency: input.currency,
        metadata: input.metadata ?? {},
      },
    };
  }

  async verifyPayment(
    input: PaymentGatewayVerifyInput,
  ): Promise<PaymentGatewayVerifyResult> {
    if (input.devClientMockComplete === true) {
      if (!input.storedPaymentIntentId) {
        return {
          ok: false,
          refusalReason: 'missing_stored_session',
          raw: { provider: 'mock', path: 'dev_client_mock' },
        };
      }
      return {
        ok: true,
        transactionId: `mock_tx_${randomUUID()}`,
        raw: { provider: 'mock', path: 'dev_client_mock' },
      };
    }

    if (!input.storedPaymentIntentId) {
      return {
        ok: false,
        refusalReason: 'missing_stored_session',
        raw: { provider: 'mock' },
      };
    }

    if (!input.claimedPaymentIntentId) {
      return {
        ok: false,
        refusalReason: 'missing_claimed_intent',
        raw: { provider: 'mock' },
      };
    }

    if (input.claimedPaymentIntentId !== input.storedPaymentIntentId) {
      return {
        ok: false,
        refusalReason: 'payment_intent_mismatch',
        raw: { provider: 'mock' },
      };
    }

    const expectedIntent = MockPaymentGateway.intentIdFor(input.paymentId);
    if (input.storedPaymentIntentId !== expectedIntent) {
      return {
        ok: false,
        refusalReason: 'stored_intent_invalid',
        raw: { provider: 'mock' },
      };
    }

    const expectedAmount = Number.isFinite(input.amount) && input.amount >= 0;
    if (!expectedAmount) {
      return {
        ok: false,
        refusalReason: 'invalid_amount',
        raw: { provider: 'mock' },
      };
    }

    return {
      ok: true,
      transactionId: `mock_tx_${randomUUID()}`,
      raw: { provider: 'mock', path: 'webhook_verify' },
    };
  }
}
