import { Injectable, UnauthorizedException } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { Strategy } from 'passport-local';
import { AuthService } from '../auth.service';

@Injectable()
export class PinStrategy extends PassportStrategy(Strategy, 'pin') {
  constructor(private authService: AuthService) {
    super({
      usernameField: 'identifier',
      passwordField: 'pin',
    });
  }

  async validate(identifier: string, pin: string): Promise<any> {
    const result = await this.authService.verifyPin(identifier, pin);
    if (!result?.user) {
      throw new UnauthorizedException();
    }
    return result.user;
  }
}
