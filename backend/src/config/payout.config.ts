import { registerAs } from '@nestjs/config';

export interface PayoutConfig {
  nodeEnv: string;
  /**
   * مزوّد التحويل للمقدّمين: `mock` للتجارب (إكمال في DB).
   * لأي قيمة أخرى: NotImplementedPayoutGateway — نفّذ PayoutGatewayPort في payouts.module.ts.
   */
  provider: string;
}

export default registerAs(
  'payout',
  (): PayoutConfig => ({
    nodeEnv: process.env.NODE_ENV ?? 'development',
    provider: (process.env.PAYOUT_PROVIDER ?? 'mock').trim().toLowerCase(),
  }),
);
