import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { VendorsService } from '../vendors.service';

/**
 * بعد JwtAuthGuard — يمنع أي طلب لواجهات المزوّد إن لم يكن ملف المزوّد معتمداً من الإدارة.
 */
@Injectable()
export class ApprovedVendorGuard implements CanActivate {
  constructor(private readonly vendorsService: VendorsService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const req = context.switchToHttp().getRequest<{ user?: { id?: string } }>();
    const userId = req.user?.id;
    if (!userId) {
      throw new UnauthorizedException();
    }
    await this.vendorsService.assertVendorApprovedForApiAccess(userId);
    return true;
  }
}
