import { Controller, Get, Post, Body, Put, Param, Delete, UseGuards, Request } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { AddressesService } from './addresses.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { User } from '../users/entities/user.entity';

@ApiTags('addresses')
@Controller('addresses')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class AddressesController {
  constructor(private readonly addressesService: AddressesService) {}

  @Get()
  @ApiOperation({ summary: 'Get user addresses' })
  async getAddresses(@Request() req: { user: User }) {
    return this.addressesService.getAddresses(req.user.id);
  }

  @Get('default')
  @ApiOperation({ summary: 'Get default address' })
  async getDefaultAddress(@Request() req: { user: User }) {
    return this.addressesService.getDefaultAddress(req.user.id);
  }

  @Post()
  @ApiOperation({ summary: 'Add new address' })
  async addAddress(@Request() req: { user: User }, @Body() body: any) {
    return this.addressesService.addAddress(req.user.id, body);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update address' })
  async updateAddress(
    @Request() req: { user: User },
    @Param('id') id: string,
    @Body() body: any,
  ) {
    return this.addressesService.updateAddress(req.user.id, id, body);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete address' })
  async deleteAddress(@Request() req: { user: User }, @Param('id') id: string) {
    return this.addressesService.deleteAddress(req.user.id, id);
  }
}
