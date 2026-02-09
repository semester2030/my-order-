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

@Injectable()
export class AdminAuthService {
  constructor(
    @InjectRepository(AdminUser)
    private readonly adminUserRepo: Repository<AdminUser>,
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  async login(email: string, password: string): Promise<AdminAuthResult> {
    const admin = await this.adminUserRepo.findOne({
      where: { email: email.toLowerCase().trim() },
      relations: ['role'],
    });

    if (!admin) {
      throw new UnauthorizedException('Invalid email or password');
    }

    if (!admin.isActive) {
      throw new ForbiddenException('Account is deactivated');
    }

    const isPasswordValid = await bcrypt.compare(password, admin.passwordHash);
    if (!isPasswordValid) {
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

  async refreshFromToken(currentTokenPayload: AdminTokenPayload): Promise<AdminAuthResult> {
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
