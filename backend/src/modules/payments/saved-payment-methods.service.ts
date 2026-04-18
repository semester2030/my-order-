import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { randomUUID } from 'crypto';
import { Repository } from 'typeorm';
import { SavedPaymentMethod } from './entities/saved-payment-method.entity';
import { CreateSavedPaymentMethodDto } from './dto/create-saved-payment-method.dto';

const MAX_SAVED_METHODS_PER_USER = 10;
const BRAND_MADA = 'mada';

@Injectable()
export class SavedPaymentMethodsService {
  constructor(
    @InjectRepository(SavedPaymentMethod)
    private readonly repo: Repository<SavedPaymentMethod>,
  ) {}

  private normalizeExpYear(y: number): number {
    if (y >= 2000 && y <= 2100) return y;
    throw new BadRequestException('سنة الانتهاء غير صالحة');
  }

  /** شكل الاستجابة للعميل — مصدر واحد لتفادي التكرار بين القائمة والإنشاء */
  private toSavedCardResponse(row: SavedPaymentMethod) {
    return {
      id: row.id,
      brand: row.brand,
      last4: row.last4,
      expMonth: row.expMonth,
      expYear: row.expYear,
      holderName: row.holderName,
      createdAt: row.createdAt.toISOString(),
    };
  }

  async listForUser(userId: string) {
    const rows = await this.repo.find({
      where: { userId, brand: BRAND_MADA },
      order: { createdAt: 'DESC' },
    });
    return rows.map((r) => this.toSavedCardResponse(r));
  }

  async create(userId: string, dto: CreateSavedPaymentMethodDto) {
    const count = await this.repo.count({ where: { userId } });
    if (count >= MAX_SAVED_METHODS_PER_USER) {
      throw new BadRequestException(
        `الحد الأقصى ${MAX_SAVED_METHODS_PER_USER} بطاقات محفوظة`,
      );
    }

    const expYear = this.normalizeExpYear(dto.expYear);
    const gatewayPaymentMethodId = `mock_mada_${randomUUID()}`;

    const row = this.repo.create({
      userId,
      brand: BRAND_MADA,
      gatewayPaymentMethodId,
      last4: dto.last4,
      expMonth: dto.expMonth,
      expYear,
      holderName: dto.holderName.trim(),
    });
    const saved = await this.repo.save(row);
    return this.toSavedCardResponse(saved);
  }

  async delete(userId: string, id: string): Promise<void> {
    const res = await this.repo.delete({ id, userId });
    if (!res.affected) {
      throw new NotFoundException('البطاقة غير موجودة');
    }
  }
}
