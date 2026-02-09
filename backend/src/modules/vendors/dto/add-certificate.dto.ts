import {
  IsString,
  IsNotEmpty,
  IsDateString,
  IsEnum,
} from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';
import { CertificateType } from '../enums';

export class AddCertificateDto {
  @ApiProperty({
    example: 'health',
    enum: CertificateType,
    description: 'Certificate type',
  })
  @IsEnum(CertificateType)
  @IsNotEmpty()
  type: CertificateType;

  @ApiProperty({ example: 'HC123456', description: 'Certificate number' })
  @IsString()
  @IsNotEmpty()
  certificateNumber: string;

  @ApiProperty({ example: '2024-01-01', description: 'Issue date' })
  @IsDateString()
  @IsNotEmpty()
  issueDate: string;

  @ApiProperty({ example: '2025-01-01', description: 'Expiry date' })
  @IsDateString()
  @IsNotEmpty()
  expiryDate: string;
}
