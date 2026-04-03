import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { VENDOR_ONBOARDING_JWT_SCOPE } from '../../vendors/constants/onboarding.constants';

/**
 * يقتصر المسار على JWT بـ scope vendor_onboarding (بعد JwtAuthGuard).
 */
@Injectable()
export class VendorOnboardingJwtGuard implements CanActivate {
  constructor(
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
  ) {}

  canActivate(context: ExecutionContext): boolean {
    const req = context.switchToHttp().getRequest<{ headers?: { authorization?: string } }>();
    const raw = req.headers?.authorization?.replace(/^Bearer\s+/i, '')?.trim();
    if (!raw) {
      throw new UnauthorizedException();
    }
    try {
      const payload = this.jwtService.verify(raw, {
        secret: this.configService.get<string>('JWT_SECRET'),
      }) as { scope?: string };
      if (payload.scope !== VENDOR_ONBOARDING_JWT_SCOPE) {
        throw new ForbiddenException(
          'هذا الإجراء متاح فقط خلال إكمال التسجيل (قبل اعتماد الإدارة).',
        );
      }
      return true;
    } catch (e) {
      if (e instanceof ForbiddenException) {
        throw e;
      }
      throw new UnauthorizedException();
    }
  }
}
