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
import { AuthService } from './auth.service';
import { JwtAuthGuard } from './guards/jwt-auth.guard';
import { VendorOnboardingOrApprovedJwtGuard } from './guards/vendor-onboarding-or-approved-jwt.guard';
import { VendorsService } from '../vendors/vendors.service';
import { User } from '../users/entities/user.entity';
import { RequestOtpDto } from './dto/request-otp.dto';
import { VerifyOtpDto } from './dto/verify-otp.dto';
import { SetPinDto } from './dto/set-pin.dto';
import { VerifyPinDto } from './dto/verify-pin.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { VendorLoginDto } from './dto/vendor-login.dto';
import { CustomerRegisterDto } from './dto/customer-register.dto';
import { CustomerLoginDto } from './dto/customer-login.dto';
import {
  VendorOnboardingVerifyEmailDto,
  VendorOnboardingAcceptLegalDto,
} from './dto/vendor-onboarding.dto';
import { DeleteAccountDto } from './dto/delete-account.dto';
import { VendorPasswordResetRequestDto } from './dto/vendor-password-reset-request.dto';
import { VendorPasswordResetConfirmDto } from './dto/vendor-password-reset-confirm.dto';

@ApiTags('auth')
@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly vendorsService: VendorsService,
  ) {}

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

  @Post('vendor/password-reset/request')
  @ApiOperation({
    summary: 'طلب رمز استعادة كلمة مرور مقدّم الخدمة (يُرسل للبريد)',
  })
  @HttpCode(HttpStatus.OK)
  async vendorPasswordResetRequest(@Body() dto: VendorPasswordResetRequestDto) {
    return this.authService.requestVendorPasswordReset(dto.email);
  }

  @Post('vendor/password-reset/confirm')
  @ApiOperation({ summary: 'تأكيد الرمز وتعيين كلمة مرور جديدة (مقدّم خدمة)' })
  @HttpCode(HttpStatus.OK)
  async vendorPasswordResetConfirm(
    @Body() dto: VendorPasswordResetConfirmDto,
  ) {
    return this.authService.confirmVendorPasswordReset(
      dto.email,
      dto.code,
      dto.newPassword,
    );
  }

  @Post('vendor/onboarding/email/request-otp')
  @UseGuards(JwtAuthGuard, VendorOnboardingOrApprovedJwtGuard)
  @ApiBearerAuth()
  @ApiOperation({
    summary:
      'طلب رمز تحقق البريد (JWT إكمال التسجيل أو تسجيل دخول مقدّم معتمد لإنهاء المرحلة الثانية)',
  })
  @HttpCode(HttpStatus.OK)
  async vendorOnboardingRequestEmailOtp(@Request() req: { user: User }) {
    return this.vendorsService.requestVendorEmailVerificationOtp(req.user.id);
  }

  @Post('vendor/onboarding/email/verify')
  @UseGuards(JwtAuthGuard, VendorOnboardingOrApprovedJwtGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'تأكيد البريد برمز OTP' })
  @HttpCode(HttpStatus.OK)
  async vendorOnboardingVerifyEmail(
    @Request() req: { user: User },
    @Body() dto: VendorOnboardingVerifyEmailDto,
  ) {
    await this.vendorsService.confirmVendorEmailWithOtp(req.user.id, dto.code);
    return { success: true };
  }

  @Post('vendor/onboarding/legal/accept')
  @UseGuards(JwtAuthGuard, VendorOnboardingOrApprovedJwtGuard)
  @ApiBearerAuth()
  @ApiOperation({
    summary: 'قبول اللوائح — documentVersion يجب أن يطابق إصدار الخادم',
  })
  @HttpCode(HttpStatus.OK)
  async vendorOnboardingAcceptLegal(
    @Request() req: { user: User },
    @Body() dto: VendorOnboardingAcceptLegalDto,
  ) {
    await this.vendorsService.acceptVendorLegalDocument(
      req.user.id,
      dto.documentVersion,
    );
    return { success: true };
  }

  @Get('vendor/onboarding/status')
  @UseGuards(JwtAuthGuard, VendorOnboardingOrApprovedJwtGuard)
  @ApiBearerAuth()
  @ApiOperation({ summary: 'حالة إكمال التسجيل (بريد، لوائح، حالة الطلب)' })
  async vendorOnboardingStatus(@Request() req: { user: User }) {
    return this.vendorsService.getVendorOnboardingChecklist(req.user.id);
  }

  @Post('logout')
  @ApiOperation({ summary: 'Logout' })
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @HttpCode(HttpStatus.OK)
  async logout() {
    return this.authService.logout();
  }

  @Post('account/delete')
  @ApiOperation({
    summary:
      'حذف الحساب أو إلغاء تعريفه (عميل / مالك مقدّم خدمة / عضو فريق) — يتطلب كلمة المرور',
  })
  @UseGuards(JwtAuthGuard)
  @ApiBearerAuth()
  @HttpCode(HttpStatus.OK)
  async deleteAccount(
    @Request() req: { user: User },
    @Body() dto: DeleteAccountDto,
  ) {
    await this.authService.deleteMyAccount(req.user.id, dto.currentPassword);
    return { success: true };
  }
}
