import { Injectable } from '@nestjs/common';

interface OtpCacheEntry {
  code: string;
  expiresAt: number;
  attempts: number;
}

@Injectable()
export class OtpCacheService {
  private readonly otpCache = new Map<string, OtpCacheEntry>();
  private readonly MAX_ATTEMPTS = 3;
  private readonly OTP_EXPIRY = 5 * 60 * 1000; // 5 minutes

  generateOtp(): string {
    // Generate 6-digit OTP
    return Math.floor(100000 + Math.random() * 900000).toString();
  }

  storeOtp(phone: string, code: string): void {
    const expiresAt = Date.now() + this.OTP_EXPIRY;
    this.otpCache.set(phone, {
      code,
      expiresAt,
      attempts: 0,
    });

    // Auto-cleanup expired entries
    setTimeout(() => {
      this.otpCache.delete(phone);
    }, this.OTP_EXPIRY);
  }

  verifyOtp(phone: string, code: string): boolean {
    const entry = this.otpCache.get(phone);

    if (!entry) {
      return false;
    }

    if (Date.now() > entry.expiresAt) {
      this.otpCache.delete(phone);
      return false;
    }

    if (entry.attempts >= this.MAX_ATTEMPTS) {
      this.otpCache.delete(phone);
      return false;
    }

    entry.attempts++;

    if (entry.code !== code) {
      if (entry.attempts >= this.MAX_ATTEMPTS) {
        this.otpCache.delete(phone);
      }
      return false;
    }

    // OTP verified successfully
    this.otpCache.delete(phone);
    return true;
  }

  getRemainingTime(phone: string): number {
    const entry = this.otpCache.get(phone);
    if (!entry) {
      return 0;
    }
    const remaining = entry.expiresAt - Date.now();
    return Math.max(0, Math.floor(remaining / 1000));
  }
}
