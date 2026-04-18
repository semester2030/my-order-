import { Injectable } from '@nestjs/common';
import type {
  PayoutGatewayPort,
  PayoutGatewaySubmitInput,
  PayoutGatewaySubmitResult,
} from './payout-gateway.port';

/** يُستخدم عند ضبط PAYOUT_PROVIDER لقيمة غير mock قبل تنفيذ محوّل التحويلات الحقيقي. */
@Injectable()
export class NotImplementedPayoutGateway implements PayoutGatewayPort {
  constructor(private readonly provider: string) {}

  async submitPayout(
    _input: PayoutGatewaySubmitInput,
  ): Promise<PayoutGatewaySubmitResult> {
    return {
      ok: false,
      refusalReason: `payout_psp_not_implemented:${this.provider}`,
      raw: {
        hint:
          'Register a class implementing PayoutGatewayPort in payouts.module.ts',
      },
    };
  }
}
