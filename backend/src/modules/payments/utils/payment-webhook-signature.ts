import { createHmac, timingSafeEqual } from 'crypto';
import type { PaymentWebhookDto } from '../dto/payment-webhook.dto';

export function webhookSignaturePayload(dto: PaymentWebhookDto): string {
  return `${dto.paymentId}|${dto.paymentIntentId}|${dto.event}`;
}

export function computeWebhookSignature(
  secret: string,
  dto: PaymentWebhookDto,
): string {
  return createHmac('sha256', secret)
    .update(webhookSignaturePayload(dto))
    .digest('hex');
}

export function verifyWebhookSignature(
  secret: string,
  headerSignature: string | undefined,
  dto: PaymentWebhookDto,
): boolean {
  if (!secret || secret.length < 8) {
    return false;
  }
  if (!headerSignature?.trim()) {
    return false;
  }
  const expected = computeWebhookSignature(secret, dto);
  const a = Buffer.from(headerSignature.trim(), 'utf8');
  const b = Buffer.from(expected, 'utf8');
  if (a.length !== b.length) {
    return false;
  }
  return timingSafeEqual(a, b);
}
