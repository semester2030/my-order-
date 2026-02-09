import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AuditLog } from './entities/audit-log.entity';

export interface AuditLogInput {
  actorId: string;
  action: string;
  entityType: string;
  entityId: string;
  oldValue?: Record<string, unknown> | null;
  newValue?: Record<string, unknown> | null;
  reason?: string | null;
  req?: { ip?: string; headers?: { 'user-agent'?: string } };
}

@Injectable()
export class AuditService {
  constructor(
    @InjectRepository(AuditLog)
    private readonly auditRepo: Repository<AuditLog>,
  ) {}

  async log(input: AuditLogInput): Promise<AuditLog> {
    const {
      actorId,
      action,
      entityType,
      entityId,
      oldValue = null,
      newValue = null,
      reason = null,
      req,
    } = input;

    const ip = (req as { ip?: string })?.ip ?? null;
    const userAgent =
      (req?.headers && (req.headers as { 'user-agent'?: string })['user-agent']) ?? null;

    const record = this.auditRepo.create({
      actorType: 'admin',
      actorId,
      action,
      entityType,
      entityId,
      oldValue,
      newValue,
      reason,
      ip: ip || null,
      userAgent,
    });

    return this.auditRepo.save(record);
  }

  async findMany(options: {
    page?: number;
    limit?: number;
    action?: string;
    entityType?: string;
  }): Promise<{ items: AuditLog[]; total: number }> {
    const page = Math.max(1, options.page ?? 1);
    const limit = Math.min(100, Math.max(1, options.limit ?? 20));
    const skip = (page - 1) * limit;

    const qb = this.auditRepo
      .createQueryBuilder('log')
      .orderBy('log.createdAt', 'DESC');

    if (options.action) {
      qb.andWhere('log.action = :action', { action: options.action });
    }
    if (options.entityType) {
      qb.andWhere('log.entity_type = :entityType', {
        entityType: options.entityType,
      });
    }

    const [items, total] = await qb.skip(skip).take(limit).getManyAndCount();
    return { items, total };
  }
}
