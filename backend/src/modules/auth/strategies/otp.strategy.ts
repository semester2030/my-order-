import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-local';
import { AuthService } from '../auth.service';

@Injectable()
export class OtpStrategy extends PassportStrategy(Strategy, 'otp') {
  constructor(private authService: AuthService) {
    super({
      usernameField: 'identifier',
      passwordField: 'code',
    });
  }

  async validate(identifier: string, code: string): Promise<any> {
    const result = await this.authService.verifyOtp(identifier, code);
    if (!result?.user) {
      throw new UnauthorizedException();
    }
    return result.user;
  }
}
