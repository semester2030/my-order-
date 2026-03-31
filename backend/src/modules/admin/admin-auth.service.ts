import {
  Injectable,
  UnauthorizedException,
  ForbiddenException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { AdminUser } from './entities/admin-user.entity';
import { AuditService } from './audit.service';
import { AUDIT_SYSTEM_ACTOR_ID } from './constants';

export const ADMIN_JWT_TYPE = 'admin';

export interface AdminTokenPayload {
  sub: string;
  email: string;
  role: string;
  type: typeof ADMIN_JWT_TYPE;
}

export interface AdminAuthResult {
  accessToken: string;
  expiresIn: number;
  admin: {
    id: string;
    email: string;
    name: string;
    role: string;
  };
}

type ReqForAudit = { ip?: string; headers?: { 'user-agent'?: string } };

@Injectable()
export class AdminAuthService {
  constructor(
    @InjectRepository(AdminUser)
    private readonly adminUserRepo: Repository<AdminUser>,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
    private readonly auditService: AuditService,
  ) {}

  async login(
    email: string,
    password: string,
    req?: ReqForAudit,
  ): Promise<AdminAuthResult> {
    const normalized = email.toLowerCase().trim();
    const admin = await this.adminUserRepo.findOne({
      where: { email: normalized },
      relations: ['role'],
    });

    const logFail = async (
      entityId: string,
      newValue: Record<string, unknown>,
    ) => {
      await this.auditService.log({
        actorId: AUDIT_SYSTEM_ACTOR_ID,
        action: 'ADMIN_LOGIN_FAILED',
        entityType: 'admin_auth',
        entityId,
        newValue,
        req,
      });
    };

    if (!admin) {
      await logFail(normalized, { reason: 'unknown_email' });
      throw new UnauthorizedException('Invalid email or password');
    }

    if (!admin.isActive) {
      await logFail(admin.id, {
        reason: 'inactive_account',
        email: normalized,
      });
      throw new ForbiddenException('Account is deactivated');
    }

    const isPasswordValid = await bcrypt.compare(password, admin.passwordHash);
    if (!isPasswordValid) {
      await logFail(admin.id, {
        reason: 'invalid_password',
        email: normalized,
      });
      throw new UnauthorizedException('Invalid email or password');
    }

    const payload: AdminTokenPayload = {
      sub: admin.id,
      email: admin.email,
      role: admin.role.slug,
      type: ADMIN_JWT_TYPE,
    };

    const expiresInStr = this.configService.get<string>('JWT_EXPIRES_IN', '7d');
    const expiresInSeconds = this.parseExpiresIn(expiresInStr);

    const accessToken = this.jwtService.sign(payload, {
      expiresIn: expiresInStr,
    });

    await this.auditService.log({
      actorId: admin.id,
      action: 'ADMIN_LOGIN_SUCCESS',
      entityType: 'admin_user',
      entityId: admin.id,
      newValue: { email: admin.email },
      req,
    });

    return {
      accessToken,
      expiresIn: expiresInSeconds,
      admin: {
        id: admin.id,
        email: admin.email,
        name: admin.name,
        role: admin.role.slug,
      },
    };
  }

  async logout(adminId: string, req?: ReqForAudit): Promise<{ ok: true }> {
    const admin = await this.adminUserRepo.findOne({
      where: { id: adminId },
    });
    if (admin) {
      await this.auditService.log({
        actorId: adminId,
        action: 'ADMIN_LOGOUT',
        entityType: 'admin_user',
        entityId: adminId,
        newValue: { email: admin.email },
        req,
      });
    }
    return { ok: true };
  }

  async refreshFromToken(
    currentTokenPayload: AdminTokenPayload,
  ): Promise<AdminAuthResult> {
    if (currentTokenPayload.type !== ADMIN_JWT_TYPE) {
      throw new UnauthorizedException('Invalid token type');
    }

    const admin = await this.validateAdminById(currentTokenPayload.sub);
    if (!admin) {
      throw new UnauthorizedException('Admin not found or inactive');
    }

    const payload: AdminTokenPayload = {
      sub: admin.id,
      email: admin.email,
      role: admin.role.slug,
      type: ADMIN_JWT_TYPE,
    };

    const expiresInStr = this.configService.get<string>('JWT_EXPIRES_IN', '7d');
    const expiresInSeconds = this.parseExpiresIn(expiresInStr);

    const accessToken = this.jwtService.sign(payload, {
      expiresIn: expiresInStr,
    });

    return {
      accessToken,
      expiresIn: expiresInSeconds,
      admin: {
        id: admin.id,
        email: admin.email,
        name: admin.name,
        role: admin.role.slug,
      },
    };
  }

  private parseExpiresIn(expiresIn: string): number {
    const num = parseInt(expiresIn.replace(/\D/g, ''), 10) || 7;
    if (expiresIn.includes('d')) return num * 86400;
    if (expiresIn.includes('h')) return num * 3600;
    return num * 86400;
  }

  async validateAdminById(adminId: string): Promise<AdminUser | null> {
    const admin = await this.adminUserRepo.findOne({
      where: { id: adminId, isActive: true },
      relations: ['role'],
    });
    return admin ?? null;
  }
}
