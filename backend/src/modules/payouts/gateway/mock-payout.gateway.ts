import { randomUUID } from 'crypto';
import type {
  PayoutGatewayPort,
  PayoutGatewaySubmitInput,
  PayoutGatewaySubmitResult,
} from './payout-gateway.port';

/** وضع تطوير — يُكمّل فوراً دون تحويل بنكي حقيقي */
export class MockPayoutGateway implements PayoutGatewayPort {
  async submitPayout(
    input: PayoutGatewaySubmitInput,
  ): Promise<PayoutGatewaySubmitResult> {
    return {
      ok: true,
      providerPayoutId: `mock_payout_${randomUUID()}`,
      raw: {
        mock: true,
        idempotencyKey: input.idempotencyKey,
        amount: input.amount,
        currency: input.currency,
      },
    };
  }
}
