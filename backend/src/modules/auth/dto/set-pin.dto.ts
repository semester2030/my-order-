import { IsString, IsNotEmpty, Matches } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class SetPinDto {
  @ApiProperty({ example: '1234', description: '4-digit PIN' })
  @IsString()
  @IsNotEmpty()
  @Matches(/^\d{4}$/, {
    message: 'PIN must be exactly 4 digits',
  })
  pin: string;
}
