import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { VendorsService } from '../../vendors/vendors.service';
import { VENDOR_ONBOARDING_JWT_SCOPE } from '../../vendors/constants/onboarding.constants';

/**
 * يقبل JWT بـ scope vendor_onboarding (قبل الاعتماد) أو تسجيل دخول مقدّم معتمد
 * لإكمال التحقق من البريد وقبول اللوائح بعد اعتماد الإدارة.
 */
@Injectable()
export class VendorOnboardingOrApprovedJwtGuard implements CanActivate {
  constructor(
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService,
    private readonly vendorsService: VendorsService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const req = context.switchToHttp().getRequest<{
      headers?: { authorization?: string };
      user?: { id?: string };
    }>();
    const raw = req.headers?.authorization?.replace(/^Bearer\s+/i, '')?.trim();
    if (!raw) {
      throw new UnauthorizedException();
    }
    const userId = req.user?.id;
    if (!userId) {
      throw new UnauthorizedException();
    }
    try {
      const payload = this.jwtService.verify(raw, {
        secret: this.configService.get<string>('JWT_SECRET'),
      }) as { scope?: string };
      if (payload.scope === VENDOR_ONBOARDING_JWT_SCOPE) {
        await this.vendorsService.assertOnboardingJwtAllowed(userId);
        return true;
      }
      await this.vendorsService.assertVendorApprovedForApiAccess(userId);
      return true;
    } catch (e) {
      if (e instanceof ForbiddenException) {
        throw e;
      }
      throw new UnauthorizedException();
    }
  }
}
