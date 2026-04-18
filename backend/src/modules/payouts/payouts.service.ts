import {
  BadRequestException,
  Inject,
  Injectable,
  InternalServerErrorException,
  NotFoundException,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import type { PayoutConfig } from '../../config/payout.config';
import { Vendor } from '../vendors/entities/vendor.entity';
import {
  VendorPayoutProfile,
  VendorPayoutProfileStatus,
} from './entities/vendor-payout-profile.entity';
import {
  PayoutRequest,
  PayoutRequestStatus,
} from './entities/payout-request.entity';
import {
  PAYOUT_GATEWAY,
  type PayoutGatewayPort,
} from './gateway/payout-gateway.port';

@Injectable()
export class PayoutsService {
  constructor(
    @InjectRepository(VendorPayoutProfile)
    private readonly profileRepo: Repository<VendorPayoutProfile>,
    @InjectRepository(PayoutRequest)
    private readonly payoutRepo: Repository<PayoutRequest>,
    @InjectRepository(Vendor)
    private readonly vendorRepo: Repository<Vendor>,
    private readonly configService: ConfigService,
    @Inject(PAYOUT_GATEWAY)
    private readonly payoutGateway: PayoutGatewayPort,
  ) {}

  private payoutConfig(): PayoutConfig {
    const cfg = this.configService.get<PayoutConfig>('payout');
    if (!cfg) {
      throw new InternalServerErrorException(
        'payout configuration is not loaded',
      );
    }
    return cfg;
  }

  /** إنشاء ملف مالي افتراضي لمقدّم خدمة لم يُنشأ له صف بعد */
  async getOrCreateProfile(vendorId: string): Promise<VendorPayoutProfile> {
    let row = await this.profileRepo.findOne({ where: { vendorId } });
    if (row) {
      return row;
    }
    const vendor = await this.vendorRepo.findOne({ where: { id: vendorId } });
    if (!vendor) {
      throw new NotFoundException('المزود غير موجود');
    }
    row = this.profileRepo.create({
      vendorId,
      verificationStatus: VendorPayoutProfileStatus.UNVERIFIED,
    });
    return this.profileRepo.save(row);
  }

  /**
   * إنشاء طلب تحويل وتمريره على بوابة التحويل (mock = إكمال فوري في DB).
   * عند PSP حقيقي: قد يبقى submitted ثم يُحدَّث عبر webhook.
   */
  async createPayoutRequest(input: {
    vendorId: string;
    amount: number;
    idempotencyKey: string;
    sourceType?: string | null;
    sourceId?: string | null;
    meta?: Record<string, unknown> | null;
    /** إن true يُرفض عند عدم وجود آيبان على المزود — جاهز للإنتاج */
    requireVendorIban?: boolean;
  }): Promise<PayoutRequest> {
    this.payoutConfig();
    const amt = Number(input.amount);
    if (!Number.isFinite(amt) || amt < 0.01) {
      throw new BadRequestException('مبلغ التحويل غير صالح');
    }
    const key = input.idempotencyKey.trim();
    if (key.length < 8) {
      throw new BadRequestException('idempotency_key مطلوب (8 أحرف على الأقل)');
    }

    const existing = await this.payoutRepo.findOne({
      where: { idempotencyKey: key },
    });
    if (existing) {
      return existing;
    }

    const vendor = await this.vendorRepo.findOne({ where: { id: input.vendorId } });
    if (!vendor) {
      throw new NotFoundException('المزود غير موجود');
    }
    if (input.requireVendorIban === true) {
      const iban = vendor.iban?.trim();
      if (!iban || iban.length < 8) {
        throw new BadRequestException(
          'لم يُسجَّل آيبان صالح لمقدّم الخدمة — أدخله في ملف المزود قبل طلب التحويل',
        );
      }
    }

    await this.getOrCreateProfile(input.vendorId);

    const row = this.payoutRepo.create({
      vendorId: input.vendorId,
      amount: amt,
      currency: 'SAR',
      status: PayoutRequestStatus.PENDING,
      sourceType: input.sourceType?.trim() || null,
      sourceId: input.sourceId ?? null,
      idempotencyKey: key,
      meta: input.meta ?? null,
    });
    let saved = await this.payoutRepo.save(row);

    const iban = vendor.iban?.trim() ?? '';
    const ibanHint = iban.length >= 4 ? iban.slice(-4) : null;
    const profile = await this.profileRepo.findOne({
      where: { vendorId: input.vendorId },
    });

    const res = await this.payoutGateway.submitPayout({
      idempotencyKey: key,
      amount: amt,
      currency: 'SAR',
      beneficiary: {
        externalAccountId: profile?.externalConnectedAccountId ?? null,
        ibanHint,
      },
      metadata: {
        vendorId: input.vendorId,
        ...(input.sourceType ? { sourceType: input.sourceType } : {}),
      },
    });

    if (!res.ok) {
      saved.status = PayoutRequestStatus.FAILED;
      saved.failureReason = res.refusalReason ?? 'payout_gateway_refused';
      saved = await this.payoutRepo.save(saved);
      return saved;
    }

    saved.status = PayoutRequestStatus.COMPLETED;
    saved.providerPayoutId = res.providerPayoutId ?? null;
    saved.completedAt = new Date();
    saved.meta = {
      ...(saved.meta ?? {}),
      gatewayRaw: res.raw ?? {},
    };
    return this.payoutRepo.save(saved);
  }

  async listPayoutRequestsForVendor(
    vendorId: string,
    opts?: { limit?: number },
  ): Promise<PayoutRequest[]> {
    const limit = Math.min(Math.max(opts?.limit ?? 50, 1), 200);
    return this.payoutRepo.find({
      where: { vendorId },
      order: { createdAt: 'DESC' },
      take: limit,
    });
  }
}
