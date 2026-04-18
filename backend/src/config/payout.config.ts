import { registerAs } from '@nestjs/config';

export interface PayoutConfig {
  nodeEnv: string;
  /**
   * مزوّد التحويل للمقدّمين: mock حتى التعاقد مع PSP يدعم payouts / Connect.
   * عند الربط: يُضاف محوّل حقيقي دون تغيير جداول payout_requests.
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
