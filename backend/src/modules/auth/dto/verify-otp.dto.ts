import { IsString, IsNotEmpty, Matches, Length, ValidateIf } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class VerifyOtpDto {
  @ApiProperty({
    example: '0501234567',
    description: 'Phone number or email (same as request OTP)',
  })
  @IsString()
  @IsNotEmpty()
  @ValidateIf((o) => typeof o.identifier === 'string' && !o.identifier.includes('@'))
  @Matches(/^[0-9]{10,15}$/, { message: 'Phone must be 10-15 digits' })
  @ValidateIf((o) => typeof o.identifier === 'string' && o.identifier.includes('@'))
  @Matches(/^[^\s@]+@[^\s@]+\.[^\s@]+$/, { message: 'Invalid email format' })
  identifier: string;

  @ApiProperty({ example: '123456', description: '6-digit OTP code' })
  @IsString()
  @IsNotEmpty()
  @Length(6, 6, { message: 'OTP must be 6 digits' })
  code: string;
}
