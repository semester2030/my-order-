import { Controller, Get, Param } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { MenuService } from './menu.service';

@ApiTags('menu')
@Controller('menu')
export class MenuController {
  constructor(private readonly menuService: MenuService) {}

  @Get('vendor/:vendorId')
  @ApiOperation({ summary: 'Get vendor menu (public catalog)' })
  async getVendorMenu(@Param('vendorId') vendorId: string) {
    return this.menuService.getVendorMenu(vendorId);
  }

  @Get('signature/:vendorId')
  @ApiOperation({ summary: 'Get signature items (public catalog)' })
  async getSignatureItems(@Param('vendorId') vendorId: string) {
    return this.menuService.getSignatureItems(vendorId);
  }
}
