import {
  Injectable,
  UnauthorizedException,
  BadRequestException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { User } from '../users/entities/user.entity';
import { UsersService } from '../users/users.service';
import { OtpCacheService } from './services/otp-cache.service';
import { VendorsService } from '../vendors/vendors.service';

@Injectable()
export class AuthService {
  private readonly PIN_SALT_ROUNDS = 10;

  constructor(
    private readonly jwtService: JwtService,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly usersService: UsersService,
    private readonly otpCacheService: OtpCacheService,
    private readonly vendorsService: VendorsService,
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
    console.log(`OTP for ${trimmed}: ${otp}`); // Remove in production

    return {
      message: 'OTP sent successfully',
      expiresIn: 300,
      otp: process.env.NODE_ENV === 'development' ? otp : undefined,
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

  async vendorLogin(email: string, password: string) {
    // Find user by email
    const user = await this.userRepository.findOne({
      where: { email },
    });

    if (!user) {
      throw new UnauthorizedException('Invalid email or password');
    }

    // Check if user is a vendor staff member
    const vendorId = await this.vendorsService.getVendorIdByUserId(user.id);
    if (!vendorId) {
      throw new UnauthorizedException('User is not a vendor staff member');
    }

    // For testing: Check if this is the test account
    const TEST_EMAIL = 'cy-20@outlook.com';
    const TEST_PASSWORD = 'test123456';

    if (email === TEST_EMAIL && password === TEST_PASSWORD) {
      // Generate JWT tokens for test account
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
        user: {
          id: user.id,
          email: user.email,
          name: user.name || 'Test Vendor',
          phone: user.phone || '+966501234567',
        },
      };
    }

    // For other accounts, check password hash if exists
    // Note: In production, passwords should be hashed during registration
    // For now, we'll allow login if user exists and is vendor staff
    // In production, add passwordHash to User entity and verify it here
    if (user.pinHash) {
      const isPasswordValid = await bcrypt.compare(password, user.pinHash);
      if (!isPasswordValid) {
        throw new UnauthorizedException('Invalid email or password');
      }
    } else {
      throw new UnauthorizedException('Password not set. Please contact admin.');
    }

    // Generate JWT tokens
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
      user: {
        id: user.id,
        email: user.email,
        name: user.name || 'Vendor',
        phone: user.phone || '',
      },
    };
  }
}
