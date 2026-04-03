import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { Resend } from 'resend';

@Injectable()
export class EmailService {
  private readonly logger = new Logger(EmailService.name);
  private readonly resend: Resend | null = null;
  private readonly from: string;

  constructor(private readonly configService: ConfigService) {
    const apiKey = this.configService.get<string>('RESEND_API_KEY');
    if (apiKey) {
      this.resend = new Resend(apiKey);
      this.logger.log('Email service initialized (Resend)');
    } else {
      this.logger.warn(
        'RESEND_API_KEY not set - emails will not be sent. Set it for production.',
      );
    }
    this.from =
      this.configService.get<string>('RESEND_FROM') ??
      'مطبخ البيت <onboarding@resend.dev>';
  }

  isConfigured(): boolean {
    return this.resend !== null;
  }

  async sendOtp(to: string, otp: string): Promise<boolean> {
    if (!this.resend) {
      this.logger.warn(`Email not sent (no RESEND_API_KEY): OTP for ${to}`);
      return false;
    }

    try {
      const subject = 'رمز التحقق - مطبخ البيت';
      const html = `
<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
</head>
<body style="font-family: 'Segoe UI', Tahoma, sans-serif; margin: 0; padding: 24px; background: #f5f5f5;">
  <div style="max-width: 400px; margin: 0 auto; background: white; border-radius: 12px; padding: 32px; box-shadow: 0 2px 8px rgba(0,0,0,0.08);">
    <h2 style="color: #333; margin: 0 0 16px; font-size: 20px;">رمز التحقق</h2>
    <p style="color: #666; margin: 0 0 24px; line-height: 1.6;">استخدم الرمز التالي لتسجيل الدخول:</p>
    <div style="background: #f9f9f9; border-radius: 8px; padding: 16px 24px; text-align: center; font-size: 28px; font-weight: bold; letter-spacing: 8px; color: #333;">${otp}</div>
    <p style="color: #999; margin: 24px 0 0; font-size: 13px;">هذا الرمز صالح لمدة 5 دقائق. لا تشاركه مع أحد.</p>
  </div>
</body>
</html>`;

      const { data, error } = await this.resend.emails.send({
        from: this.from,
        to: [to],
        subject,
        html,
      });

      this.logger.log(
        `Resend API response: data=${JSON.stringify(data)} error=${error ? JSON.stringify(error) : 'null'}`,
      );

      if (error) {
        this.logger.error(
          `Failed to send OTP email to ${to}: ${error.message}`,
        );
        return false;
      }

      this.logger.log(`OTP email sent to ${to} | Resend id: ${data?.id}`);
      return true;
    } catch (err) {
      this.logger.error(`Error sending OTP email to ${to}:`, err);
      return false;
    }
  }

  /**
   * تأكيد لمقدّم الخدمة بعد إنشاء الطلب (قيد المراجعة).
   * يتطلب RESEND_API_KEY و RESEND_FROM المعتمد في Resend.
   */
  async sendVendorRegistrationSubmitted(
    to: string,
    vendorName: string,
  ): Promise<boolean> {
    if (!this.resend) {
      this.logger.warn(
        `Vendor registration email not sent (no RESEND_API_KEY): ${to}`,
      );
      return false;
    }
    try {
      const subject = 'تم استلام طلب تسجيلك — مطبخ البيت';
      const html = `
<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head><meta charset="UTF-8"></head>
<body style="font-family: 'Segoe UI', Tahoma, sans-serif; margin: 0; padding: 24px; background: #f5f5f5;">
  <div style="max-width: 480px; margin: 0 auto; background: white; border-radius: 12px; padding: 28px; box-shadow: 0 2px 8px rgba(0,0,0,0.08);">
    <h2 style="color: #333; margin: 0 0 12px;">مرحباً ${this.escapeHtml(vendorName)}</h2>
    <p style="color: #555; line-height: 1.7; margin: 0 0 16px;">
      تم استلام طلب تسجيلك كمقدّم خدمة. حالته الآن: <strong>بانتظار موافقة الإدارة</strong> (قد يستغرق وقتاً).
    </p>
    <p style="color: #555; line-height: 1.7; margin: 0 0 12px;">
      <strong>عند الموافقة:</strong> سجّل الدخول من تطبيق مقدّم الخدمة بنفس بريدك وكلمة المرور لإكمال بياناتك.
    </p>
    <p style="color: #555; line-height: 1.7; margin: 0 0 16px;">
      <strong>عند الرفض:</strong> بعد تسجيل الدخول ستظهر لك في التطبيق شاشة توضّح سبب الرفض عندما يحدده فريقنا.
    </p>
    <p style="color: #888; font-size: 13px; margin: 0;">هذه رسالة تلقائية من منصة مطبخ البيت.</p>
  </div>
</body>
</html>`;
      const { data, error } = await this.resend.emails.send({
        from: this.from,
        to: [to],
        subject,
        html,
      });
      if (error) {
        this.logger.error(
          `Vendor registration email failed for ${to}: ${error.message}`,
        );
        return false;
      }
      this.logger.log(
        `Vendor registration ack sent to ${to} | Resend id: ${data?.id}`,
      );
      return true;
    } catch (err) {
      this.logger.error(`Vendor registration email error for ${to}:`, err);
      return false;
    }
  }

  /**
   * إشعار للإدارة بطلب جديد. عيّن VENDOR_REGISTRATION_NOTIFY_EMAIL في البيئة (بريد واحد أو عدة عناوين مفصولة بفاصلة أو فاصلة منقوطة).
   */
  async notifyAdminsVendorRegistrationPending(
    recipients: string[],
    params: { vendorName: string; vendorEmail: string; vendorId: string },
  ): Promise<boolean> {
    if (!this.resend || recipients.length === 0) return false;
    const { vendorName, vendorEmail, vendorId } = params;
    try {
      const subject = `طلب تسجيل مقدّم خدمة جديد: ${vendorName}`;
      const html = `
<!DOCTYPE html>
<html dir="rtl" lang="ar">
<head><meta charset="UTF-8"></head>
<body style="font-family: sans-serif; padding: 24px;">
  <h2>طلب تسجيل جديد</h2>
  <p><strong>الاسم:</strong> ${this.escapeHtml(vendorName)}</p>
  <p><strong>البريد:</strong> ${this.escapeHtml(vendorEmail)}</p>
  <p><strong>معرّف المورد:</strong> ${this.escapeHtml(vendorId)}</p>
  <p>راجع لوحة الإدارة → طلبات تسجيل مقدّمي الخدمة (حالة pending_approval).</p>
</body>
</html>`;
      const { error } = await this.resend.emails.send({
        from: this.from,
        to: recipients,
        subject,
        html,
      });
      if (error) {
        this.logger.error(`Admin vendor notify failed: ${error.message}`);
        return false;
      }
      this.logger.log(`Admin notified for new vendor ${vendorId}`);
      return true;
    } catch (err) {
      this.logger.error('Admin vendor notify error:', err);
      return false;
    }
  }

  private escapeHtml(s: string): string {
    return (s || '')
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }
}
