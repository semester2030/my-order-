import { Controller, Get, Param, UseGuards } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { MenuService } from './menu.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('menu')
@Controller('menu')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class MenuController {
  constructor(private readonly menuService: MenuService) {}

  @Get('vendor/:vendorId')
  @ApiOperation({ summary: 'Get vendor menu' })
  async getVendorMenu(@Param('vendorId') vendorId: string) {
    return this.menuService.getVendorMenu(vendorId);
  }

  @Get('signature/:vendorId')
  @ApiOperation({ summary: 'Get signature items' })
  async getSignatureItems(@Param('vendorId') vendorId: string) {
    return this.menuService.getSignatureItems(vendorId);
  }
}
