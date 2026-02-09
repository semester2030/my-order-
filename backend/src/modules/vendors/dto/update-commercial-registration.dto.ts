import {
  IsString,
  IsNotEmpty,
  IsDateString,
  IsEnum,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { VerificationStatus } from '../enums';

export class UpdateCommercialRegistrationDto {
  @ApiProperty({ example: 'CR1234567890', description: 'Commercial registration number' })
  @IsString()
  @IsNotEmpty()
  commercialRegistrationNumber: string;

  @ApiProperty({ example: '2024-01-01', description: 'Issue date' })
  @IsDateString()
  @IsNotEmpty()
  commercialRegistrationIssueDate: string;

  @ApiProperty({ example: '2025-01-01', description: 'Expiry date' })
  @IsDateString()
  @IsNotEmpty()
  commercialRegistrationExpiryDate: string;
}
