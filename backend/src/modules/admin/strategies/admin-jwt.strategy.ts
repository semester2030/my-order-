import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { ConfigService } from '@nestjs/config';
import { AdminAuthService, AdminTokenPayload, ADMIN_JWT_TYPE } from '../admin-auth.service';

const STRATEGY_NAME = 'admin-jwt';

@Injectable()
export class AdminJwtStrategy extends PassportStrategy(Strategy, STRATEGY_NAME) {
  constructor(
    private configService: ConfigService,
    private adminAuthService: AdminAuthService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      secretOrKey: configService.get<string>('JWT_SECRET'),
    });
  }

  async validate(payload: Record<string, unknown>): Promise<AdminTokenPayload> {
    if (payload.type !== ADMIN_JWT_TYPE) {
      throw new UnauthorizedException('Invalid token type for admin');
    }
    const admin = await this.adminAuthService.validateAdminById(
      String(payload.sub),
    );
    if (!admin) {
      throw new UnauthorizedException('Admin not found or inactive');
    }
    return {
      sub: admin.id,
      email: admin.email,
      role: admin.role.slug,
      type: ADMIN_JWT_TYPE,
    };
  }
}
