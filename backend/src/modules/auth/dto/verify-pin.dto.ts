import { IsString, IsNotEmpty, Matches, ValidateIf } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class VerifyPinDto {
  @ApiProperty({
    example: '0501234567',
    description: 'Phone number or email (login identifier)',
  })
  @IsString()
  @IsNotEmpty()
  @ValidateIf((o) => typeof o.identifier === 'string' && !o.identifier.includes('@'))
  @Matches(/^[0-9]{10,15}$/, { message: 'Phone must be 10-15 digits' })
  @ValidateIf((o) => typeof o.identifier === 'string' && o.identifier.includes('@'))
  @Matches(/^[^\s@]+@[^\s@]+\.[^\s@]+$/, { message: 'Invalid email format' })
  identifier: string;

  @ApiProperty({ example: '1234', description: '4-digit PIN' })
  @IsString()
  @IsNotEmpty()
  @Matches(/^\d{4}$/, { message: 'PIN must be exactly 4 digits' })
  pin: string;
}
