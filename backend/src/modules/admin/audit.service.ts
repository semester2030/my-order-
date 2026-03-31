import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import {
  Repository,
  In,
  Between,
  LessThanOrEqual,
  MoreThanOrEqual,
  FindOptionsWhere,
} from 'typeorm';
import { AuditLog } from './entities/audit-log.entity';
import { AdminUser } from './entities/admin-user.entity';
import { AUDIT_SYSTEM_ACTOR_ID } from './constants';

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

export interface AuditLogPublic {
  id: string;
  actorType: string;
  actorId: string;
  actorName: string | null;
  actorEmail: string | null;
  action: string;
  entityType: string;
  entityId: string;
  oldValue: Record<string, unknown> | null;
  newValue: Record<string, unknown> | null;
  reason: string | null;
  ip: string | null;
  userAgent: string | null;
  createdAt: Date;
}

@Injectable()
export class AuditService {
  constructor(
    @InjectRepository(AuditLog)
    private readonly auditRepo: Repository<AuditLog>,
    @InjectRepository(AdminUser)
    private readonly adminUserRepo: Repository<AdminUser>,
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
      (req?.headers &&
        (req.headers as { 'user-agent'?: string })['user-agent']) ??
      null;

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
    actorId?: string;
    dateFrom?: string;
    dateTo?: string;
  }): Promise<{
    items: AuditLogPublic[];
    total: number;
    page: number;
    limit: number;
  }> {
    const rawP = Number(options.page ?? 1);
    const page = Number.isFinite(rawP) && rawP >= 1 ? Math.floor(rawP) : 1;
    const rawL = Number(options.limit ?? 20);
    const limit =
      Number.isFinite(rawL) && rawL >= 1 ? Math.min(100, Math.floor(rawL)) : 20;
    const skip = (page - 1) * limit;

    const where: FindOptionsWhere<AuditLog> = {};
    if (options.action?.trim()) where.action = options.action.trim();
    if (options.entityType?.trim())
      where.entityType = options.entityType.trim();
    if (options.actorId?.trim()) where.actorId = options.actorId.trim();

    if (options.dateFrom?.trim()) {
      const df = new Date(options.dateFrom);
      if (!Number.isNaN(df.getTime())) {
        if (options.dateTo?.trim()) {
          const dt = new Date(options.dateTo);
          if (!Number.isNaN(dt.getTime())) {
            const end = new Date(dt);
            end.setHours(23, 59, 59, 999);
            where.createdAt = Between(df, end);
          } else {
            where.createdAt = MoreThanOrEqual(df);
          }
        } else {
          where.createdAt = MoreThanOrEqual(df);
        }
      }
    } else if (options.dateTo?.trim()) {
      const dt = new Date(options.dateTo);
      if (!Number.isNaN(dt.getTime())) {
        dt.setHours(23, 59, 59, 999);
        where.createdAt = LessThanOrEqual(dt);
      }
    }

    const [items, total] = await this.auditRepo.findAndCount({
      where,
      order: { createdAt: 'DESC' },
      skip,
      take: limit,
    });

    const actorIds = [...new Set(items.map((i) => i.actorId).filter(Boolean))];
    let actorMap = new Map<string, { name: string; email: string }>();
    if (actorIds.length) {
      const actors = await this.adminUserRepo.find({
        where: { id: In(actorIds) },
      });
      actorMap = new Map(
        actors.map((a) => [a.id, { name: a.name, email: a.email }]),
      );
    }

    const enriched: AuditLogPublic[] = items.map((log) => {
      const act = actorMap.get(log.actorId);
      const isSystem = log.actorId === AUDIT_SYSTEM_ACTOR_ID;
      return {
        id: log.id,
        actorType: log.actorType,
        actorId: log.actorId,
        actorName: act?.name ?? (isSystem ? 'نظام / محاولة دخول' : null),
        actorEmail: act?.email ?? null,
        action: log.action,
        entityType: log.entityType,
        entityId: log.entityId,
        oldValue: log.oldValue,
        newValue: log.newValue,
        reason: log.reason,
        ip: log.ip,
        userAgent: log.userAgent,
        createdAt: log.createdAt,
      };
    });

    return { items: enriched, total, page, limit };
  }
}
