import {
  Controller,
  Post,
  Body,
  HttpCode,
  HttpStatus,
  UseGuards,
  Request,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { User } from '../users/entities/user.entity';
import { RequestOtpDto } from './dto/request-otp.dto';
import { VerifyOtpDto } from './dto/verify-otp.dto';
import { SetPinDto } from './dto/set-pin.dto';
import { VerifyPinDto } from './dto/verify-pin.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { VendorLoginDto } from './dto/vendor-login.dto';
import { CustomerRegisterDto } from './dto/customer-register.dto';
import { CustomerLoginDto } from './dto/customer-login.dto';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('otp/request')
  @ApiOperation({ summary: 'Request OTP (phone or email)' })
  @HttpCode(HttpStatus.OK)
  async requestOtp(@Body() dto: RequestOtpDto) {
    return this.authService.requestOtp(dto.identifier);
  }

  @Post('otp/verify')
  @ApiOperation({ summary: 'Verify OTP' })
  @HttpCode(HttpStatus.OK)
  async verifyOtp(@Body() dto: VerifyOtpDto) {
    return this.authService.verifyOtp(dto.identifier, dto.code);
  }

  @Post('pin/set')
  @ApiOperation({ summary: 'Set PIN' })
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @HttpCode(HttpStatus.OK)
  async setPin(@Request() req: { user: User }, @Body() dto: SetPinDto) {
    return this.authService.setPin(req.user.id, dto.pin);
  }

  @Post('pin/verify')
  @ApiOperation({ summary: 'Verify PIN' })
  @HttpCode(HttpStatus.OK)
  async verifyPin(@Body() dto: VerifyPinDto) {
    return this.authService.verifyPin(dto.identifier, dto.pin);
  }

  @Post('refresh')
  @ApiOperation({ summary: 'Refresh token' })
  @HttpCode(HttpStatus.OK)
  async refreshToken(@Body() dto: RefreshTokenDto) {
    return this.authService.refreshToken(dto.refreshToken);
  }

  @Post('customer/register')
  @ApiOperation({ summary: 'Customer register (name, email, password)' })
  @HttpCode(HttpStatus.CREATED)
  async customerRegister(@Body() dto: CustomerRegisterDto) {
    return this.authService.customerRegister(dto.name, dto.email, dto.password);
  }

  @Post('customer/login')
  @ApiOperation({ summary: 'Customer login (email, password)' })
  @HttpCode(HttpStatus.OK)
  async customerLogin(@Body() dto: CustomerLoginDto) {
    return this.authService.customerLogin(dto.email, dto.password);
  }

  @Post('vendor/login')
  @ApiOperation({ summary: 'Vendor login with email/password' })
  @HttpCode(HttpStatus.OK)
  async vendorLogin(@Body() dto: VendorLoginDto) {
    return this.authService.vendorLogin(dto.email, dto.password);
  }

  @Post('logout')
  @ApiOperation({ summary: 'Logout' })
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @HttpCode(HttpStatus.OK)
  async logout(@Request() req: { user: User }) {
    return this.authService.logout();
  }
}
