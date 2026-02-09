import { registerAs } from '@nestjs/config';

export default registerAs('payment', () => ({
  applePay: {
    merchantId: process.env.APPLE_PAY_MERCHANT_ID,
  },
  mada: {
    apiKey: process.env.MADA_API_KEY,
    apiUrl: process.env.MADA_API_URL,
  },
  stcPay: {
    apiKey: process.env.STC_PAY_API_KEY,
    apiUrl: process.env.STC_PAY_API_URL,
  },
}));
