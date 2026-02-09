import { IsString, IsNotEmpty, Matches, ValidateIf } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

/**
 * Identifier: phone (10-15 digits) OR email.
 * Backend treats value as email if it contains '@', otherwise as phone.
 */
export class RequestOtpDto {
  @ApiProperty({
    example: '0501234567',
    description: 'Phone number (10-15 digits) or email address',
  })
  @IsString()
  @IsNotEmpty({ message: 'Phone or email is required' })
  @ValidateIf((o) => typeof o.identifier === 'string' && !o.identifier.includes('@'))
  @Matches(/^[0-9]{10,15}$/, { message: 'Phone must be 10-15 digits' })
  @ValidateIf((o) => typeof o.identifier === 'string' && o.identifier.includes('@'))
  @Matches(/^[^\s@]+@[^\s@]+\.[^\s@]+$/, { message: 'Invalid email format' })
  identifier: string;
}
