import {
  Controller,
  Post,
  Get,
  Body,
  HttpCode,
  HttpStatus,
  UseGuards,
  Request,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { AdminAuthService, AdminTokenPayload } from './admin-auth.service';
import { AdminLoginDto } from './dto/admin-login.dto';
import { AdminJwtGuard } from './guards/admin-jwt.guard';

@ApiTags('admin-auth')
@Controller('admin/auth')
export class AdminAuthController {
  constructor(private readonly adminAuthService: AdminAuthService) {}

  @Post('login')
  @ApiOperation({ summary: 'Admin login' })
  @HttpCode(HttpStatus.OK)
  async login(@Body() dto: AdminLoginDto) {
    return this.adminAuthService.login(dto.email, dto.password);
  }

  @Post('refresh')
  @ApiOperation({ summary: 'Refresh admin token' })
  @HttpCode(HttpStatus.OK)
  @UseGuards(AdminJwtGuard)
  @ApiBearerAuth('admin')
  async refresh(@Request() req: { user: AdminTokenPayload }) {
    return this.adminAuthService.refreshFromToken(req.user);
  }

  @Get('me')
  @ApiOperation({ summary: 'Get current admin (validate token)' })
  @UseGuards(AdminJwtGuard)
  @ApiBearerAuth('admin')
  async me(@Request() req: { user: AdminTokenPayload }) {
    const admin = await this.adminAuthService.validateAdminById(req.user.sub);
    if (!admin) {
      return null;
    }
    return {
      id: admin.id,
      email: admin.email,
      name: admin.name,
      role: admin.role.slug,
    };
  }
}
