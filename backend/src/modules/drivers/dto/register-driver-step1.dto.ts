import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsNotEmpty,
  Matches,
  Length,
  IsOptional,
} from 'class-validator';

export class RegisterDriverStep1Dto {
  @ApiProperty({
    example: '1234567890',
    description: 'National ID or Iqama number',
  })
  @IsString()
  @IsNotEmpty()
  @Length(10, 10, { message: 'National ID must be exactly 10 digits' })
  @Matches(/^[0-9]+$/, { message: 'National ID must contain only digits' })
  nationalId: string;

  @ApiProperty({
    example: '0501234567',
    description: 'Mobile phone number',
  })
  @IsString()
  @IsNotEmpty()
  @Matches(/^[0-9+\-\s()]+$/, {
    message: 'Phone number must contain only digits, +, -, spaces, or parentheses',
  })
  phoneNumber: string;
}
