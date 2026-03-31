import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  Param,
  UseGuards,
  Request,
  Req,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import type { Request as ExpressRequest } from 'express';
import { AdminUsersService } from './admin-users.service';
import { AdminJwtGuard } from './guards/admin-jwt.guard';
import { RolesGuard } from './guards/roles.guard';
import { Roles } from './decorators/roles.decorator';
import { AdminTokenPayload } from './admin-auth.service';
import { CreateAdminUserDto } from './dto/create-admin-user.dto';
import { UpdateAdminUserDto } from './dto/update-admin-user.dto';
import { ResetAdminPasswordDto } from './dto/reset-admin-password.dto';

@ApiTags('admin')
@Controller('admin/users')
@UseGuards(AdminJwtGuard, RolesGuard)
@Roles('super_admin')
@ApiBearerAuth('admin')
export class AdminUsersController {
  constructor(private readonly adminUsersService: AdminUsersService) {}

  @Get('roles')
  @ApiOperation({ summary: 'List admin roles (for forms)' })
  async listRoles() {
    return { roles: await this.adminUsersService.listRoles() };
  }

  @Get()
  @ApiOperation({ summary: 'List admin users' })
  async listUsers() {
    return { items: await this.adminUsersService.listUsers() };
  }

  @Post()
  @ApiOperation({ summary: 'Create admin user' })
  async create(
    @Body() dto: CreateAdminUserDto,
    @Request() auth: { user: AdminTokenPayload },
    @Req() req: ExpressRequest,
  ) {
    return this.adminUsersService.createUser(dto, auth.user.sub, {
      ip: req.ip,
      headers: req.headers as { 'user-agent'?: string },
    });
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update admin user (name, role, active)' })
  async update(
    @Param('id') id: string,
    @Body() dto: UpdateAdminUserDto,
    @Request() auth: { user: AdminTokenPayload },
    @Req() req: ExpressRequest,
  ) {
    return this.adminUsersService.updateUser(id, dto, auth.user.sub, {
      ip: req.ip,
      headers: req.headers as { 'user-agent'?: string },
    });
  }

  @Post(':id/reset-password')
  @ApiOperation({ summary: 'Reset admin user password' })
  async resetPassword(
    @Param('id') id: string,
    @Body() dto: ResetAdminPasswordDto,
    @Request() auth: { user: AdminTokenPayload },
    @Req() req: ExpressRequest,
  ) {
    return this.adminUsersService.resetPassword(
      id,
      dto.password,
      auth.user.sub,
      {
        ip: req.ip,
        headers: req.headers as { 'user-agent'?: string },
      },
    );
  }
}
