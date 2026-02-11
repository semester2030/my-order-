import {
  Injectable,
  UnauthorizedException,
  BadRequestException,
  InternalServerErrorException,
  Logger,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from '../users/entities/user.entity';
import { UsersService } from '../users/users.service';
import { OtpCacheService } from './services/otp-cache.service';
import { VendorsService } from '../vendors/vendors.service';
import { EmailService } from '../email/email.service';

@Injectable()
export class AuthService {
  private readonly PIN_SALT_ROUNDS = 10;
  private readonly logger = new Logger(AuthService.name);

  constructor(
    private readonly jwtService: JwtService,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly usersService: UsersService,
    private readonly otpCacheService: OtpCacheService,
    private readonly vendorsService: VendorsService,
    private readonly emailService: EmailService,
  ) {}

  async requestOtp(identifier: string) {
    const trimmed = identifier?.trim();
    if (!trimmed) {
      throw new BadRequestException('Phone or email is required');
    }
    const isEmail = trimmed.includes('@');
    if (isEmail) {
      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(trimmed)) {
        throw new BadRequestException('Invalid email format');
      }
    } else {
      if (trimmed.length < 10 || !/^[0-9]{10,15}$/.test(trimmed)) {
        throw new BadRequestException('Invalid phone number');
      }
    }

    const TEST_PHONE = '0500756756';
    const TEST_EMAIL = 'test@example.com';
    const TEST_OTP = '123456';

    let otp: string;
    if (trimmed === TEST_PHONE || trimmed === TEST_EMAIL) {
      otp = TEST_OTP;
    } else {
      otp = this.otpCacheService.generateOtp();
    }

    this.otpCacheService.storeOtp(trimmed, otp);
    this.logger.log(`OTP generated for ${trimmed}`);

    if (isEmail) {
      if (this.emailService.isConfigured()) {
        const sent = await this.emailService.sendOtp(trimmed, otp);
        const forceRaw = process.env.OTP_FORCE_WHITELIST ?? '';
        const inForceList = forceRaw.split(',').map((e) => e.trim().toLowerCase()).filter(Boolean).includes(trimmed.toLowerCase());
        if (!sent && !inForceList) {
          throw new InternalServerErrorException(
            'فشل إرسال رمز التحقق إلى بريدك. حاول مرة أخرى.',
          );
        }
      } else {
        // Email service not configured - fallback for testing only
        if (process.env.NODE_ENV === 'production') {
          throw new InternalServerErrorException(
            'خدمة البريد غير مهيأة. يرجى الاتصال بالدعم.',
          );
        }
        const whitelistRaw = process.env.OTP_DEV_WHITELIST ?? '';
        const whitelist = whitelistRaw
          .split(',')
          .map((e) => e.trim().toLowerCase())
          .filter(Boolean);
        const inWhitelist = whitelist.includes(trimmed.toLowerCase());
        if (!inWhitelist) {
          this.logger.warn(
            `OTP for ${trimmed}: Set RESEND_API_KEY to send emails, or add to OTP_DEV_WHITELIST for testing`,
          );
        }
      }
    }
    // Return OTP in response: (a) when email not sent, or (b) OTP_FORCE_WHITELIST (when Resend accepts but email doesn't arrive - spam/Outlook)
    const whitelistRaw = process.env.OTP_DEV_WHITELIST ?? '';
    const forceRaw = process.env.OTP_FORCE_WHITELIST ?? '';
    const whitelist = whitelistRaw.split(',').map((e) => e.trim().toLowerCase()).filter(Boolean);
    const forceList = forceRaw.split(',').map((e) => e.trim().toLowerCase()).filter(Boolean);
    const inWhitelist = whitelist.includes(trimmed.toLowerCase());
    const inForceList = forceList.includes(trimmed.toLowerCase());
    const shouldReturnOtp =
      (isEmail && !this.emailService.isConfigured() && (process.env.NODE_ENV === 'development' || inWhitelist)) ||
      (isEmail && inForceList);

    return {
      message: 'OTP sent successfully',
      expiresIn: 300,
      otp: shouldReturnOtp ? otp : undefined,
    };
  }

  async verifyOtp(identifier: string, code: string) {
    const trimmed = identifier?.trim();
    if (!trimmed || !code) {
      throw new BadRequestException('Phone/email and code are required');
    }

    const isValid = this.otpCacheService.verifyOtp(trimmed, code);
    if (!isValid) {
      throw new UnauthorizedException('Invalid or expired OTP');
    }

    let user = await this.usersService.findByIdentifier(trimmed);
    if (!user) {
      const isEmail = trimmed.includes('@');
      user = await this.usersService.create({
        phone: trimmed,
        ...(isEmail ? { email: trimmed } : {}),
        isVerified: true,
        isActive: true,
      });
    } else {
      user.isVerified = true;
      await this.userRepository.save(user);
    }

    const payload = {
      sub: user.id,
      userId: user.id,
      ...(user.phone ? { phone: user.phone } : {}),
      ...(user.email ? { email: user.email } : {}),
    };
    const accessToken = this.jwtService.sign(payload);
    const refreshToken = this.jwtService.sign(payload, { expiresIn: '30d' });

    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        phone: user.phone ?? null,
        name: user.name ?? null,
        email: user.email ?? null,
        isVerified: user.isVerified,
      },
    };
  }

  async setPin(userId: string, pin: string) {
    // Validate PIN (4 digits)
    if (!pin || pin.length !== 4 || !/^\d{4}$/.test(pin)) {
      throw new BadRequestException('PIN must be 4 digits');
    }

    // Find user
    const user = await this.usersService.findById(userId);

    if (!user) {
      throw new UnauthorizedException('User not found');
    }

    // Hash PIN
    const pinHash = await bcrypt.hash(pin, this.PIN_SALT_ROUNDS);

    // Update user
    user.pinHash = pinHash;
    await this.userRepository.save(user);

    return {
      message: 'PIN set successfully',
    };
  }

  async verifyPin(identifier: string, pin: string) {
    const trimmed = identifier?.trim();
    if (!trimmed || !pin) {
      throw new BadRequestException('Phone/email and PIN are required');
    }
    if (pin.length !== 4 || !/^\d{4}$/.test(pin)) {
      throw new BadRequestException('PIN must be 4 digits');
    }

    const user = await this.usersService.findByIdentifier(trimmed);
    if (!user) {
      throw new UnauthorizedException('User not found');
    }
    if (!user.pinHash) {
      throw new BadRequestException('PIN not set. Please set PIN first.');
    }

    const isPinValid = await bcrypt.compare(pin, user.pinHash);
    if (!isPinValid) {
      throw new UnauthorizedException('Invalid PIN');
    }

    const payload = {
      sub: user.id,
      userId: user.id,
      ...(user.phone ? { phone: user.phone } : {}),
      ...(user.email ? { email: user.email } : {}),
    };
    const accessToken = this.jwtService.sign(payload);
    const refreshToken = this.jwtService.sign(payload, { expiresIn: '30d' });

    return {
      accessToken,
      refreshToken,
      user: {
        id: user.id,
        phone: user.phone ?? null,
        name: user.name ?? null,
        email: user.email ?? null,
        isVerified: user.isVerified,
      },
    };
  }

  async refreshToken(refreshToken: string) {
    if (!refreshToken) {
      throw new BadRequestException('Refresh token is required');
    }

    try {
      const payload = this.jwtService.verify(refreshToken);

      // Verify user still exists
      const user = await this.usersService.findById(payload.sub || payload.userId);

      if (!user || !user.isActive) {
        throw new UnauthorizedException('User not found or inactive');
      }

      // Generate new tokens
      const newPayload = {
        sub: user.id,
        userId: user.id,
        ...(user.phone ? { phone: user.phone } : {}),
        ...(user.email ? { email: user.email } : {}),
      };

      return {
        accessToken: this.jwtService.sign(newPayload),
        refreshToken: this.jwtService.sign(newPayload, { expiresIn: '30d' }),
      };
    } catch (error) {
      if (error instanceof UnauthorizedException) {
        throw error;
      }
      throw new UnauthorizedException('Invalid or expired refresh token');
    }
  }

  async logout() {
    // In a production app, you might want to:
    // - Store refresh tokens in a blacklist
    // - Clear session data
    // For now, client-side token removal is sufficient
    return {
      message: 'Logged out successfully',
    };
  }

  async validateUser(userId: string): Promise<User | null> {
    const user = await this.usersService.findById(userId);
    if (!user || !user.isActive) {
      return null;
    }
    return user;
  }

  async customerRegister(name: string, email: string, password: string) {
    const nameTrim = (name || '').trim();
    const emailNorm = (email || '').trim().toLowerCase();
    const passwordTrim = (password || '').trim();
    if (!nameTrim) throw new BadRequestException('الاسم مطلوب.');
    if (!emailNorm) throw new BadRequestException('البريد الإلكتروني مطلوب.');
    if (!passwordTrim) throw new BadRequestException('الرمز السري مطلوب.');
    if (passwordTrim.length < 6) throw new BadRequestException('الرمز السري يجب أن يكون 6 أحرف على الأقل.');
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailNorm)) throw new BadRequestException('بريد إلكتروني غير صحيح.');

    const existing = await this.userRepository
      .createQueryBuilder('u')
      .where('LOWER(TRIM(u.email)) = :email', { email: emailNorm })
      .getOne();
    if (existing) throw new BadRequestException('البريد مسجّل مسبقاً. سجّل الدخول أو استخدم بريداً آخر.');

    const hashedPassword = await bcrypt.hash(passwordTrim, this.PIN_SALT_ROUNDS);
    const user = await this.usersService.create({
      phone: null,
      email: emailNorm,
      name: nameTrim,
      pinHash: hashedPassword,
      isVerified: true,
      isActive: true,
    });

    const payload = { sub: user.id, userId: user.id, email: user.email };
    return {
      accessToken: this.jwtService.sign(payload),
      refreshToken: this.jwtService.sign(payload, { expiresIn: '30d' }),
      expiresIn: 3600,
      user: { id: user.id, email: user.email, name: user.name, phone: user.phone },
    };
  }

  async customerLogin(email: string, password: string) {
    const emailNorm = (email || '').trim().toLowerCase();
    const passwordTrim = (password || '').trim();
    if (!emailNorm) throw new UnauthorizedException('البريد الإلكتروني مطلوب.');
    if (!passwordTrim) throw new UnauthorizedException('الرمز السري مطلوب.');

    const user = await this.userRepository
      .createQueryBuilder('u')
      .where('LOWER(TRIM(u.email)) = :email', { email: emailNorm })
      .getOne();
    if (!user) throw new UnauthorizedException('البريد غير مسجّل. سجّل حساباً جديداً أولاً.');
    if (!user.pinHash) throw new UnauthorizedException('هذا الحساب غير مضبوط. تواصل مع الدعم.');

    const vendorId = await this.vendorsService.getVendorIdByUserId(user.id);
    if (vendorId) throw new UnauthorizedException('هذا حساب مقدم خدمة. استخدم تطبيق المورد.');

    const isPasswordValid = await bcrypt.compare(passwordTrim, user.pinHash);
    if (!isPasswordValid) throw new UnauthorizedException('الرمز السري غير صحيح.');

    const payload = { sub: user.id, userId: user.id, email: user.email };
    return {
      accessToken: this.jwtService.sign(payload),
      refreshToken: this.jwtService.sign(payload, { expiresIn: '30d' }),
      expiresIn: 3600,
      user: { id: user.id, email: user.email, name: user.name, phone: user.phone },
    };
  }

  async vendorLogin(email: string, password: string) {
    try {
      const emailNorm = (email || '').trim().toLowerCase();
      const passwordTrim = (password || '').trim();
      if (!emailNorm) {
        throw new UnauthorizedException('البريد الإلكتروني مطلوب.');
      }
      if (!passwordTrim) {
        throw new UnauthorizedException('كلمة المرور مطلوبة.');
      }
      // Find user by email (case-insensitive)
      const user = await this.userRepository
        .createQueryBuilder('u')
        .where('LOWER(TRIM(u.email)) = :email', { email: emailNorm })
        .getOne();

      if (!user) {
        throw new UnauthorizedException(
          'البريد الإلكتروني غير مسجّل. تأكد من البريد أو سجّل حساباً جديداً.',
        );
      }

      const vendorId = await this.vendorsService.getVendorIdByUserId(user.id);
      if (!vendorId) {
        throw new UnauthorizedException(
          'هذا الحساب ليس حساب مقدم خدمة. استخدم بريداً مسجلاً من تطبيق مقدم الخدمة.',
        );
      }

      // Test account bypass
      const TEST_EMAIL = 'cy-20@outlook.com';
      const TEST_PASSWORD = 'test123456';
      if (emailNorm === TEST_EMAIL.toLowerCase() && passwordTrim === TEST_PASSWORD) {
        const payload = {
          email: user.email,
          sub: user.id,
          userId: user.id,
          vendorId,
        };
        const accessToken = this.jwtService.sign(payload);
        const refreshToken = this.jwtService.sign(payload, { expiresIn: '30d' });
        return {
          accessToken,
          refreshToken,
          expiresIn: 3600,
          user: {
            id: user.id,
            email: user.email,
            name: user.name || 'Test Vendor',
            phone: user.phone || '+966501234567',
          },
        };
      }

      if (!user.pinHash) {
        throw new UnauthorizedException(
          'كلمة المرور غير مضبوطة لهذا الحساب. تواصل مع الدعم.',
        );
      }
      const isPasswordValid = await bcrypt.compare(passwordTrim, user.pinHash);
      if (!isPasswordValid) {
        throw new UnauthorizedException(
          'كلمة المرور غير صحيحة. تأكد من كتابة كلمة المرور بشكل صحيح.',
        );
      }

      const payload = {
        email: user.email,
        sub: user.id,
        userId: user.id,
        vendorId,
      };
      const accessToken = this.jwtService.sign(payload);
      const refreshToken = this.jwtService.sign(payload, { expiresIn: '30d' });
      return {
        accessToken,
        refreshToken,
        expiresIn: 3600,
        user: {
          id: user.id,
          email: user.email,
          name: user.name || 'Vendor',
          phone: user.phone || '',
        },
      };
    } catch (err: any) {
      if (err instanceof UnauthorizedException) {
        throw err;
      }
      this.logger.error(
        `vendorLogin failed: ${err?.message ?? err}`,
        err?.stack,
      );
      throw new InternalServerErrorException(
        'خطأ في الاتصال بالخادم. تحقق من الإنترنت وحاول مرة أخرى.',
      );
    }
  }
}
