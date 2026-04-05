import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { VendorsService } from '../vendors.service';

/**
 * بعد JwtAuthGuard + ApprovedVendorGuard — يمنع إضافة وجبات/رفع فيديو وما شابه
 * حتى يُتحقق البريد ويُقبل إصدار اللوائح (مرحلة ثانية بعد اعتماد الإدارة).
 */
@Injectable()
export class VendorOperationalComplianceGuard implements CanActivate {
  constructor(private readonly vendorsService: VendorsService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const req = context.switchToHttp().getRequest<{ user?: { id?: string } }>();
    const userId = req.user?.id;
    if (!userId) {
      throw new UnauthorizedException();
    }
    await this.vendorsService.assertVendorOperationalCompliance(userId);
    return true;
  }
}
